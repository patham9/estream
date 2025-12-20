!(import! &self ../temporal/lib_nars_temporal)

;Just helper interface for convenient input and query:
(= (AddSeq $inp)
   (let $part (superpose $inp)
              (AddEvent $part)))

(= (AddSeqWithTick $inp)
   (let $part (superpose $inp)
              (AddEvent (cons t $part))))

(= (GetBeliefTV $c)
   (match &concepts (Concept $_ $_ $_ (Sentence ($c $tv) $_)) $tv))

(= (GetBeliefTVAndExp $c)
   (let $tv (GetBeliefTV $c)
        ($tv (Truth_Expectation $tv))))
