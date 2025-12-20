!(import! &self ../lib_nars)

!(AddSeq ((a b 1) (x y 10) (a b 2) (x y 11)
          (a b 3) (x y 12) (a b 4) (x y 13)))

!(test (let ((($term HYPOTHESIS $WHATEVER) $tv)) (AddEvent (a b 5))
            $term)
       (&| x y))
