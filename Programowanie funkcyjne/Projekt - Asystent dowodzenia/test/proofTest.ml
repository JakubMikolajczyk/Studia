open Asystent
open Logic
open Proof

let a = VAR("a")
let or1 = OR(a, NOT(a))
(* let tree1 = (Root,
  DNotE(([], or1), 
  NotI(([], NOT(NOT(or1))), 
  NotE(([("x", NOT(or1))],False), Complete(by_assumption (NOT(or1))), 
  OrI2((([("x", NOT(or1))], or1), 
  NotI(([("x", NOT(or1)); ("a", a)], NOT(a)), 
  NotE(([("x", NOT(or1)); ("a", a)], False), Complete(by_assumption(NOT(or1))),
  OrI1(([("x", NOT(or1)); ("a", a)], a), Complete(by_assumption a))))))))));;


  let tree2 = (Root,
    DNotE(([], or1), 
    NotI(([], NOT(NOT(or1))), 
    NotE(([("x", NOT(or1))],False), Empty(([("x", NOT(or1))],NOT(or1))), 
    OrI2((([("x", NOT(or1))], or1), 
    NotI(([("x", NOT(or1)); ("a", a)], NOT(a)), 
    NotE(([("x", NOT(or1)); ("a", a)], False), 
    OrI1(([("x", NOT(or1)); ("a", a)], or1), 
    Empty(([("x", NOT(or1)); ("a", a)], a))),
    Empty(([("x", NOT(or1)); ("a", a)], NOT(or1)))
    ))))))));; *)



let test1 ()= proof [] (AND(a, NOT(a)))
|> elim_d_not
|> intro "H1"
|> elim_by_name "H1"
|> intro ""
|> intro "H2"
|> elim_by_name "H1"
|> intro ~left:true "";;

let check1 () = 
    if (=) (qed (test1 ())) ([], or1)
      then true
      else failwith "test1 proof fail";;

check1 ();;

(* proof [] (parse_formula "a V not a")
|> elim_d_not
|> intro "H1"
|> elim_by_name "H1"
|> intro ""
|> intro "H2"
|> elim_by_name "H1"
|> intro ~left:true "" *)