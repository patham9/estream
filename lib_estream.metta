!(import! &self (library estream procedural/control))

;;;;;;;;;;; CONFIGURATION ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Maximum sequence length:
(= (Temporal.MaxSequenceLength) 3) ; 30)

;Maximum parallel conjunction length:
(= (Temporal.MaxParallelConjunctionLength) 3)

;How many derivation steps (task selections) per event:
(= (Declarative.MaxSteps) 1)

;Size of active tasks PQ:
(= (Declarative.TaskQueueSize) 10)

;Max beliefs buffer size
(= (Declarative.BeliefQueueSize) 10)

;Initial knowledge items:
(= (kbitem) (empty))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
