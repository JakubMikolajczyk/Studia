open Asystent;;
open Logic;;
open Proof;;


let node1 = ([], AND(VAR("a"), VAR("a")));;
let node2 = ([], AND(VAR("b"), VAR("c")));;
let comp = Complete(by_assumption (VAR("a")));;
let empty1 = Empty(node1);;
let empty2 = Empty(node2);;
let top = TopI;;
let tree1 = (Root, OrE(node1, comp, empty1, top));;
let tree2 = (Root, OrE(node1, empty1, empty2, top));;



let nextTest1 () = if (=) (get_tp (next tree1)) empty1 then true else failwith "nextTest1 fail";;
let nextTest2 () = if (=) (get_tp (next (next (next(next tree1))))) empty1 then true else failwith "nextTest2 fail";;
let nextTest3 () = if (=) (get_tp (next tree2)) empty1 then true else failwith "nextTest3 fail";;
let nextTest4 () = if (=) (get_tp (next (next tree2))) empty2 then true else failwith "nextTest4 fail";;
let nextTest5 () = if (=) (get_tp (next (next (next tree2)))) empty1 then true else failwith "nextTest5 fail";;

nextTest1 ();;
nextTest2 ();;
nextTest3 ();;
nextTest4 ();;
nextTest5 ();;