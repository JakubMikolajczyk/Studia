type formula =
| VAR of string
| IMP of formula * formula
| False

let rec string_of_formula f =
  match f with
  | False -> "⊥"
  | VAR(v) -> v
  | IMP(l,r) -> match l with
                    | IMP(_,_) -> "(" ^ (string_of_formula l) ^ ") → "  ^ (string_of_formula r)
                    | VAR(_) | False -> (string_of_formula l) ^ " → "  ^ (string_of_formula r)

let pp_print_formula fmtr f =
  Format.pp_print_string fmtr (string_of_formula f)

type theorem =
| By_assumptions of formula list * formula
| IMP_i of formula list * formula * theorem
| IMP_e of formula list * formula * theorem * theorem
| BOT_e of formula list * formula * theorem

let assumptions thm = match thm with
| By_assumptions(a,_) -> a
| IMP_i(a,_,_) -> a
| IMP_e(a,_,_,_) -> a
| BOT_e (a,_,_) -> a

let consequence thm = match thm with
| By_assumptions(_,f) -> f
| IMP_i(_,f,_) -> f
| IMP_e(_,f,_,_) -> f
| BOT_e (_,f,_) -> f

let pp_print_theorem fmtr thm =
  let open Format in
  pp_open_hvbox fmtr 2;
  begin match assumptions thm with
  | [] -> ()
  | f :: fs ->
    pp_print_formula fmtr f;
    fs |> List.iter (fun f ->
      pp_print_string fmtr ",";
      pp_print_space fmtr ();
      pp_print_formula fmtr f);
    pp_print_space fmtr ()
  end;
  pp_open_hbox fmtr ();
  pp_print_string fmtr "⊢";
  pp_print_space fmtr ();
  pp_print_formula fmtr (consequence thm);
  pp_close_box fmtr ();
  pp_close_box fmtr ()

let rec existRemove v = function
| [] -> failwith "Not in assumptions"
(*| [] -> []*)
| h::t -> if (=) h v then t else h :: (existRemove v t)

let addAssumption f thm = match thm with
| By_assumptions(a,con) -> By_assumptions(a @ [f], con)
| IMP_i(a,con,thm) -> IMP_i(a @ [f], con, thm)
| IMP_e(a,con,thm1,thm2) -> IMP_e(a @ [f],con,thm1,thm2)
| BOT_e(a,con,thm) -> BOT_e(a @ [f],con,thm)


let by_assumption f =
  By_assumptions([f],f)

let imp_i f thm =
    let newThm = addAssumption f thm
    IMP_i(existRemove f (assumptions newThm),
        IMP(f,consequence newThm),newThm)

let imp_e thm1 thm2 =
  match (consequence thm1) with
  | IMP(l,r) -> if (=) l (consequence thm2) then IMP_e((assumptions thm1) @ (assumptions thm2), r, thm1, thm2) else failwith "Wrong IMP elimintation"
  | VAR(_) | False -> failwith "Not IMP"

let bot_e f thm =
    if (=) False (consequence thm) then BOT_e((assumptions thm), f, thm) else failwith "Not false"

let p = (VAR("p"))
let q = (VAR("q"))
let r = (VAR("r"))

(*p → p*)
let p1 = imp_i p (by_assumption p)
(*p → q → p*)
let p2 = imp_i p (imp_i q (by_assumption p))

(*(p → q → r ) → (p → q) → p → r*)

(*            p->q->r*)
(*            p->r*)
(*            p*)


(*      p        p->q->r         (p->r)->q  p->r*)
(*         q->r                      q*)
(*                r*)
(*            p -> r*)
(*       (p -> q) -> p -> r*)

let getQ = (imp_e (by_assumption (IMP((IMP(p,r)),q))) (by_assumption(IMP(p,r))))
let get_imp_q_r = (imp_e (by_assumption(IMP(p, (IMP(q,r))))) (by_assumption p))
let getR = (imp_e get_imp_q_r getQ)

let l3 = IMP(p, (IMP(q, r)))
(*let p3 = imp_i l3 (imp_i (IMP(p, q)) (imp_i p (imp_e (imp_e (by_assumption (IMP(p, (IMP q, r)))) (by_assumption p))),*)
(*      (imp_e (by_assumption (IMP (IMP(p, r)), q)) (by_assumption (IMP(p, r))))))*)

let p3 = imp_i l3 (imp_i (IMP(p,q)) (imp_i p getR))

(*⊥ → p*)
let p4 = imp_i (False) (bot_e (VAR("p")) (by_assumption (False)))

(*#install_printer pp_print_formula;;*)
(*#install_printer pp_print_theorem;;*)