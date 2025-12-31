!(import! &self (library estream lib_estream))

!(AddSeq ((a x t)   ;t=1
          (b x t)   ;t=2
          (c x t)   ;t=4
          (a x t))) ;t=5

!(test (let ((($term HYPOTHESIS $WHATEVER) $tv)) (AddEvent (b x t)) ;t=6
            $term)
       (&| c x))
