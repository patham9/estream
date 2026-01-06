!(import! &self (library estream temporal/control))

(= (set-goals $goals)
   (change-state! &goals $goals))

(= (set-actions $actions)
   (change-state! &actions $actions))
!(set-actions ())

(= (random-action $L)
   (index-atom $L (random-int 0 (- (length $L) 1))))

(= (processGoals $goals $Adapting)
   (progn (set-goals $goals)
          (let $eventList (GOALS $goals)
               (println! $eventList))
          (let $chosenAction (let $A (collapse (bestFuture))
                                  (if (or (== $A (())) (== $A ()))
                                      (progn (println! "RANDOM CHOICE") (random-action (get-state &actions)))
                                      (progn (println! ("PLANNED CHOICE" $A)) (random-action $A))))
               (progn (AddEvent ($chosenAction) $Adapting)
                      (println! (CHOSE $chosenAction))
                      ;(readln!)
                      $chosenAction))))


(= (replay ()) True)
(= (replay (cons $a $xs))
   (progn
     (AddEvent ($a) False)
     (if (== $xs ())
         True
         (let $P (PredictMostLikelyNextEvent)
              (if (== $P ())
                  False
                  (let (($p $_ $_) $_) $P
                       (progn
                         (AddEvent ($p) False)
                         (replay $xs))))))))
(= (bfs_loop (empty-queue) $N0) ())

(= (bfs_loop $Q $N0)
   (let* (($Q1 (once (dequeue $Acts $Q)))
          ($depth (length $Acts))
          ($L  (FIFO-Backup))
          ;($_ (println! (REPLAY $Acts)))
          ($r  (replay $Acts))
          ;($_ (println! (REPLAYED $Acts $r)))
          ($P (PredictMostLikelyNextEvent))
          ($_  (FIFO-Restore $L))
          ;($_ (println! (RESTOREDfifo $pp)))
          )
     (if (or (or (>= $depth 3) (not $r)) (== $pp ()))
         (bfs_loop $Q1 $N0)
          (if (== $P ())
                  (bfs_loop $Q1 $N0)
                  (let (($p $_ $HYP) $_) $P
                       (if (is-member $p (get-state &goals))
                           (progn (println! (FOUND $Acts $HYP)) (car-atom $Acts))
                           (let* (($Ln (collapse
                                         (for $a (get-state &actions)
                                              (cons $a $Acts))))
                                  ($Q2 (foldl enqueue $Ln $Q1)))
                             (bfs_loop $Q2 (+ $N0 1)))))))))

(= (bestFuture)
   (let* (($Q0 (foldl enqueue (collapse (for $a (get-state &actions) ($a))) (empty-queue))))
         (bfs_loop $Q0 0)))
