Inductive natural :=
  Zero : natural
| Add1 : natural -> natural.

Definition two := Add1 (Add1 Zero).
Definition four := Add1 (Add1 (Add1 (Add1 Zero))).

Fixpoint plus (n1 : natural) (n2 : natural) : natural :=
  match n1 with
    | Zero => n2
    | Add1 n1' => Add1 (plus n1' n2)
  end.

Example two_and_two_make_four : plus two two = four.
Proof. auto. Qed.

Lemma plus_Zero_left : forall (n : natural), plus Zero n = n.
Proof. auto. Qed.

Lemma plus_Zero_right : forall (n : natural), plus n Zero = n.
Proof. induction n.
       auto.
       simpl. rewrite -> IHn. auto.
Qed.

Lemma plus_associative :
  forall (n1 n2 n3 : natural), (plus (plus n1 n2) n3) = plus n1 (plus n2 n3).
Proof. intros n1 n2 n3. induction n1.
       auto.
       simpl. rewrite -> IHn1. auto.
Qed.

Lemma plus_Add1_r :
  forall (n1 n2 : natural), plus n1 (Add1 n2) = Add1 (plus n1 n2).
Proof. intros n1 n2. induction n1.
       auto.
       simpl. rewrite -> IHn1. auto.
Qed.

Lemma plus_commutative :
  forall (n1 n2 : natural), plus n1 n2 = plus n2 n1.
Proof. intros n1 n2. induction n1.
       rewrite -> plus_Zero_left. rewrite -> plus_Zero_right. auto.
       simpl. rewrite -> IHn1. rewrite -> plus_Add1_r. auto.
Qed.

