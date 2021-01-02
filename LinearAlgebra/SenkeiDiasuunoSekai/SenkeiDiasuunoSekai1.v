Add LoadPath "MyAlgebraicStructure" as MyAlgebraicStructure.
Add LoadPath "Tools" as Tools.
Add LoadPath "BasicProperty" as BasicProperty.

From mathcomp
Require Import ssreflect.
Require Import Coq.Logic.FunctionalExtensionality.
Require Import Coq.Logic.FinFun.
Require Import Coq.Logic.ClassicalDescription.
Require Import Coq.Sets.Ensembles.
Require Import Coq.Sets.Finite_sets.
Require Import Coq.Sets.Finite_sets_facts.
Require Import MyAlgebraicStructure.MyField.
Require Import MyAlgebraicStructure.MyVectorSpace.
Require Import Tools.MySum.

Section Senkeidaisuunosekai1.

Definition VSPCM (V : VectorSpace) : CommutativeMonoid := mkCommutativeMonoid (VT V) (VO V) (Vadd V) (Vadd_comm V) (Vadd_O_r V) (Vadd_assoc V).

Definition DirectSumField (f : Field) (T : Type) := {G : T -> FT f | Finite T (fun (t : T) => G t <> FO f)}.

Definition BasisVS (V : VectorSpace) (T : Type) := fun (F : T -> VT V) => Bijective (DirectSumField (VF V) T) (VT V) (fun (g : DirectSumField (VF V) T) => MySumF2 T (exist (Finite T) (fun (t : T) => proj1_sig g t <> FO (VF V)) (proj2_sig g)) (VSPCM V) (fun (t : T) => Vmul V (proj1_sig g t) (F t))).

Definition SubspaceVS (V : VectorSpace) := fun (W : Ensemble (VT V)) => (forall (v1 v2 : VT V), In (VT V) W v1 -> In (VT V) W v2 -> In (VT V) W (Vadd V v1 v2)) /\ (forall (f : FT (VF V)) (v : VT V), In (VT V) W v -> In (VT V) W (Vmul V f v)) /\ (In (VT V) W (VO V)).

Lemma SubspaceMakeVSVoppSub : forall (V : VectorSpace) (W : Ensemble (VT V)), (SubspaceVS V W) -> forall (v : VT V), (In (VT V) W v) -> (In (VT V) W (Vopp V v)).
Proof.
move=> V W H1 v H2.
rewrite - (Vmul_I_l V (Vopp V v)).
rewrite - (Vopp_mul_distr_r V (FI (VF V)) v).
rewrite (Vopp_mul_distr_l V (FI (VF V)) v).
apply (proj1 (proj2 H1) (Fopp (VF V) (FI (VF V))) v H2).
Qed.

Definition SubspaceMakeVST (V : VectorSpace) (W : Ensemble (VT V)) (H : SubspaceVS V W) := {x : (VT V) | In (VT V) W x}.

Definition SubspaceMakeVSVO (V : VectorSpace) (W : Ensemble (VT V)) (H : SubspaceVS V W) := (exist W (VO V) (proj2 (proj2 H))).

Definition SubspaceMakeVSVadd (V : VectorSpace) (W : Ensemble (VT V)) (H : SubspaceVS V W) := fun (v1 v2 : SubspaceMakeVST V W H) => (exist W (Vadd V (proj1_sig v1) (proj1_sig v2)) (proj1 H (proj1_sig v1) (proj1_sig v2) (proj2_sig v1) (proj2_sig v2))).

Definition SubspaceMakeVSVmul (V : VectorSpace) (W : Ensemble (VT V)) (H : SubspaceVS V W) := fun (f : FT (VF V)) (v : SubspaceMakeVST V W H) => (exist W (Vmul V f (proj1_sig v)) (proj1 (proj2 H) f (proj1_sig v) (proj2_sig v))).

Definition SubspaceMakeVSVopp (V : VectorSpace) (W : Ensemble (VT V)) (H : SubspaceVS V W) := fun (v : SubspaceMakeVST V W H) => (exist W (Vopp V (proj1_sig v)) (SubspaceMakeVSVoppSub V W H (proj1_sig v) (proj2_sig v))).

Lemma SubspaceMakeVSVadd_comm : forall (V : VectorSpace) (W : Ensemble (VT V)) (H : SubspaceVS V W) (v1 v2 : SubspaceMakeVST V W H), SubspaceMakeVSVadd V W H v1 v2 = SubspaceMakeVSVadd V W H v2 v1.
Proof.
move=> V W H1 v1 v2.
apply sig_map.
apply (Vadd_comm V (proj1_sig v1) (proj1_sig v2)).
Qed.

Lemma SubspaceMakeVSVadd_assoc : forall (V : VectorSpace) (W : Ensemble (VT V)) (H : SubspaceVS V W) (v1 v2 v3 : SubspaceMakeVST V W H), SubspaceMakeVSVadd V W H (SubspaceMakeVSVadd V W H v1 v2) v3 = SubspaceMakeVSVadd V W H v1 (SubspaceMakeVSVadd V W H v2 v3).
Proof.
move=> V W H1 v1 v2 v3.
apply sig_map.
apply (Vadd_assoc V (proj1_sig v1) (proj1_sig v2) (proj1_sig v3)).
Qed.

Lemma SubspaceMakeVSVadd_O_l : forall (V : VectorSpace) (W : Ensemble (VT V)) (H : SubspaceVS V W) (v : SubspaceMakeVST V W H), SubspaceMakeVSVadd V W H (SubspaceMakeVSVO V W H) v = v.
Proof.
move=> V W H1 v.
apply sig_map.
apply (Vadd_O_l V (proj1_sig v)).
Qed.

Lemma SubspaceMakeVSVadd_opp_r : forall (V : VectorSpace) (W : Ensemble (VT V)) (H : SubspaceVS V W) (v : SubspaceMakeVST V W H), SubspaceMakeVSVadd V W H v (SubspaceMakeVSVopp V W H v) = SubspaceMakeVSVO V W H.
Proof.
move=> V W H1 v.
apply sig_map.
apply (Vadd_opp_r V (proj1_sig v)).
Qed.

Lemma SubspaceMakeVSVmul_add_distr_l : forall (V : VectorSpace) (W : Ensemble (VT V)) (H : SubspaceVS V W) (f : FT (VF V)) (v1 v2 : SubspaceMakeVST V W H), SubspaceMakeVSVmul V W H f (SubspaceMakeVSVadd V W H v1 v2) = (SubspaceMakeVSVadd V W H (SubspaceMakeVSVmul V W H f v1) (SubspaceMakeVSVmul V W H f v2)).
Proof.
move=> V W H1 f v1 v2.
apply sig_map.
apply (Vmul_add_distr_l V f (proj1_sig v1) (proj1_sig v2)).
Qed.

Lemma SubspaceMakeVSVmul_add_distr_r : forall (V : VectorSpace) (W : Ensemble (VT V)) (H : SubspaceVS V W) (f1 f2 : FT (VF V)) (v : SubspaceMakeVST V W H), (SubspaceMakeVSVmul V W H (Fadd (VF V) f1 f2) v) = (SubspaceMakeVSVadd V W H (SubspaceMakeVSVmul V W H f1 v) (SubspaceMakeVSVmul V W H f2 v)).
Proof.
move=> V W H f1 f2 v.
apply sig_map.
apply (Vmul_add_distr_r V f1 f2 (proj1_sig v)).
Qed.

Lemma SubspaceMakeVSVmul_assoc : forall (V : VectorSpace) (W : Ensemble (VT V)) (H : SubspaceVS V W) (f1 f2 : FT (VF V)) (v : SubspaceMakeVST V W H), (SubspaceMakeVSVmul V W H f1 (SubspaceMakeVSVmul V W H f2 v)) = (SubspaceMakeVSVmul V W H (Fmul (VF V) f1 f2) v).
Proof.
move=> V W H f1 f2 v.
apply sig_map.
apply (Vmul_assoc V f1 f2 (proj1_sig v)).
Qed.

Lemma SubspaceMakeVSVmul_I_l : forall (V : VectorSpace) (W : Ensemble (VT V)) (H : SubspaceVS V W) (v : SubspaceMakeVST V W H), (SubspaceMakeVSVmul V W H (FI (VF V)) v) = v.
Proof.
move=> V W H v.
apply sig_map.
apply (Vmul_I_l V (proj1_sig v)).
Qed.

Definition SubspaceMakeVS (V : VectorSpace) (W : Ensemble (VT V)) (H : SubspaceVS V W) := mkVectorSpace (VF V) (SubspaceMakeVST V W H) (SubspaceMakeVSVO V W H) (SubspaceMakeVSVadd V W H) (SubspaceMakeVSVmul V W H) (SubspaceMakeVSVopp V W H) (SubspaceMakeVSVadd_comm V W H) (SubspaceMakeVSVadd_assoc V W H) (SubspaceMakeVSVadd_O_l V W H) (SubspaceMakeVSVadd_opp_r V W H) (SubspaceMakeVSVmul_add_distr_l V W H) (SubspaceMakeVSVmul_add_distr_r V W H) (SubspaceMakeVSVmul_assoc V W H) (SubspaceMakeVSVmul_I_l V W H).

Lemma FullsetSubspaceVS : forall (V : VectorSpace), SubspaceVS V (Full_set (VT V)).
Proof.
move=> V.
apply conj.
move=> v1 v2 H1 H2.
apply (Full_intro (VT V) (Vadd V v1 v2)).
apply conj.
move=> f v H1.
apply (Full_intro (VT V) (Vmul V f v)).
apply (Full_intro (VT V) (VO V)).
Qed.

Lemma VOSubspaceVS : forall (V : VectorSpace), SubspaceVS V (Singleton (VT V) (VO V)).
Proof.
move=> V.
apply conj.
move=> v1 v2.
elim.
elim.
rewrite (Vadd_O_l V (VO V)).
apply (In_singleton (VT V) (VO V)).
apply conj.
move=> f v.
elim.
rewrite (Vmul_O_r V f).
apply (In_singleton (VT V) (VO V)).
apply (In_singleton (VT V) (VO V)).
Qed.

Lemma SingleSubspaceVS : forall (V : VectorSpace) (v : VT V), SubspaceVS V (fun (v0 : VT V) => exists (f : FT (VF V)), v0 = Vmul V f v).
Proof.
move=> V v.
apply conj.
move=> v1 v2.
elim.
move=> f1 H1.
elim.
move=> f2 H2.
exists (Fadd (VF V) f1 f2).
rewrite H1.
rewrite H2.
rewrite (Vmul_add_distr_r V f1 f2 v).
reflexivity.
apply conj.
move=> f v0.
elim.
move=> g H1.
exists (Fmul (VF V) f g).
rewrite H1.
apply (Vmul_assoc V f g v).
exists (FO (VF V)).
rewrite (Vmul_O_l V v).
reflexivity.
Qed.

Definition SpanVS (V : VectorSpace) (T : Type) (x : T -> VT V) := fun (v : VT V) => exists (a : DirectSumField (VF V) T), v = MySumF2 T (exist (Finite T) (fun (t : T) => proj1_sig a t <> FO (VF V)) (proj2_sig a)) (VSPCM V) (fun (t : T) => Vmul V (proj1_sig a t) (x t)).

Lemma SpanSubspaceVS (V : VectorSpace) (T : Type) (x : T -> VT V) : SubspaceVS V (SpanVS V T x).
Proof.
apply conj.
move=> v1 v2.
elim.
move=> a1 H1.
elim.
move=> a2 H2.
suff: (Finite T (fun (t : T) => Fadd (VF V) (proj1_sig a1 t) (proj1_sig a2 t) <> FO (VF V))).
move=> H3.
exists (exist (fun (G : T -> FT (VF V)) => Finite T (fun t : T => G t <> FO (VF V))) (fun (t : T) => Fadd (VF V) (proj1_sig a1 t) (proj1_sig a2 t)) H3).
suff: (MySumF2 T (exist (Finite T) (fun t : T => proj1_sig (exist (fun G : T -> FT (VF V) => Finite T (fun t0 : T => G t0 <> FO (VF V))) (fun t0 : T => Fadd (VF V) (proj1_sig a1 t0) (proj1_sig a2 t0)) H3) t <> FO (VF V)) (proj2_sig (exist (fun G : T -> FT (VF V) => Finite T (fun t : T => G t <> FO (VF V))) (fun t : T => Fadd (VF V) (proj1_sig a1 t) (proj1_sig a2 t)) H3))) (VSPCM V) (fun t : T => Vmul V (proj1_sig (exist (fun G : T -> FT (VF V) => Finite T (fun t0 : T => G t0 <> FO (VF V))) (fun t0 : T => Fadd (VF V) (proj1_sig a1 t0) (proj1_sig a2 t0)) H3) t) (x t)) = MySumF2 T (FiniteUnion T (exist (Finite T) (fun t : T => proj1_sig a1 t <> FO (VF V)) (proj2_sig a1)) (exist (Finite T) (fun t : T => proj1_sig a2 t <> FO (VF V)) (proj2_sig a2))) (VSPCM V) (fun t : T => Vmul V (proj1_sig (exist (fun G : T -> FT (VF V) => Finite T (fun t0 : T => G t0 <> FO (VF V))) (fun t0 : T => Fadd (VF V) (proj1_sig a1 t0) (proj1_sig a2 t0)) H3) t) (x t))).
move=> H4.
rewrite H4.
suff: (v1 = MySumF2 T (FiniteUnion T (exist (Finite T) (fun t : T => proj1_sig a1 t <> FO (VF V)) (proj2_sig a1)) (exist (Finite T) (fun t : T => proj1_sig a2 t <> FO (VF V)) (proj2_sig a2))) (VSPCM V) (fun t : T => Vmul V (proj1_sig a1 t) (x t))).
move=> H5.
rewrite H5.
suff: (v2 = MySumF2 T (FiniteUnion T (exist (Finite T) (fun t : T => proj1_sig a1 t <> FO (VF V)) (proj2_sig a1)) (exist (Finite T) (fun t : T => proj1_sig a2 t <> FO (VF V)) (proj2_sig a2))) (VSPCM V) (fun t : T => Vmul V (proj1_sig a2 t) (x t))).
move=> H6.
rewrite H6.
apply (FiniteSetInduction T (FiniteUnion T (exist (Finite T) (fun t : T => proj1_sig a1 t <> FO (VF V)) (proj2_sig a1)) (exist (Finite T) (fun t : T => proj1_sig a2 t <> FO (VF V)) (proj2_sig a2)))).
apply conj.
rewrite MySumF2Empty.
rewrite MySumF2Empty.
rewrite MySumF2Empty.
apply (Vadd_O_l V (VO V)).
move=> B b H7 H8 H9.
simpl.
move=> H10.
rewrite MySumF2Add.
rewrite MySumF2Add.
rewrite MySumF2Add.
simpl.
rewrite - H10.
rewrite - (Vadd_assoc V (Vadd V (MySumF2 T B (VSPCM V) (fun t : T => Vmul V (proj1_sig a1 t) (x t))) (Vmul V (proj1_sig a1 b) (x b))) (MySumF2 T B (VSPCM V) (fun t : T => Vmul V (proj1_sig a2 t) (x t))) (Vmul V (proj1_sig a2 b) (x b))).
rewrite (Vadd_comm V (Vadd V (MySumF2 T B (VSPCM V) (fun t : T => Vmul V (proj1_sig a1 t) (x t))) (Vmul V (proj1_sig a1 b) (x b))) (MySumF2 T B (VSPCM V) (fun t : T => Vmul V (proj1_sig a2 t) (x t)))).
rewrite - (Vadd_assoc V (MySumF2 T B (VSPCM V) (fun t : T => Vmul V (proj1_sig a2 t) (x t))) (MySumF2 T B (VSPCM V) (fun t : T => Vmul V (proj1_sig a1 t) (x t))) (Vmul V (proj1_sig a1 b) (x b))).
rewrite (Vadd_comm V (MySumF2 T B (VSPCM V) (fun t : T => Vmul V (proj1_sig a2 t) (x t))) (MySumF2 T B (VSPCM V) (fun t : T => Vmul V (proj1_sig a1 t) (x t)))).
rewrite (Vadd_assoc V (Vadd V (MySumF2 T B (VSPCM V) (fun t : T => Vmul V (proj1_sig a1 t) (x t))) (MySumF2 T B (VSPCM V) (fun t : T => Vmul V (proj1_sig a2 t) (x t)))) (Vmul V (proj1_sig a1 b) (x b)) (Vmul V (proj1_sig a2 b) (x b))).
rewrite (Vmul_add_distr_r V (proj1_sig a1 b) (proj1_sig a2 b) (x b)).
reflexivity.
apply H9.
apply H9.
apply H9.
rewrite H2.
rewrite (MySumF2Excluded T (VSPCM V) (fun t : T => Vmul V (proj1_sig a2 t) (x t)) (FiniteUnion T (exist (Finite T) (fun t : T => proj1_sig a1 t <> FO (VF V)) (proj2_sig a1)) (exist (Finite T) (fun t : T => proj1_sig a2 t <> FO (VF V)) (proj2_sig a2))) (fun t : T => proj1_sig a2 t <> FO (VF V))).
suff: ((MySumF2 T (FiniteIntersection T (FiniteUnion T (exist (Finite T) (fun t : T => proj1_sig a1 t <> FO (VF V)) (proj2_sig a1)) (exist (Finite T) (fun t : T => proj1_sig a2 t <> FO (VF V)) (proj2_sig a2))) (Complement T (fun t : T => proj1_sig a2 t <> FO (VF V)))) (VSPCM V) (fun t : T => Vmul V (proj1_sig a2 t) (x t))) = VO V).
move=> H6.
rewrite H6.
simpl.
rewrite (Vadd_O_r V (MySumF2 T (FiniteIntersection T (FiniteUnion T (exist (Finite T) (fun t : T => proj1_sig a1 t <> FO (VF V)) (proj2_sig a1)) (exist (Finite T) (fun t : T => proj1_sig a2 t <> FO (VF V)) (proj2_sig a2))) (fun t : T => proj1_sig a2 t <> FO (VF V))) (VSPCM V) (fun t : T => Vmul V (proj1_sig a2 t) (x t)))).
suff: ((exist (Finite T) (fun t : T => proj1_sig a2 t <> FO (VF V)) (proj2_sig a2)) = (FiniteIntersection T (FiniteUnion T (exist (Finite T) (fun t : T => proj1_sig a1 t <> FO (VF V)) (proj2_sig a1)) (exist (Finite T) (fun t : T => proj1_sig a2 t <> FO (VF V)) (proj2_sig a2))) (fun t : T => proj1_sig a2 t <> FO (VF V)))).
move=> H7.
rewrite - H7.
reflexivity.
apply sig_map.
simpl.
apply Extensionality_Ensembles.
apply conj.
move=> t H7.
apply (Intersection_intro T (fun t0 : T => proj1_sig a2 t0 <> FO (VF V)) (Union T (fun t0 : T => proj1_sig a1 t0 <> FO (VF V)) (fun t0 : T => proj1_sig a2 t0 <> FO (VF V))) t).
apply H7.
right.
apply H7.
move=> t.
elim.
move=> t0 H7 H8.
apply H7.
apply (MySumF2Induction T (FiniteIntersection T (FiniteUnion T (exist (Finite T) (fun t : T => proj1_sig a1 t <> FO (VF V)) (proj2_sig a1)) (exist (Finite T) (fun t : T => proj1_sig a2 t <> FO (VF V)) (proj2_sig a2))) (Complement T (fun t : T => proj1_sig a2 t <> FO (VF V))))).
apply conj.
reflexivity.
simpl.
move=> v u H6 H7.
rewrite H7.
suff: (proj1_sig a2 u = FO (VF V)).
move=> H8.
rewrite H8.
rewrite (Vmul_O_l V (x u)).
apply (Vadd_O_l V (VO V)).
apply NNPP.
elim H6.
move=> u0 H8 H9 H10.
apply (H8 H10).
rewrite H1.
rewrite (MySumF2Excluded T (VSPCM V) (fun t : T => Vmul V (proj1_sig a1 t) (x t)) (FiniteUnion T (exist (Finite T) (fun t : T => proj1_sig a1 t <> FO (VF V)) (proj2_sig a1)) (exist (Finite T) (fun t : T => proj1_sig a2 t <> FO (VF V)) (proj2_sig a2))) (fun t : T => proj1_sig a1 t <> FO (VF V))).
suff: ((MySumF2 T (FiniteIntersection T (FiniteUnion T (exist (Finite T) (fun t : T => proj1_sig a1 t <> FO (VF V)) (proj2_sig a1)) (exist (Finite T) (fun t : T => proj1_sig a2 t <> FO (VF V)) (proj2_sig a2))) (Complement T (fun t : T => proj1_sig a1 t <> FO (VF V)))) (VSPCM V) (fun t : T => Vmul V (proj1_sig a1 t) (x t))) = VO V).
move=> H5.
rewrite H5.
simpl.
rewrite (Vadd_O_r V (MySumF2 T (FiniteIntersection T (FiniteUnion T (exist (Finite T) (fun t : T => proj1_sig a1 t <> FO (VF V)) (proj2_sig a1)) (exist (Finite T) (fun t : T => proj1_sig a2 t <> FO (VF V)) (proj2_sig a2))) (fun t : T => proj1_sig a1 t <> FO (VF V))) (VSPCM V) (fun t : T => Vmul V (proj1_sig a1 t) (x t)))).
suff: ((exist (Finite T) (fun t : T => proj1_sig a1 t <> FO (VF V)) (proj2_sig a1)) = (FiniteIntersection T (FiniteUnion T (exist (Finite T) (fun t : T => proj1_sig a1 t <> FO (VF V)) (proj2_sig a1)) (exist (Finite T) (fun t : T => proj1_sig a2 t <> FO (VF V)) (proj2_sig a2))) (fun t : T => proj1_sig a1 t <> FO (VF V)))).
move=> H6.
rewrite - H6.
reflexivity.
apply sig_map.
simpl.
apply Extensionality_Ensembles.
apply conj.
move=> t H6.
apply (Intersection_intro T (fun t0 : T => proj1_sig a1 t0 <> FO (VF V)) (Union T (fun t0 : T => proj1_sig a1 t0 <> FO (VF V)) (fun t0 : T => proj1_sig a2 t0 <> FO (VF V))) t).
apply H6.
left.
apply H6.
move=> t.
elim.
move=> t0 H6 H7.
apply H6.
apply (MySumF2Induction T (FiniteIntersection T (FiniteUnion T (exist (Finite T) (fun t : T => proj1_sig a1 t <> FO (VF V)) (proj2_sig a1)) (exist (Finite T) (fun t : T => proj1_sig a2 t <> FO (VF V)) (proj2_sig a2))) (Complement T (fun t : T => proj1_sig a1 t <> FO (VF V))))).
apply conj.
reflexivity.
simpl.
move=> v u H5 H6.
rewrite H6.
suff: (proj1_sig a1 u = FO (VF V)).
move=> H7.
rewrite H7.
rewrite (Vmul_O_l V (x u)).
apply (Vadd_O_l V (VO V)).
apply NNPP.
elim H5.
move=> u0 H7 H8 H9.
apply (H7 H9).
rewrite (MySumF2Excluded T (VSPCM V) (fun t : T => Vmul V (proj1_sig (exist (fun G : T -> FT (VF V) => Finite T (fun t0 : T => G t0 <> FO (VF V))) (fun t0 : T => Fadd (VF V) (proj1_sig a1 t0) (proj1_sig a2 t0)) H3) t) (x t)) (FiniteUnion T (exist (Finite T) (fun t : T => proj1_sig a1 t <> FO (VF V)) (proj2_sig a1)) (exist (Finite T) (fun t : T => proj1_sig a2 t <> FO (VF V)) (proj2_sig a2))) (fun t : T => proj1_sig (exist (fun G : T -> FT (VF V) => Finite T (fun t0 : T => G t0 <> FO (VF V))) (fun t0 : T => Fadd (VF V) (proj1_sig a1 t0) (proj1_sig a2 t0)) H3) t <> FO (VF V))).
suff: ((MySumF2 T (FiniteIntersection T (FiniteUnion T (exist (Finite T) (fun t : T => proj1_sig a1 t <> FO (VF V)) (proj2_sig a1)) (exist (Finite T) (fun t : T => proj1_sig a2 t <> FO (VF V)) (proj2_sig a2))) (Complement T (fun t : T => proj1_sig (exist (fun G : T -> FT (VF V) => Finite T (fun t0 : T => G t0 <> FO (VF V))) (fun t0 : T => Fadd (VF V) (proj1_sig a1 t0) (proj1_sig a2 t0)) H3) t <> FO (VF V)))) (VSPCM V) (fun t : T => Vmul V (proj1_sig (exist (fun G : T -> FT (VF V) => Finite T (fun t0 : T => G t0 <> FO (VF V))) (fun t0 : T => Fadd (VF V) (proj1_sig a1 t0) (proj1_sig a2 t0)) H3) t) (x t))) = VO V).
move=> H4.
rewrite H4.
simpl.
rewrite (Vadd_O_r V (MySumF2 T (FiniteIntersection T (FiniteUnion T (exist (Finite T) (fun t : T => proj1_sig a1 t <> FO (VF V)) (proj2_sig a1)) (exist (Finite T) (fun t : T => proj1_sig a2 t <> FO (VF V)) (proj2_sig a2))) (fun t : T => Fadd (VF V) (proj1_sig a1 t) (proj1_sig a2 t) <> FO (VF V))) (VSPCM V) (fun t : T => Vmul V (Fadd (VF V) (proj1_sig a1 t) (proj1_sig a2 t)) (x t)))).
suff: ((exist (Finite T) (fun t : T => Fadd (VF V) (proj1_sig a1 t) (proj1_sig a2 t) <> FO (VF V)) H3) = (FiniteIntersection T (FiniteUnion T (exist (Finite T) (fun t : T => proj1_sig a1 t <> FO (VF V)) (proj2_sig a1)) (exist (Finite T) (fun t : T => proj1_sig a2 t <> FO (VF V)) (proj2_sig a2))) (fun t : T => Fadd (VF V) (proj1_sig a1 t) (proj1_sig a2 t) <> FO (VF V)))).
move=> H5.
rewrite H5.
reflexivity.
apply sig_map.
simpl.
apply Extensionality_Ensembles.
apply conj.
move=> t H5.
apply (Intersection_intro T (fun t0 : T => Fadd (VF V) (proj1_sig a1 t0) (proj1_sig a2 t0) <> FO (VF V)) (Union T (fun t0 : T => proj1_sig a1 t0 <> FO (VF V)) (fun t0 : T => proj1_sig a2 t0 <> FO (VF V))) t).
apply H5.
apply NNPP.
move=> H6.
apply H5.
suff: (proj1_sig a1 t = FO (VF V)).
move=> H7.
rewrite H7.
suff: (proj1_sig a2 t = FO (VF V)).
move=> H8.
rewrite H8.
apply (Fadd_O_l (VF V) (FO (VF V))).
apply NNPP.
move=> H8.
apply H6.
right.
apply H8.
apply NNPP.
move=> H7.
apply H6.
left.
apply H7.
move=> t.
elim.
move=> t0 H5 H6.
apply H5.
apply (MySumF2Induction T (FiniteIntersection T (FiniteUnion T (exist (Finite T) (fun t : T => proj1_sig a1 t <> FO (VF V)) (proj2_sig a1)) (exist (Finite T) (fun t : T => proj1_sig a2 t <> FO (VF V)) (proj2_sig a2))) (Complement T (fun t : T => proj1_sig (exist (fun G : T -> FT (VF V) => Finite T (fun t0 : T => G t0 <> FO (VF V))) (fun t0 : T => Fadd (VF V) (proj1_sig a1 t0) (proj1_sig a2 t0)) H3) t <> FO (VF V))))).
apply conj.
reflexivity.
simpl.
move=> v u H4 H5.
rewrite H5.
suff: ((Fadd (VF V) (proj1_sig a1 u) (proj1_sig a2 u)) = FO (VF V)).
move=> H6.
rewrite H6.
rewrite (Vmul_O_l V (x u)).
apply (Vadd_O_l V (VO V)).
elim H4.
move=> u0 H6 H7.
apply NNPP.
move=> H8.
apply (H6 H8).
suff: (Finite T (Union T (fun t : T => proj1_sig a1 t <> FO (VF V)) (fun t : T => proj1_sig a2 t <> FO (VF V)))).
move=> H3.
apply (Finite_downward_closed T (Union T (fun t : T => proj1_sig a1 t <> FO (VF V)) (fun t : T => proj1_sig a2 t <> FO (VF V))) H3 (fun t : T => Fadd (VF V) (proj1_sig a1 t) (proj1_sig a2 t) <> FO (VF V))).
move=> t H4.
apply NNPP.
move=> H5.
apply H4.
suff: (proj1_sig a1 t) = (FO (VF V)).
move=> H6.
suff: (proj1_sig a2 t) = (FO (VF V)).
move=> H7.
rewrite H6.
rewrite H7.
apply (Fadd_O_r (VF V) (FO (VF V))).
apply NNPP.
move=> H7.
apply H5.
right.
apply H7.
apply NNPP.
move=> H6.
apply H5.
left.
apply H6.
apply (Union_preserves_Finite T (fun t : T => proj1_sig a1 t <> FO (VF V)) (fun t : T => proj1_sig a2 t <> FO (VF V)) (proj2_sig a1) (proj2_sig a2)).
apply conj.
move=> f v.
elim.
move=> a H1.
elim (classic (f = (FO (VF V)))).
move=> H2.
rewrite H2.
rewrite (Vmul_O_l V v).
suff: (Finite T (fun (t : T) => FO (VF V) <> FO (VF V))).
move=> H3.
exists (exist (fun (G : T -> FT (VF V)) => Finite T (fun t : T => G t <> FO (VF V))) (fun (t : T) => FO (VF V)) H3).
suff: ((exist (Finite T) (fun t : T => proj1_sig (exist (fun G : T -> FT (VF V) => Finite T (fun t0 : T => G t0 <> FO (VF V))) (fun _ : T => FO (VF V)) H3) t <> FO (VF V)) (proj2_sig (exist (fun G : T -> FT (VF V) => Finite T (fun t : T => G t <> FO (VF V))) (fun _ : T => FO (VF V)) H3))) = FiniteEmpty T).
move=> H4.
rewrite H4.
rewrite MySumF2Empty.
reflexivity.
apply sig_map.
simpl.
apply Extensionality_Ensembles.
apply conj.
move=> t H4.
apply False_ind.
apply H4.
reflexivity.
move=> t.
elim.
suff: ((fun _ : T => FO (VF V) <> FO (VF V)) = Empty_set T).
move=> H3.
rewrite H3.
apply (Empty_is_finite T).
apply Extensionality_Ensembles.
apply conj.
move=> t H3.
apply False_ind.
apply H3.
reflexivity.
move=> t.
elim.
move=> H2.
suff: (Finite T (fun (t : T) => Fmul (VF V) f (proj1_sig a t) <> FO (VF V))).
move=> H3.
exists (exist (fun (G : T -> FT (VF V)) => Finite T (fun t : T => G t <> FO (VF V))) (fun (t : T) => Fmul (VF V) f (proj1_sig a t)) H3).
rewrite H1.
suff: ((exist (Finite T) (fun t : T => proj1_sig a t <> FO (VF V)) (proj2_sig a)) = (exist (Finite T) (fun t : T => proj1_sig (exist (fun G : T -> FT (VF V) => Finite T (fun t0 : T => G t0 <> FO (VF V))) (fun t0 : T => Fmul (VF V) f (proj1_sig a t0)) H3) t <> FO (VF V)) (proj2_sig (exist (fun G : T -> FT (VF V) => Finite T (fun t : T => G t <> FO (VF V))) (fun t : T => Fmul (VF V) f (proj1_sig a t)) H3)))).
move=> H4.
rewrite H4.
simpl.
apply (FiniteSetInduction T (exist (Finite T) (fun t : T => Fmul (VF V) f (proj1_sig a t) <> FO (VF V)) H3)).
apply conj.
rewrite MySumF2Empty.
rewrite MySumF2Empty.
apply (Vmul_O_r V f).
move=> B b H5 H6 H7 H8.
rewrite MySumF2Add.
rewrite MySumF2Add.
simpl.
rewrite (Vmul_add_distr_l V f (MySumF2 T B (VSPCM V) (fun t : T => Vmul V (proj1_sig a t) (x t))) (Vmul V (proj1_sig a b) (x b))).
rewrite H8.
rewrite (Vmul_assoc V f (proj1_sig a b) (x b)).
reflexivity.
apply H7.
apply H7.
apply sig_map.
simpl.
apply Extensionality_Ensembles.
apply conj.
move=> t H4 H5.
apply H4.
rewrite - (Fmul_I_l (VF V) (proj1_sig a t)).
rewrite - (Finv_l (VF V) f).
rewrite (Fmul_assoc (VF V) (Finv (VF V) f) f (proj1_sig a t)).
rewrite H5.
apply (Fmul_O_r (VF V) (Finv (VF V) f)).
apply H2.
move=> t H4 H5.
apply H4.
rewrite H5.
apply (Fmul_O_r (VF V) f).
suff: ((fun t : T => Fmul (VF V) f (proj1_sig a t) <> FO (VF V)) = (fun t : T => proj1_sig a t <> FO (VF V))).
move=> H3.
rewrite H3.
apply (proj2_sig a).
apply Extensionality_Ensembles.
apply conj.
move=> t H3 H4.
apply H3.
rewrite H4.
apply (Fmul_O_r (VF V) f).
move=> t H3 H4.
apply H3.
rewrite - (Fmul_I_l (VF V) (proj1_sig a t)).
rewrite - (Finv_l (VF V) f).
rewrite (Fmul_assoc (VF V) (Finv (VF V) f) f (proj1_sig a t)).
rewrite H4.
apply (Fmul_O_r (VF V) (Finv (VF V) f)).
apply H2.
suff: (Finite T (fun (t : T) => FO (VF V) <> FO (VF V))).
move=> H1.
exists (exist (fun (G : T -> FT (VF V)) => Finite T (fun t : T => G t <> FO (VF V))) (fun (t : T) => FO (VF V)) H1).
suff: ((exist (Finite T) (fun t : T => proj1_sig (exist (fun G : T -> FT (VF V) => Finite T (fun t0 : T => G t0 <> FO (VF V))) (fun _ : T => FO (VF V)) H1) t <> FO (VF V)) (proj2_sig (exist (fun G : T -> FT (VF V) => Finite T (fun t : T => G t <> FO (VF V))) (fun _ : T => FO (VF V)) H1))) = FiniteEmpty T).
move=> H2.
rewrite H2.
rewrite MySumF2Empty.
reflexivity.
apply sig_map.
simpl.
apply Extensionality_Ensembles.
apply conj.
move=> t H2.
apply False_ind.
apply H2.
reflexivity.
move=> t.
elim.
suff: ((fun _ : T => FO (VF V) <> FO (VF V)) = Empty_set T).
move=> H1.
rewrite H1.
apply (Empty_is_finite T).
apply Extensionality_Ensembles.
apply conj.
move=> t H1.
apply False_ind.
apply H1.
reflexivity.
move=> t.
elim.
Qed.

Lemma SpanContainSelfVS : forall (V : VectorSpace) (T : Type) (x : T -> VT V) (t : T), In (VT V) (SpanVS V T x) (x t).
Proof.
move=> V T x t.
elim (classic (FI (VF V) = FO (VF V))).
move=> H1.
rewrite - (Vmul_I_l V (x t)).
rewrite H1.
rewrite (Vmul_O_l V (x t)).
apply (proj2 (proj2 (SpanSubspaceVS V T x))).
move=> H1.
suff: (Finite T (fun t0 : T => (fun (t1 : T) => match (excluded_middle_informative (t1 = t)) with
  | left _ => FI (VF V)
  | right _ => FO (VF V)
end) t0 <> FO (VF V))).
move=> H2. 
exists (exist (fun (G : T -> FT (VF V)) => Finite T (fun t : T => G t <> FO (VF V))) (fun t0 : T => (fun (t1 : T) => match (excluded_middle_informative (t1 = t)) with
  | left _ => FI (VF V)
  | right _ => FO (VF V)
end) t0) H2).
suff: ((exist (Finite T) (fun t0 : T => proj1_sig (exist (fun G : T -> FT (VF V) => Finite T (fun t1 : T => G t1 <> FO (VF V))) (fun t1 : T => match excluded_middle_informative (t1 = t) with
  | left _ => FI (VF V)
  | right _ => FO (VF V) 
end) H2) t0 <> FO (VF V)) (proj2_sig (exist (fun G : T -> FT (VF V) => Finite T (fun t0 : T => G t0 <> FO (VF V))) (fun t0 : T => match excluded_middle_informative (t0 = t) with
  | left _ => FI (VF V)
  | right _ => FO (VF V) 
end) H2))) = FiniteSingleton T t).
move=> H3.
rewrite H3.
rewrite MySumF2Singleton.
simpl.
elim (excluded_middle_informative (t = t)).
move=> H4.
rewrite (Vmul_I_l V (x t)).
reflexivity.
move=> H4.
apply False_ind.
apply H4.
reflexivity.
apply sig_map.
simpl.
apply Extensionality_Ensembles.
apply conj.
move=> t0.
unfold In.
elim (excluded_middle_informative (t0 = t)).
move=> H3 H4.
rewrite H3.
apply (In_singleton T t).
move=> H3 H4.
apply False_ind.
apply H4.
reflexivity.
move=> t0.
elim.
unfold In.
elim (excluded_middle_informative (t = t)).
move=> H3.
apply H1.
move=> H3 H4.
apply H3.
reflexivity.
suff: ((fun t0 : T => (match excluded_middle_informative (t0 = t) with
  | left _ =>  FI (VF V)
  | right _ => FO (VF V)
end) <> FO (VF V)) = Singleton T t).
move=> H2.
rewrite H2.
apply (Singleton_is_finite T t).
apply Extensionality_Ensembles.
apply conj.
move=> t0.
unfold In.
elim (excluded_middle_informative (t0 = t)).
move=> H2 H3.
rewrite H2.
apply (In_singleton T t).
move=> H2 H3.
apply False_ind.
apply H3.
reflexivity.
move=> t0.
elim.
unfold In.
elim (excluded_middle_informative (t = t)).
move=> H2.
apply H1.
move=> H2 H3.
apply H2.
reflexivity.
Qed.

Definition LinearlyIndependentVS (V : VectorSpace) (T : Type) (F : T -> VT V) := BasisVS (SubspaceMakeVS V (SpanVS V T F) (SpanSubspaceVS V T F)) T (fun (t : T) => exist (SpanVS V T F) (F t) (SpanContainSelfVS V T F t)).

Definition GeneratingSystemVS (V : VectorSpace) (T : Type) (F : T -> VT V) := Full_set (VT V) = SpanVS V T F.

Lemma CountFinite : forall (N : nat), Finite (Count N) (Full_set (Count N)).
Proof.
move=> N.
apply EnsembleSetFinite.
elim N.
suff: ((fun u : nat => (u < 0)%nat) = Empty_set nat).
move=> H1.
rewrite H1.
apply Empty_is_finite.
apply Extensionality_Ensembles.
apply conj.
move=> n H1.
apply False_ind.
apply (PeanoNat.Nat.nlt_0_r n H1).
move=> n.
elim.
move=> n H1.
suff: ((fun u : nat => (u < S n)%nat) = Add nat (fun u : nat => (u < n)%nat) n).
move=> H2.
rewrite H2.
apply (Union_is_finite nat (fun u : nat => (u < n)%nat) H1 n).
apply (lt_irrefl n).
apply Extensionality_Ensembles.
apply conj.
move=> m H2.
elim (classic (m = n)).
move=> H3.
right.
rewrite H3.
reflexivity.
intro H3.
left.
elim (le_lt_or_eq (S m) (S n) H2).
apply (lt_S_n m n).
move=> H4.
apply False_ind.
apply H3.
apply (PeanoNat.Nat.succ_inj m n H4).
move=> m.
elim.
move=> m1 H2.
apply (le_S (S m1) n).
apply H2.
move=> m1 H2.
rewrite H2.
apply (le_n (S m1)).
Qed.

Lemma FiniteBasisVS : forall (V : VectorSpace) (N : nat) (F : Count N -> VT V), (BasisVS V (Count N) F) <-> forall (v : VT V), exists! (a : Count N -> FT (VF V)), v = MySumF2 (Count N) (exist (Finite (Count N)) (Full_set (Count N)) (CountFinite N)) (VSPCM V) (fun (n : Count N) => Vmul V (a n) (F n)).
Proof.
move=> V N F.
unfold BasisVS.
suff: ((fun g : DirectSumField (VF V) (Count N) => MySumF2 (Count N) (exist (Finite (Count N)) (fun t : Count N => proj1_sig g t <> FO (VF V)) (proj2_sig g)) (VSPCM V) (fun t : Count N => Vmul V (proj1_sig g t) (F t))) = (fun g : DirectSumField (VF V) (Count N) => MySumF2 (Count N) (exist (Finite (Count N)) (Full_set (Count N)) (CountFinite N)) (VSPCM V) (fun t : Count N => Vmul V (proj1_sig g t) (F t)))).
move=> H1.
rewrite H1.
apply conj.
elim.
move=> G H2 v.
apply (proj1 (unique_existence (fun (a : Count N -> FT (VF V)) => v = MySumF2 (Count N) (exist (Finite (Count N)) (Full_set (Count N)) (CountFinite N)) (VSPCM V) (fun n : Count N => Vmul V (a n) (F n))))).
apply conj.
exists (proj1_sig (G v)). 
rewrite (proj2 H2 v).
reflexivity.
move=> a1 a2 H3 H4.
suff: (forall (G : Count N -> FT (VF V)), Finite (Count N) (fun t : Count N => G t <> FO (VF V))).
move=> H5.
suff: (a1 = proj1_sig (exist (fun G : Count N -> FT (VF V) => Finite (Count N) (fun t : Count N => G t <> FO (VF V))) a1 (H5 a1))).
move=> H6.
rewrite H6.
suff: (a2 = proj1_sig (exist (fun G : Count N -> FT (VF V) => Finite (Count N) (fun t : Count N => G t <> FO (VF V))) a2 (H5 a2))).
move=> H7.
rewrite H7.
rewrite - (proj1 H2 (exist (fun G : Count N -> FT (VF V) => Finite (Count N) (fun t : Count N => G t <> FO (VF V))) a2 (H5 a2))).
rewrite - (proj1 H2 (exist (fun G : Count N -> FT (VF V) => Finite (Count N) (fun t : Count N => G t <> FO (VF V))) a1 (H5 a1))).
rewrite - H3.
rewrite - H4.
reflexivity.
reflexivity.
reflexivity.
move=> G0.
apply (Finite_downward_closed (Count N) (Full_set (Count N)) (CountFinite N) (fun t : Count N => G0 t <> FO (VF V))).
move=> n H5.
apply (Full_intro (Count N) n).
move=> H2.
suff: (forall (v : VT V), {a : Count N -> FT (VF V) | v = MySumF2 (Count N) (exist (Finite (Count N)) (Full_set (Count N)) (CountFinite N)) (VSPCM V) (fun n : Count N => Vmul V (a n) (F n))}).
move=> H3.
suff: (forall (G : Count N -> FT (VF V)), Finite (Count N) (fun t : Count N => G t <> FO (VF V))).
move=> H4.
exists (fun (v : VT V) => exist (fun G : Count N -> FT (VF V) => Finite (Count N) (fun t : Count N => G t <> FO (VF V))) (proj1_sig (H3 v)) (H4 (proj1_sig (H3 v)))).
apply conj.
move=> n.
apply sig_map.
simpl.
suff: (forall (v : VT V), uniqueness (fun (a : Count N -> FT (VF V)) => v = MySumF2 (Count N) (exist (Finite (Count N)) (Full_set (Count N)) (CountFinite N)) (VSPCM V) (fun n : Count N => Vmul V (a n) (F n)))).
move=> H5.
apply (H5 (MySumF2 (Count N) (exist (Finite (Count N)) (Full_set (Count N)) (CountFinite N)) (VSPCM V) (fun t : Count N => Vmul V (proj1_sig n t) (F t)))).
rewrite - (proj2_sig (H3 (MySumF2 (Count N) (exist (Finite (Count N)) (Full_set (Count N)) (CountFinite N)) (VSPCM V) (fun t : Count N => Vmul V (proj1_sig n t) (F t))))).
reflexivity.
reflexivity.
move=> v.
apply (proj2 (proj2 (unique_existence (fun a : Count N -> FT (VF V) => v = MySumF2 (Count N) (exist (Finite (Count N)) (Full_set (Count N)) (CountFinite N)) (VSPCM V) (fun n0 : Count N => Vmul V (a n0) (F n0)))) (H2 v))).
move=> y.
rewrite - (proj2_sig (H3 y)).
reflexivity.
move=> G.
apply (Finite_downward_closed (Count N) (Full_set (Count N)) (CountFinite N) (fun t : Count N => G t <> FO (VF V))).
move=> n H4.
apply (Full_intro (Count N) n).
move=> v.
apply (constructive_definite_description (fun (a : Count N -> FT (VF V)) => v = MySumF2 (Count N) (exist (Finite (Count N)) (Full_set (Count N)) (CountFinite N)) (VSPCM V) (fun n : Count N => Vmul V (a n) (F n)))).
apply (H2 v).
apply functional_extensionality.
move=> a.
rewrite (MySumF2Excluded (Count N) (VSPCM V) (fun t : Count N => Vmul V (proj1_sig a t) (F t)) (exist (Finite (Count N)) (Full_set (Count N)) (CountFinite N)) (fun t : Count N => proj1_sig a t <> FO (VF V))).
suff: ((MySumF2 (Count N) (FiniteIntersection (Count N) (exist (Finite (Count N)) (Full_set (Count N)) (CountFinite N)) (Complement (Count N) (fun t : Count N => proj1_sig a t <> FO (VF V)))) (VSPCM V) (fun t : Count N => Vmul V (proj1_sig a t) (F t))) = VO V).
move=> H1.
rewrite H1.
simpl.
rewrite (Vadd_O_r V (MySumF2 (Count N) (FiniteIntersection (Count N) (exist (Finite (Count N)) (Full_set (Count N)) (CountFinite N)) (fun t : Count N => proj1_sig a t <> FO (VF V))) (VSPCM V) (fun t : Count N => Vmul V (proj1_sig a t) (F t)))).
suff: ((exist (Finite (Count N)) (fun t : Count N => proj1_sig a t <> FO (VF V)) (proj2_sig a)) = (FiniteIntersection (Count N) (exist (Finite (Count N)) (Full_set (Count N)) (CountFinite N)) (fun t : Count N => proj1_sig a t <> FO (VF V)))).
move=> H2.
rewrite H2.
reflexivity.
apply sig_map.
simpl.
apply Extensionality_Ensembles.
apply conj.
move=> t H2.
apply (Intersection_intro (Count N) (fun t : Count N => proj1_sig a t <> FO (VF V)) (Full_set (Count N))).
apply H2.
apply (Full_intro (Count N) t).
move=> t.
elim.
move=> t0 H2 H3.
apply H2.
apply (MySumF2Induction (Count N) (FiniteIntersection (Count N) (exist (Finite (Count N)) (Full_set (Count N)) (CountFinite N)) (Complement (Count N) (fun t : Count N => proj1_sig a t <> FO (VF V))))).
apply conj.
reflexivity.
move=> v n H1 H2.
rewrite H2.
suff: ((proj1_sig a n) = (FO (VF V))).
move=> H3.
rewrite H3.
rewrite (Vmul_O_l V (F n)).
apply (Vadd_O_r V (VO V)).
apply NNPP.
elim H1.
move=> m H3 H4.
apply H3.
Qed.



End Senkeidaisuunosekai1.


