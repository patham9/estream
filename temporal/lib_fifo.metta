!(import! &self (library lib_datastructures))

;Initialize global queue with size 0:
!(bind! &queue (new-state (queue () () 0)))

;Backup of entire FIFO
(= (FIFO-Backup)
   (get-state &queue))

;Restoration of FIFO:
(= (FIFO-Restore $backup)
   (change-state! &queue $backup))

;Push event (increment handled by enqueue):
(= (EventPush $E)
   (let $newqueue (enqueue $E (get-state &queue))
        (change-state! &queue $newqueue)))

;Pop event (decrement handled by dequeue):
(= (EventPop)
   (let* (($newqueue (dequeue $E (get-state &queue)))
          ($tmp (change-state! &queue $newqueue)))
         $E))

;Get full list of events:
(= (EventList)
   (let (queue $In $Out $N) (get-state &queue)
        (append $Out (reverse $In))))

;Get queue size:
(= (EventSize)
   (let (queue $In $Out $N) (get-state &queue)
        $N))

;Bounded push: if size > 10, pop one first:
(= (EventBound) 30)
(= (EventPushBounded $E)
   (let $q (get-state &queue)
        (if (> (EventSize) (EventBound))
            ((EventPop)
             (EventPush $E))
            (EventPush $E))))
