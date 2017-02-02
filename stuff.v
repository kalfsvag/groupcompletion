Require Import HoTT.


(* This was already implemented as equiv_sigma_prod0. *)
(* Definition sig_const (A B : Type) : *)
(*   sig (fun _ : A => B) <~> A * B := *)
(*   (@equiv_adjointify *)
(*      (sig (fun _ : A => B)) (A * B) *)
(*      (fun ab => match ab with (a ; b) => (a, b) end) *)
(*      (fun ab => match ab with (a, b) => (a ;b) end) *)
(*      (fun _ => idpath) (fun _ => idpath)). *)


Definition ap12 {A B : Type} {a b : A} (p : a = b) {f g : A->B} (q : f=g)  :
  (ap10 q a)^ @ (ap f p) @ (ap10 q b) = ap g p.
Proof.
  destruct p, q. reflexivity.
Defined.

(*Needs better name, I guess. . .*)
Definition ap12' `{Funext} {A B : Type} {a b : A} (p : a = b) {f g : A->B} (q : f==g)  :
  (q a)^ @ (ap f p) @ q b = ap g p.
Proof.
  refine (_ @ ap12 p (path_arrow _ _ q)).
  apply concat2.
  apply whiskerR.
  apply inverse2. exact (inverse (ap10_path_arrow f g q _)). exact (inverse (ap10_path_arrow f g q _)).
Defined.





(* Definition pathover {A : Type} (B : A -> Type) {a a' : A} (p : a = a') (b : B a) (b' : B a') *)
(*   := transport B p b = b'.            *)

(* Notation "a =^ B [ p ] b" := (pathover B p a b) (at level 20, format "a  =^ B [ p ]  b"). *)
(* Notation "a =[ p ] b" := (pathover _ p a  b) (at level 20, format "a  =[ p ]  b"). *)

(*For now, define pathovers just as notation. *)

Notation "'pathover' B p a b" := (transport B p a = b) (at level 20) : pathover_scope.
Notation "a =[ p ] b" := (transport _ p a = b)
                           (at level 20, format "a  =[ p ]  b") : pathover_scope.
Notation "a =^ ( B ) [ p ] b" := (transport B p a = b)
                               (at level 20, format "a  =^ ( B ) [ p ]  b") : pathover_scope.

(*Make another scope where the explicit notation is parsing only*)
Notation "'pathover' B p a b" := (transport B p a = b) (at level 20) : implicit_pathover_scope.
Notation "a =[ p ] b" := (transport _ p a = b)
                           (at level 20, format "a  =[ p ]  b") : implicit_pathover_scope.
Notation "a =^ B [ p ] b" := (transport B p a = b)
                               (at level 20, only parsing, format "a  =^ B [ p ]  b") : implicit_pathover_scope.


(*This is already defined as [transport_apD_transportD], but I like this name better. . .*)
Definition transport_composeD {A : Type} (B : A -> Type) (C : forall a : A, B a -> Type)
           (f : forall a : A, B a)
           {a a' : A} (p : a = a') (c : C a (f a)) :
  transport (fun a0 : A => C a0 (f a0)) p c = transport (C a') (apD f p) (transportD B C p (f a) c).
Proof.
  induction p. reflexivity.
Defined.


Section Dependent_paths.
  Open Scope pathover_scope.

  Definition apD_composeD {A : Type} {B : Type} {C : B -> Type}
             (f : forall b : B, C b)
             (g : A -> B)
             {a a' : A} (p : a = a') :     
    apD (f oD g) p = transport_compose C g p (f (g a)) @ apD f (ap g p).
  Proof.
    destruct p. reflexivity.
  Defined.
  
  
  Definition composeDD {A : Type} {B : A -> Type} {C : forall a : A, B a -> Type}
             (f : forall a : A, forall b : B a, C a b)
             (g : forall a : A, B a)
  : forall a : A, C a (g a)
    := fun a => f a (g a).

  (* Notation "f 'oDD' g" := (composeDD f g) (at level 0): function_scope. *)
  
  

  (*. . . *)
  Definition apD_composeDD {A : Type} {B : A -> Type} {C : forall a : A, B a -> Type}
             (f : forall a : A, forall b : B a, C a b)
             (g : forall a : A, B a)
             {a a' : A} (p : a = a') :
    apD (composeDD f g) p =
    transport_composeD B C g p (f a (g a)) @ apD011 f p (apD g p).
  Proof.
    destruct p; reflexivity.
  Defined.


  (* Definition apD_composeDD' {A : Type} {B : A -> Type} {C : forall a : A, B a -> Type} *)
  (*            (f : forall a : A, forall b : B a, C a b) *)
  (*            (g : forall a : A, B a) *)
  (*            {a a' : A} (p : a = a') : *)
  (*   apD (composeDD f g) p = apD (f a') (apD g p) *)


  (* Notation "a =^ P p b" := (transport P p a = b) (at level 20, format *)
  (*                                                      "a  =^ P  p  b"). *)

  
  
  Definition concat_over {A : Type} (B : A -> Type) {a1 a2 a3 : A} (p : a1 = a2) (q : a2 = a3)
             {b1 : B a1} {b2 : B a2} {b3 : B a3} : 
    
    b1 =[p] b2 -> b2 =[q] b3 -> b1 =[p @ q] b3
    := fun over_p over_q => (transport_pp B p q b1 @ ap (transport B q) over_p @ over_q).

  Notation "r @[ p , q ] s" := (concat_over _ p q r s) (at level 20, format "r  @[ p , q ]  s").

  Definition apD_pp {A : Type} {B : A -> Type} (f : forall a : A, B a)
             {a1 a2 a3 : A} (p : a1 = a2) (q : a2 = a3) : 
    apD f (p @ q) = (apD f p @[p, q] apD f q).
  Proof.
    destruct p. destruct q. reflexivity.
  Qed.

  (* Definition transport_PQ {A : Type} {P : A -> Type} {Q : A -> Type} (h : P == Q) *)
  (*            {a b : A} (pth : a = b) *)
  (*            (p : P a) *)
  (* :  transport idmap (h b) (transport P pth p) = transport Q pth (transport idmap (h a) p). *)
  (*   destruct pth. reflexivity. Defined. *)

  Definition transport_PequivQ  {A : Type} {P : A -> Type} {Q : A -> Type} (h : forall a : A, P a <~> Q a)
             {a b : A} (pth : a = b)
             (p : P a)
  :  transport P pth p = (h b)^-1 (transport Q pth (h a p)).
    destruct pth. simpl. apply moveL_equiv_V. reflexivity. Defined.


  (* (*A version of transport_compose I need now*) *)
  (* Definition transport_compose_mine {A B : Type} (C : forall a : A, B -> Type) (f : A -> B) *)
  (*            {a a' : A} (p : a = a') (c : C a (f a)) : *)
  (*              transport (fun a => C a (f a)) p c = *)
  (*               ap ? @ (transport (C a) (ap f p) c). *)
  (* Proof. *)
  (*   destruct p. reflexivity. *)
  (* Defined. *)
  
End Dependent_paths.


  
  

Definition section_to_depfun {A : Type} {B : A -> Type} :
  {f : A -> {a : A & B a} | (pr1 o f == idmap)} -> (forall a : A, B a).
Proof.
  intros [f sect].
  exact (fun a => transport B (sect a) (f a).2).
Defined.

Definition equiv_path_sigma {A : Type} (P : A -> Type) (u v : {a : A & P a}) :
  u = v <~> {p : u.1 = v.1 & transport P p u.2 = v.2}.
Proof.
  srapply @equiv_adjointify.
  - intro p. destruct p. exact (idpath; idpath).
  - intros [p q].
    exact (path_sigma P u v p q).
  - intros [p q].
    destruct u as [u1 u2].
    destruct v as [v1 v2]. simpl in p.
    destruct p. simpl in q. destruct q. reflexivity.
  - intro p. destruct p. reflexivity.
Defined.

Definition path2_sigma {A : Type} (P : A -> Type) (u v : {a : A & P a})
           (p p' : u.1 = v.1)
           (q : transport P p u.2 = v.2)
           (q' : transport P p' u.2 = v.2)
           (h1 : p = p')
           (h2 : transport (fun p0 : u.1=v.1 => (transport P p0 u.2 = v.2)) h1 q = q')
:

           path_sigma P u v p q = path_sigma P u v p' q'.
Proof.
  destruct u as [u1 u2].
  destruct v as [v1 v2].
  simpl in p. simpl in p'. destruct h1.
  simpl in q. simpl in q'.
  simpl in h2. destruct h2.
  destruct p. destruct q.
  reflexivity.
Defined.
  

Definition path_sigma_V {A : Type} (P : A -> Type) (u v : {a : A & P a})
           (p : u.1 = v.1) (q : transport P p u.2 = v.2)
           :
             (path_sigma P u v p q)^ =
             path_sigma P v u p^ (ap (transport P p^) q^ @ transport_Vp P p u.2).
Proof.
  destruct u as [u1 u2].
  destruct v as [v1 v2].
  simpl in p. destruct p.
  simpl in q. destruct q.
  reflexivity.
Defined.
  
(* transport P p^ v.2 = u.2. *)
(* Proof. *)
(*   transitivity (transport P p^ (transport P p u.2)). *)
(*   exact (ap (transport P p^) q^). *)
(*   apply transport_Vp. *)
(* Defined. *)

  (* transport_pV *)
  (*   transport_Vp *)

           
  
