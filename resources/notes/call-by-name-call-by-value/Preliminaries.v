(* Section 2: technical preliminaries *)

Inductive Λ : Set :=
| V : nat -> Λ (* Variables *)
| C : nat -> Λ (* Constants *)
| λ : nat -> Λ -> Λ (* Abstractions *)
| ap : Λ -> Λ -> Λ (* Applications *)
.

Definition value (M : Λ) : Prop :=
  match M with
    | V _ => True
    | C _ => True
    | λ _ _ => True
    | ap _ _ => False
  end
.

Require Import Coq.Arith.EqNat.
Require Import Coq.Lists.List.
Import ListNotations.

Remark eq_nat_decide' : forall x y : nat, {x = y} + {x <> y}.
Proof.
  intros.
  assert (Hnat : {eq_nat x y} + {~ eq_nat x y}). apply eq_nat_decide.
  elim Hnat. intro. left. apply eq_nat_eq. assumption.
  intro. right. unfold not in b. contradict b. apply eq_eq_nat. assumption.
Qed.

Fixpoint FV (M : Λ) : list nat :=
  match M with
    | V i => [ i ]
    | C _ => []
    | λ i M => remove eq_nat_decide' i (FV M)
    | ap M N => (FV M) ++ (FV N)
  end
.

Fixpoint BV (M : Λ) : list nat :=
  match M with
    | V _ => []
    | C _ => []
    | λ i M => cons i (BV M)
    | ap M N => (BV M) ++ (BV N)
  end
.

Definition closed (M : Λ) : Prop :=
  FV M = [].

Definition open (M : Λ) : Prop :=
  ~ closed M.

Fixpoint size (M : Λ) : nat :=
  match M with
    | V _ => 1
    | C _ => 1
    | λ _ M => 1 + size M
    | ap M N => size M + size N
  end
.

(* Return a variable with higher value than any other in M *)
Fixpoint fresh (M : Λ) : nat :=
  match M with
    | V x => S x
    | C x => S x
    | λ x M => S (max x (fresh M))
    | ap M N => S (max (fresh M) (fresh N))
  end
.

Fixpoint member (n : nat) (xs : list nat) : bool :=
  match xs with
    | [] => false
    | x::xs => if beq_nat n x then true else member n xs
  end
.

Definition freshR (v : nat) (M : Λ) : Prop :=
  v > (fresh M)
.
 
(* Lemma fresh_correct : *)
(*   forall (M : Λ), *)
(*     member (fresh M) ((BV M) ++ (FV M)) = false. *)
(* Proof. *)
(*   intros. *)
(*   induction M. *)
(* Admitted. *)

Fixpoint substitute_rec (fuel : nat) (M : Λ) (x : nat) (N : Λ) :=
  match fuel with
    | O => N
    | S fuel' =>
      match N with
        | V y =>
          if beq_nat x y
          then M
          else N
        | C _ => N
        | λ y N' =>
          if beq_nat x y
          then N
          else let z := fresh (ap M N) in
               let N'' := substitute_rec fuel' (V z) y N' in
               λ z (substitute_rec fuel' M x N'')
        | ap N N' => ap (substitute_rec fuel' M x N) (substitute_rec fuel' M x N')
      end
  end
.
                 
Definition substitute (M : Λ) (x : nat) (N : Λ) : Λ :=
  substitute_rec (S (size N)) M x N
.

Inductive eq_α : Λ -> Λ -> Set :=
| V_α : forall n, eq_α (V n) (V n)
| C_α : forall n, eq_α (C n) (C n)
| ap_α : forall (M M' N N' : Λ),
           eq_α M M' -> eq_α N N' ->
           eq_α (ap M N) (ap M' N')
| λ_α : forall x M y M' z,
            freshR z (ap (λ x M) (λ y M')) ->
            eq_α (substitute (V z) x M) (substitute (V z) y M') ->
            eq_α (λ x M) (λ y M')
.

(* TODO
 * - partial functions
 * - sequences (power, trans. closure)
 * - lexicographic induction
 *)

