!(import! &self (library estream lib_estream))

!(AddSeq ((x) (a b c) (c d)))

;one-step dependency:

!(test (GetBeliefTV (=/> a c))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> a d))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> b c))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> b d))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> (&| a b) c))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> (&| a b) d))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> (&| b c) c))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> (&| b c) d))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> (&| a c) c))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> (&| a c) d))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> (&| a b c) c))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> (&| a b c) d))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> a (&| c d)))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> b (&| c d)))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> c (&| c d)))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> (&| a b) (&| c d)))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> (&| b c) (&| c d)))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> (&| a c) (&| c d)))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> (&| a b c) (&| c d)))
       (stv 1.0 0.30916030534351147))

;two-step dependency:

!(test (GetBeliefTV (=/> (&/ x a) c))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> (&/ x a) d))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> (&/ x b) c))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> (&/ x b) d))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> (&/ x (&| a b)) c))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> (&/ x (&| a b)) d))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> (&/ x (&| b c)) c))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> (&/ x (&| b c)) d))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> (&/ x (&| a c)) c))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> (&/ x (&| a c)) d))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> (&/ x (&| a b c)) c))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> (&/ x (&| a b c)) d))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> (&/ x a) (&| c d)))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> (&/ x b) (&| c d)))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> (&/ x c) (&| c d)))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> (&/ x (&| a b)) (&| c d)))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> (&/ x (&| b c)) (&| c d)))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> (&/ x (&| a c)) (&| c d)))
       (stv 1.0 0.30916030534351147))

!(test (GetBeliefTV (=/> (&/ x (&| a b c)) (&| c d)))
       (stv 1.0 0.30916030534351147))
