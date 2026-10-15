type formula =
| False
| True
| VAR of string
| NOT of formula
| IMP of formula * formula
| OR of formula * formula
| AND of formula * formula

type theorem = formula list * formula

let assumptions (a, _) = a

let consequence (_, thm) = thm

let by_assumption f = ([f], f)

let imp_i f thm =
    match f with
    | IMP(l, _) ->
                  (List.filter (fun x -> x <> l) (assumptions thm),
                  (IMP(l, (consequence thm))))
    | _ -> failwith "Not IMP"

let imp_e thm1 thm2 =
  match (consequence thm1) with
  | IMP(l,r) -> if (=) l (consequence thm2) then ((assumptions thm1) @ (assumptions thm2), r)
  else failwith "Wrong IMP elimintation"
  | _ -> failwith "Not IMP"


let bot_e f thm =
    if (=) False (consequence thm) 
      then (assumptions thm, f) 
    else failwith "Not false"

let top_i = ([], True)

let and_i thm1 thm2 =
    ((assumptions thm1) @ (assumptions thm2), AND((consequence thm1), (consequence thm2)))

let and_e f thm =
    match (consequence thm) with
    | AND(l, _) when l = f  -> ((assumptions thm), l)
    | AND(_, r) when r = f  -> ((assumptions thm), r)
    | AND(_,_)              -> failwith "Not match"
    | _                     -> failwith "Not AND"


let or_i1 thm f =
    match f with
    | OR(_,a) -> ((assumptions thm), OR((consequence thm), a))
    | _ -> failwith "Not OR"

let or_i2 f thm =
  match f with
  | OR(a,_) -> ((assumptions thm), OR(a, (consequence thm)))
  | _ -> failwith "Not OR"

let or_e thm1 thm2 thm3 =
    match (consequence thm1) with
    | AND(_, _) -> if (=) (consequence thm2) (consequence thm3) then
        let f = (consequence thm2) in
        ((assumptions thm1) @ (List.filter (fun x -> x <> f) (assumptions thm2)) @ (List.filter (fun x -> x <> f) (assumptions thm2)), f)
        else failwith "Not same consequence"
    | _ -> failwith "Not AND"


let not_i f thm =
    match (consequence thm), f with
    | False , NOT(a)   -> ((List.filter (fun x -> x <> a) (assumptions thm)), NOT(a))
    | _       -> failwith "Not False"

let not_e thm1 thm2 =
    match (consequence thm1), (consequence thm2) with
    | a1 , NOT(a2)
    | NOT(a1) , a2 -> if (=) a1 a2 then
    ((assumptions thm1) @ (assumptions thm2), False)
    else failwith "Not same consequnce"
    | _ -> failwith "Not neg"

let d_not_e thm =
    match (consequence thm) with
    | NOT(NOT(a))   -> ((assumptions thm), a)
    | _             -> failwith "Not double neg"

let rec string_of_formula f =
  match f with
  | False     -> "⊥"
  | True      -> "T"
  | VAR(v)    -> v
  | IMP(l,r)  -> begin match l with
                    | IMP(_,_) -> "(" ^ (string_of_formula l) ^ ") → "  ^ (string_of_formula r)
                    | _ -> (string_of_formula l) ^ " → "  ^ (string_of_formula r)
                 end
  | AND(l, r) -> (string_of_formula l) ^ " ^ " ^ (string_of_formula r)
  | OR(l, r)  -> (string_of_formula l) ^ " V " ^ (string_of_formula r)
  | NOT(v)    -> begin match v with 
                  | NOT(_) | VAR(_) -> "¬" ^ (string_of_formula v)
                  | _ -> "¬(" ^ (string_of_formula v) ^ ")"
                  end

let pp_print_formula fmtr f =
  Format.pp_print_string fmtr (string_of_formula f)


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


  let print_theorem (acc, f) =
    List.iter (fun x -> print_string (" | " ^ (string_of_formula x))) acc;
    print_string (" ⊢ " ^ (string_of_formula f) ^ "\n");

(* let a = VAR("a")
let a1 = NOT(OR(a, NOT(a)))
let ass = by_assumption a1 *)

(*let test = d_not_e (not_i (not_e ass (or_i2 (not_i (not_e ass (or_i1 (by_assumption a) (NOT(a)))) a) a)) a1)*)