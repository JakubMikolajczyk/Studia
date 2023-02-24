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

type theorem = formula list * formula

let assumptions thm =
  match thm with
  | (a, _) -> a

let consequence thm =
  match thm with
  | (_, c) -> c

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

let by_assumption f =
  ([f],f)

let imp_i f thm =
   (List.filter (fun x -> x <> f) (assumptions thm),
   (IMP(f, (consequence thm))))

let imp_e thm1 thm2 =
  match (consequence thm1) with
  | IMP(l,r) -> if (=) l (consequence thm2) then ((assumptions thm1) @ (assumptions thm2), r)
  else failwith "Wrong IMP elimintation"
  | VAR(_) | False -> failwith "Not IMP"

let bot_e f thm =
    if (=) False (consequence thm) then (assumptions thm, f) else failwith "Not false"

type no_target_proof =
| Empty of (string * formula) list * formula
| ImpI of no_target_proof * (string * formula) list * formula
| ImpE of no_target_proof * no_target_proof * (string * formula) list * formula
| BotE of no_target_proof * (string * formula) list * formula
| Complete of theorem

and context =
| Root
| Left of context * no_target_proof * (string * formula) list * formula
| Right of no_target_proof * context * (string * formula) list * formula
| DownB of context * (string * formula) list * formula
| DownI of context * (string * formula) list * formula


type proof = context * no_target_proof


let proof g f =
  (Root, Empty(g, f))

let qed (ctx, pf) =
  match pf with
  | Complete(t)   -> t
  | _             -> failwith "Dowód nieukończony"

let goal (ctx, pf) =
  match pf with
  | Empty(g, f) -> Some(g, f)
  | _           -> None

let rec next_up (ctx, pf) =
  match pf with
  | Complete(t) -> begin match ctx with
                   | Root -> (ctx, pf)
                   | DownB(ctx, g, f)      -> next_up (ctx, Complete(bot_e f t))
                   | DownI(ctx, g, f)      -> next_up (ctx, Complete(imp_i f t))
                   | Left(ctx, pf2, g, f)  -> begin match pf2 with
                                              | Complete(t2) -> next_up (ctx, Complete(imp_e t t2))
                                              | _ -> next_right (ctx, ImpE(pf, pf2, g, f))
                                              end
                   | Right(pf2, ctx, g, f) -> begin match pf2 with
                                              | Complete(t2) -> next_up (ctx, Complete(imp_e t2 t))
                                              | _ -> next_left (ctx, ImpE(pf2, pf, g, f))
                                              end
                   end
  | _           -> begin match ctx with
                   | Root                  -> next_left (ctx, pf)
                   | DownB(ctx, g, f)      -> next_up (ctx, BotE(pf, g, f))
                   | DownI(ctx, g, f)      -> next_up (ctx, ImpI(pf, g, f))
                   | Left(ctx, pf2, g, f)  -> next_right (ctx, ImpE(pf, pf2, g, f))
                   | Right(pf2, ctx, g, f) -> next_up (ctx, ImpE(pf2, pf, g, f))
                   end


and next_left (ctx, pf) =
  match pf with
  | Empty(_, _) | Complete(_) -> (ctx, pf)
  | ImpI(pf, g, f)            -> next_left (DownI(ctx, g, f), pf)
  | BotE(pf, g, f)            -> next_left (DownB(ctx, g, f), pf)
  | ImpE(pf1, pf2, g, f)      -> begin match pf1 with
                                 | Complete(_) -> next_right (ctx, pf)
                                 | _           -> next_left (Left(ctx, pf2, g, f), pf1)
                                 end

and next_right (ctx, pf) =
  match pf with
  | ImpE(pf, pf2, g, f) -> begin match pf2 with
                           | Complete(_) -> next_up (ctx, pf)
                           | _           -> next_left (Right(pf, ctx, g, f), pf2)
                           end
  | _                   -> next_left (ctx, pf)


let next (ctx, pf) =
  match pf with
  | Complete(_) -> failwith "Nie ma więcej dziur"
  | _           -> next_up (ctx, pf)

let intro name (ctx, pf) =
  match goal (ctx, pf) with
  | None       -> failwith "Dowód ukończony"
  | Some(g, f) -> match f with
                  | IMP(left, right) -> (DownI(ctx, g, left), Empty((name, left) :: g, right))
                  | _                        -> failwith "Celem musi być implikacja"


let rec far_right f =
  match f with
  | IMP(_, right) -> far_right right
  | _                     -> f

let rec apply_aux f (ctx, pf) g phi acc =
  if f = phi then
    ctx, acc
  else
    let r = far_right f in
    if r <> phi && r <> False then
      failwith "Dowód niepoprawny"
    else
      match f with
      | False                    -> DownB(ctx, g, phi), acc
      | IMP(left, right) -> let (ctx2, _) = apply_aux right (ctx, pf) g phi (ImpE(acc, Empty(g, left), g, right)) in
                                    Left(ctx2, Empty(g, left), g, right), acc
      | _                        -> failwith "Miejsce nieosiągalne"


let apply f (ctx, pf) =
  match goal (ctx, pf) with
  | None         -> failwith "Nic do udowodnienia"
  | Some(g, phi) -> next_up (apply_aux f (ctx, pf) g phi (Empty(g, f)))

let apply_thm thm (ctx, pf) =
  match goal (ctx, pf) with
  | None         -> failwith "Nic do udowodnienia"
  | Some(g, phi) -> next_up (apply_aux (consequence thm) (ctx, pf) g phi (Complete(thm)))

let apply_assm name (ctx, pf) =
  match goal (ctx, pf) with
  | None         -> failwith "Nic do udowodnienia"
  | Some(g, phi) -> apply_thm (by_assumption (List.assoc name g)) (ctx, pf)

let pp_print_proof fmtr pf =
  match goal pf with
  | None -> Format.pp_print_string fmtr "No more subgoals"
  | Some(g, f) ->
    Format.pp_open_vbox fmtr (-100);
    g |> List.iter (fun (name, f) ->
      Format.pp_print_cut fmtr ();
      Format.pp_open_hbox fmtr ();
      Format.pp_print_string fmtr name;
      Format.pp_print_string fmtr ":";
      Format.pp_print_space fmtr ();
      pp_print_formula fmtr f;
      Format.pp_close_box fmtr ());
    Format.pp_print_cut fmtr ();
    Format.pp_print_string fmtr (String.make 40 '=');
    Format.pp_print_cut fmtr ();
    pp_print_formula fmtr f;
    Format.pp_close_box fmtr ()