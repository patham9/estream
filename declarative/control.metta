!(import! &self (library estream declarative/truth_functions))
!(import! &self (library estream declarative/inference_rules))

;;How many derivation steps (task selections)
(= (NARS.Config.MaxSteps) 100)

;;Size of active tasks PQ
(= (NARS.Config.TaskQueueSize) 10)

;;Max beliefs buffer size
(= (NARS.Config.BeliefQueueSize) 100)

;;Whether evidence was just counted once
(= (StampDisjoint $Ev1 $Ev2)
   (== () (collapse (let* (($x (superpose $Ev1))
                           ($y (superpose $Ev2)))
                          (case (== $x $y) ((True True)))))))

;;Concat stamp with sorting
(= (StampConcat $stamp $addition)
   (if (== $addition ())
       $stamp
       (msort (append $stamp $addition))))

;;retrieve the best candidate (PQ functionality)
(= (BestCandidate $evaluateCandidateFunction $bestCandidate $tuple)
   (if (== $tuple ())
       $bestCandidate
       (let* (($head (car-atom $tuple))
              ($tail (cdr-atom $tuple)))
             (if (> ($evaluateCandidateFunction $head)
                    ($evaluateCandidateFunction $bestCandidate))
                 (BestCandidate $evaluateCandidateFunction $head $tail)
                 (BestCandidate $evaluateCandidateFunction $bestCandidate $tail)))))

;;candidate evaluation based on priority
(= (PriorityRank (Sentence ($x (stv $f $c)) $Ev1)) $c)
(= (PriorityRank ()) -99999.0)

;;candidate elimination based on negated priority
(= (PriorityRankNeg (Sentence ($x (stv $f $c)) $Ev1)) (- 0.0 $c))
(= (PriorityRankNeg ()) -99999.0)

;;Return limited-sized version of $L (bounded PQ functionality)
(= (LimitSize $L $size)
   (if (< (length $L) $size)
       $L
       (let $lowestPriorityItem (BestCandidate PriorityRankNeg () $L)
            (LimitSize (exclude-item $lowestPriorityItem $L) $size))))

;;Priority-queue based task ranking deriver with belief buffer
(= (NARS.Derive $Bidirectional $Tasks $Beliefs $steps $maxsteps $taskqueuesize $beliefqueuesize)
   (if (or (> $steps $maxsteps) (== $Tasks ()))
       ($Tasks $Beliefs)
       (let (Sentence $x $Ev1) (BestCandidate PriorityRank () $Tasks)
            (let $derivations
                 (collapse (superpose ((let* (((Sentence $y $Ev2) (superpose $Beliefs))
                                              ($stamp (msort (append $Ev1 $Ev2))))
                                             (if (StampDisjoint $Ev1 $Ev2)
                                                 (case (superpose ((|- $x $y)
                                                                   (if $Bidirectional (|- $y $x) (empty))))
                                                       ((($T $TV) (Sentence ($T $TV) $stamp))))
                                                 (empty)))
                                       (case (|- $x) ((($T3 $TV3) (Sentence ($T3 $TV3) $Ev1)))))))
                 (let $temp (trace! (SELECTED $steps (Sentence $x $Ev1)) 42)
                            (NARS.Derive $Bidrectional
                                         (LimitSize (exclude-item (Sentence $x $Ev1) (list_to_set (append $Tasks $derivations))) $taskqueuesize)
                                         (LimitSize (list_to_set (append $Beliefs $derivations)) $beliefqueuesize)
                                         (+ $steps 1)
                                         $maxsteps
                                         $taskqueuesize
                                         $beliefqueuesize))))))

(= (NARS.Derive $Bidrectional $Tasks $Beliefs $maxsteps $taskqueuesize $beliefqueuesize)
   (NARS.Derive $Bidrectional $Tasks $Beliefs 1 $maxsteps $taskqueuesize $beliefqueuesize))
