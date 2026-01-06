!(import! &self (library estream lib_estream))


!(set-actions (^left ^right))
!(AddSeq ((a) (^right) (b) (^left) (a)))

!(test (processGoals (b) False) ^right)

