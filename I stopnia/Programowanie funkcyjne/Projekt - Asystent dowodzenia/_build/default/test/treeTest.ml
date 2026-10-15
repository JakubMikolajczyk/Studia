open Asystent
open Logic
open Proof

let node1 = ([], AND(VAR("a"), VAR("a")));;
let comp = Complete(by_assumption (VAR("a")));;
let empty1 = Empty(node1);;
let top = TopI;;
let tree1 = (Root, OrE(node1, comp, empty1, top));;

let test1 = 
    if (=) (get_left tree1) comp then true else failwith "Not Comp"

let test2 = 
  if (=) (get_up tree1) empty1 then true else failwith "Not empty"

let test3 = 
  if (=) (get_right tree1) top then true else failwith "Not top";;


let test4 = 
    if (=) (go_down (go_up tree1)) tree1 then true else failwith "Go down err";;

let test5 = 
  if (=) (go_down (go_left tree1)) tree1 then true else failwith "Go left err";;
let test6 = 
  if (=) (go_down (go_right tree1)) tree1 then true else failwith "Go right err";;


test1;;
test2;;
test3;;
test4;;
test5;;
test6;;


