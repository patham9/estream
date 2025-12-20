!(import! &self ../declarative/lib_nars_declarative)
!(import! &self ../temporal/lib_fifo)
!(import! &self (library lib_spaces))
!(import! &self (library lib_combinatorics))
!(import! &self (library lib_roman))

;Configuration:
(= (maxsequencelen) 3) ; 30)
(= (maxparconjlen) 3)
(= (kbitem) (empty))

;Running evidence id:
!(bind! &id (new-state 0))
(= (id) (progn (change-state! &id (+ (get-state &id) 1))
               (get-state &id)))

;Individual sequence construction step:
(= (build_sequence_step $Connector $OptionsA $OptionsB)
   (if (== $OptionsA Nil)
       $OptionsB
       (let* (((Sentence ($ATerm $ATV) $AEv) (superpose $OptionsA))
              ((Sentence ($BTerm $BTV) $BEv) (superpose $OptionsB)))
             (if (StampDisjoint $AEv $BEv)
                 ((Sentence ((if (= $ATerm (cons $Connector $Seq))
                                 (cons $Connector (append $Seq ($BTerm)))
                                 ($Connector $ATerm $BTerm))
                             (Truth_Sequence $ATV $BTV))
                            (StampConcat $AEv $BEv)))))))

;Build the possible sequences from the FIFO:
(= (FIFOSequences)
   (let* (($fifo (reverse (EventList)))
          ($length (range 1 (+ 1 (min (length $fifo) (maxsequencelen))))))
         (foldl-atom (reverse (takeK $length $fifo)) Nil (build_sequence_step &/))))

;Anticipation: go through all sequences, and then retrieve all =/> concepts with that sequence as prediction
;then check if the postcondition is included in novelEvents, if not generate negative evidence:
(= (Anticipate $sequence $novelEvents $newid)
   (collapse (let* (((Sentence ($seqterm $seqtv) $ev) $sequence)
                    ($cterm (=/> $seqterm $cpostcond)))
         (match &concepts (Concept $anykey $anyprekey $anyconskey (Sentence ($cterm $ctv) $cev))
                (if (not (is-member $cpostcond (map-atom $novelEvents (|-> ((Sentence ($term $tv) $ev)) $term))))
                    (Add_=/> (Sentence ($cterm (Truth_Eternalize (Truth_Induction (stv 0.0 0.9) (stv 1.0 0.9)))) ($newid))))))))

;Temporal inference pathway:
(= (TemporalInduction $novelEvents)
   (let* (($sequences (FIFOSequences))
          ((@ $sequence (Sentence ($Term1 $STV1) $Ev1)) (superpose $sequences))
          ($newid (id))
          ($anticipations  (collapse (Anticipate $sequence $novelEvents $newid)))
          ((Sentence ($Term2 $STV2) $Ev2) (superpose $novelEvents)))
         (Sentence ((=/> $Term1 $Term2) (Truth_Eternalize (Truth_Induction $STV1 $STV2))) (StampConcat $Ev1 $Ev2))))

;For two sentence, if the stamp is disjoint, we can revise, else return the higher-confident option:
(= (revise_or_choice_=/> (@ $s1 (Sentence ($term (@ $truth1 (stv $f1 $c1))) $Ev1))
                         (@ $s2 (Sentence ($term (@ $truth2 (stv $f2 $c2))) $Ev2)))
   (if (StampDisjoint $Ev1 $Ev2)
       (Sentence ($term (Truth_Revision $truth1 $truth2)) (StampConcat $Ev1 $Ev2))
       (if (> $c1 $c2)
           $s1 $s2)))

;Add =/> node to &concepts, triggering revision_or_choice if existing:
(= (Add_=/> (@ $s (Sentence ((@ $term (=/> $pre $cons)) $truth) $stamp)))
   (let* (($key (repra $term))
          ($prekey (repra $pre))
          ($conskey (repra $cons))
          ($item (Concept $key $prekey $conskey $v))
          ($Li (collapse (once (match &concepts $item $item)))))
         (if (== () $Li)
             (add-atom &concepts (Concept $key $prekey $conskey $s))
             (let* (((Concept $key $prekey $conskey $belief) (car-atom $Li))
                    ($updated (revise_or_choice_=/> $s $belief)))
                   ((remove-atom &concepts (Concept $key $prekey $conskey $w))
                    (add-atom &concepts (Concept $key $prekey $conskey $updated)))))))


(= (SequLen (cons &| $rest))
   (progn (cut) (length $rest)))
(= (SequLen $other) 1)

;Truth expectation to rank the predictions according to chance of occurrence
(= (ExpectationRank (($postcon $label $hypterm) $tv)) (let $cardinality_P (SequLen $postcon)
                                                           (* (sqrt-math $cardinality_P) (Truth_Expectation $tv))))
(= (ExpectationRank ()) -9999)

;Addon to show the best prediction and hypothesis it is based on:
(= (PredictMostLikelyNextEvent)
   (let $Preds (collapse (let* (($sequences (FIFOSequences))
                                ($sequence (superpose $sequences))
                                ((Sentence (@ $seqwithtv ($seqterm $seqtv)) $ev) $sequence)
                                ($cterm (=/> $seqterm $cpostcond))
                                ($prekey (repra $seqterm)))
                               (match &concepts (Concept $anykey $prekey $anyconskey (Sentence ($cterm $ctv) $cev))
                                                (($cpostcond HYPOTHESIS $cterm) (Truth_Deduction $seqtv $ctv)))))
        (BestCandidate ExpectationRank () $Preds)))

;Add event to sequence reasoner, triggering a strictly-bounded amount of inference:
(= (AddEvent $term) (AddEvent $term True))
(= (AddEvent $term $adapting)
   (let* (($tmpper (println! (PERCEIVED $term)))
          ;1. Add each term as an event:
          ($obs (collapse (let $evterm (superpose $term)
                                       (Sentence ($evterm (stv 1.0 0.9)) ((id))))))
          ;2. Add declarative inference reults from each event considering our kb, subtracting kb items from the results:
          ($dec (subtraction-atom (list_to_set (append $obs (foldl-atom (collapse (let $s (superpose $obs) 
                                                                                       (second-from-pair (NARS.Derive False ($s) (collapse (kbitem)) 1 10 10))))
                                                                        () append))) (kb)))
          ($tmpdec (println! (DEC $dec)))
          ;3. Form temporal disjunction between all the inputs and derived events:
          ($parconj (foldl-atom (collapse (let $k (range 2 (+ 1 (min (maxparconjlen) (length $dec))))
                                               (foldl-atom (map-atom (chooseK $dec $k) (-> ($x) ($x))) Nil (build_sequence_step &|)))) () append))
          ($tmpconc (println! (CONC $parconj)))
          ;4. Novel events (inputs + additional declarative inference results, concurrent conjunctions:
          ($novel_events (append $dec $parconj))
          ;5. Obtain new temporal induction results based on the new combined events:
          ($hyps (if $adapting (collapse (TemporalInduction $novel_events)) ()))
          ($temp3 (println! (INDUCED $hyps)))
          ;6. Update FIFO with the novel events:
          ($temp4 (EventPushBounded $novel_events))
          ;7. Update memory with the new temporal induction results:
          ($hypo (collapse (let $hypo (superpose $hyps) (Add_=/> $hypo))))
          ;8. Predict what event is most likely to follow:
          ($pred (collapse (PredictMostLikelyNextEvent)))
          ($tmp2 (println! (PREDICTED $pred)))
          ($prin (println! (CONCEPTCOUNT (match-count &concepts $anypattern)))))
         $pred))

