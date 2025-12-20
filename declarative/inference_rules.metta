;; INFERENCE RULES

;;NAL-1
;;!Revision
(= (|- ($T $T1) ($T $T2)) ($T (Truth_Revision $T1 $T2)))
;;!Syllogistic rules for -->:
(= (|- ((--> $a $b) $T1) ((--> $b $c) $T2)) ((--> $a $c) (Truth_Deduction $T1 $T2)))
(= (|- ((--> $a $b) $T1) ((--> $a $c) $T2)) ((--> $c $b) (Truth_Induction $T1 $T2)))
(= (|- ((--> $a $c) $T1) ((--> $b $c) $T2)) ((--> $b $a) (Truth_Abduction $T1 $T2)))
(= (|- ((--> $a $b) $T1) ((--> $b $c) $T2)) ((--> $c $a) (Truth_Exemplification $T1 $T2)))

;;NAL-3
;;!Set decomposition:
(= (|- ((--> ({} $A $B) $M) $T)) ((--> ({} $A) $M) (Truth_StructuralDeduction $T)))
(= (|- ((--> ({} $A $B) $M) $T)) ((--> ({} $B) $M) (Truth_StructuralDeduction $T)))
(= (|- ((--> $M ([] $A $B)) $T)) ((--> $M ([] $A)) (Truth_StructuralDeduction $T)))
(= (|- ((--> $M ([] $A $B)) $T)) ((--> $M ([] $B)) (Truth_StructuralDeduction $T)))
;;!Extensional and intensional intersection decomposition:
(= (|- ((--> (∪ $S $P) $M) $T)) ((--> $S $M) (Truth_StructuralDeduction $T)))
(= (|- ((--> $M (∩ $S $P)) $T)) ((--> $M $S) (Truth_StructuralDeduction $T)))
(= (|- ((--> (∪ $S $P) $M) $T)) ((--> $P $M) (Truth_StructuralDeduction $T)))
(= (|- ((--> $M (∩ $S $P)) $T)) ((--> $M $P) (Truth_StructuralDeduction $T)))
(= (|- ((--> (~ $A $S) $M) $T)) ((--> $A $M) (Truth_StructuralDeduction $T)))
(= (|- ((--> $M (− $B $S)) $T)) ((--> $M $B) (Truth_StructuralDeduction $T)))
(= (|- ((--> (~ $A $S) $M) $T)) ((--> $S $M) (Truth_StructuralDeductionNegated $T)))
(= (|- ((--> $M (− $B $S)) $T)) ((--> $M $S) (Truth_StructuralDeductionNegated $T)))
;;!Extensional and intensional intersection decomposition:
(= (|- ((--> $S $M) $T1) ((--> (∪ $S $P) $M) $T2)) ((--> $P $M) (Truth_DecomposePNN $T1 $T2)))
(= (|- ((--> $P $M) $T1) ((--> (∪ $S $P) $M) $T2)) ((--> $S $M) (Truth_DecomposePNN $T1 $T2)))
(= (|- ((--> $S $M) $T1) ((--> (∩ $S $P) $M) $T2)) ((--> $P $M) (Truth_DecomposeNPP $T1 $T2)))
(= (|- ((--> $P $M) $T1) ((--> (∩ $S $P) $M) $T2)) ((--> $S $M) (Truth_DecomposeNPP $T1 $T2)))
(= (|- ((--> $S $M) $T1) ((--> (~ $S $P) $M) $T2)) ((--> $P $M) (Truth_DecomposePNP $T1 $T2)))
(= (|- ((--> $S $M) $T1) ((--> (~ $P $S) $M) $T2)) ((--> $P $M) (Truth_DecomposeNNN $T1 $T2)))
(= (|- ((--> $M $S) $T1) ((--> $M (∩ $S $P)) $T2)) ((--> $M $P) (Truth_DecomposePNN $T1 $T2)))
(= (|- ((--> $M $P) $T1) ((--> $M (∩ $S $P)) $T2)) ((--> $M $S) (Truth_DecomposePNN $T1 $T2)))
(= (|- ((--> $M $S) $T1) ((--> $M (∪ $S $P)) $T2)) ((--> $M $P) (Truth_DecomposeNPP $T1 $T2)))
(= (|- ((--> $M $P) $T1) ((--> $M (∪ $S $P)) $T2)) ((--> $M $S) (Truth_DecomposeNPP $T1 $T2)))
(= (|- ((--> $M $S) $T1) ((--> $M (− $S $P)) $T2)) ((--> $M $P) (Truth_DecomposePNP $T1 $T2)))
(= (|- ((--> $M $S) $T1) ((--> $M (− $P $S)) $T2)) ((--> $M $P) (Truth_DecomposeNNN $T1 $T2)))

;; NAL-4
;;!Rules for more efficient reasoning about relation components:
(= (|- ((--> (× $A $B) $R) $T1) ((--> (× $C $B) $R) $T2)) ((--> $C $A) (Truth_Abduction $T1 $T2)))
(= (|- ((--> (× $A $B) $R) $T1) ((--> (× $A $C) $R) $T2)) ((--> $C $B) (Truth_Abduction $T1 $T2)))
(= (|- ((--> $R (× $A $B)) $T1) ((--> $R (× $C $B)) $T2)) ((--> $C $A) (Truth_Induction $T1 $T2)))
(= (|- ((--> $R (× $A $B)) $T1) ((--> $R (× $A $C)) $T2)) ((--> $C $B) (Truth_Induction $T1 $T2)))
(= (|- ((--> (× $A $B) $R) $T1) ((--> $C $A) $T2)) ((--> (× $C $B) $R) (Truth_Deduction $T1 $T2)))
(= (|- ((--> (× $A $B) $R) $T1) ((--> $A $C) $T2)) ((--> (× $C $B) $R) (Truth_Induction $T1 $T2)))
(= (|- ((--> (× $A $B) $R) $T1) ((--> $C $B) $T2)) ((--> (× $A $C) $R) (Truth_Deduction $T1 $T2)))
(= (|- ((--> (× $A $B) $R) $T1) ((--> $B $C) $T2)) ((--> (× $A $C) $R) (Truth_Induction $T1 $T2)))
(= (|- ((--> $R (× $A $B)) $T1) ((--> $A $C) $T2)) ((--> $R (× $C $B)) (Truth_Deduction $T1 $T2)))
(= (|- ((--> $R (× $A $B)) $T1) ((--> $C $A) $T2)) ((--> $R (× $C $B)) (Truth_Abduction $T1 $T2)))
(= (|- ((--> $R (× $A $B)) $T1) ((--> $B $C) $T2)) ((--> $R (× $A $C)) (Truth_Deduction $T1 $T2)))
(= (|- ((--> $R (× $A $B)) $T1) ((--> $C $B) $T2)) ((--> $R (× $A $C)) (Truth_Abduction $T1 $T2)))

;;NAL-5
;;!Negation ∧ and ∨ decomposition:
(= (|- ((¬ $A) $T)) ($A (Truth_Negation $T)))
(= (|- ((∧ $A $B) $T)) ($A (Truth_StructuralDeduction $T)))
(= (|- ((∧ $A $B) $T)) ($B (Truth_StructuralDeduction $T)))
(= (|- ($S $T1) ((∧ $S $A) $T2)) ($A (Truth_DecomposePNN $T1 $T2)))
(= (|- ($S $T1) ((∨ $S $A) $T2)) ($A (Truth_DecomposeNPP $T1 $T2)))
(= (|- ($S $T1) ((∧ (¬ $S) $A) $T2)) ($A (Truth_DecomposeNNN $T1 $T2)))
(= (|- ($S $T1) ((∨ (¬ $S) $A) $T2)) ($A (Truth_DecomposePPP $T1 $T2)))
;;!Higher-order decomposition
(= (|- ($A $T1) ((==> $A $B) $T2)) ($B (Truth_Deduction $T1 $T2)))
(= (|- ($A $T1) ((==> (∧ $A $B) $C) $T2)) ((==> $B $C) (Truth_Deduction $T1 $T2)))
(= (|- ($B $T1) ((==> $A $B) $T2)) ($A (Truth_Abduction $T1 $T2)))
