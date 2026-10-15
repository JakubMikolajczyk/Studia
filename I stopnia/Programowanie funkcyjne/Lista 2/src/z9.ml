type 'a clist = { clist : 'z. ('a -> 'z -> 'z) -> 'z -> 'z }

let cnil = {clist = fun f z -> z}
let ccons a cl = {clist = fun f z -> f a (cl.clist f z) }
let map cfun cl = {clist = fun f z -> cl.clist (fun a -> f (cfun a)) z}
let append cl1 cl2 = {clist = fun f z -> cl1.clist f (cl2.clist f z)}

let clist_to_list cl = cl.clist List.cons []

let rec list_to_clist lst = match lst with
| [] -> cnil
| h :: t -> ccons h (list_to_clist t)

let prod cl1 cl2 = {clist = fun f z -> cl1.clist (fun a -> cl2.clist (fun b  -> f (a,b))) z}

let test = ccons 1 (ccons 3 (ccons 10 (ccons 20 (ccons 2 cnil))));;
let double = (map (fun x -> x * 2) test);;
clist_to_list test;;
clist_to_list double;;
clist_to_list (prod test double)