!(import! &self ../lib_nars)

(= (kbitem) (Sentence ((--> cat animal) (stv 1.0 0.9)) (-1)))
(= (kbitem) (Sentence ((--> car machine) (stv 1.0 0.9)) (-1)))

!(AddSeq (((--> cat detection)) ((--> car detection))))

!(test (GetBeliefTV (=/> (--> cat detection) (--> car detection)))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> (--> animal detection) (--> car detection)))
       (stv 1.0 0.22307221542227662))

!(test (GetBeliefTV (=/> (--> cat detection) (--> machine detection)))
       (stv 1.0 0.22307221542227662))

!(test (GetBeliefTV (=/> (--> animal detection) (--> machine detection)))
       (stv 1.0 0.1429941372621668))
