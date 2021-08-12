------------------------------- MODULE MCEWD998 -------------------------------
EXTENDS EWD998

MCInit ==
    /\ active \in [Node -> BOOLEAN]
    /\ pending = [i \in Node |-> 0]
    /\ color \in [Node -> Color]
    /\ counter \in [Node -> {-1, 0, 1}]
    /\ token \in [pos: Node, color: {"black"}, q: {-1, 0, 1}]

(***************************************************************************)
(* Bound the otherwise infinite state space that TLC has to check.         *)
(***************************************************************************)
StateConstraint ==
  /\ \A i \in Node : counter[i] < 3 /\ pending[i] < 3
  /\ token.q < 3

=============================================================================
