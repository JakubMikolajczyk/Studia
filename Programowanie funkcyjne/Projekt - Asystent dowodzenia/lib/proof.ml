open Logic

type nodeVal = (string * formula) list * formula

type no_target_proof =
| ENDProof
| Complete  of theorem
| Empty     of nodeVal
| TopI
| ImpI      of nodeVal * no_target_proof
| BotE      of nodeVal * no_target_proof
| AndE      of nodeVal * no_target_proof
| OrI1      of nodeVal * no_target_proof
| OrI2      of nodeVal * no_target_proof
| NotI      of nodeVal * no_target_proof
| DNotE     of nodeVal * no_target_proof
| ImpE      of nodeVal * no_target_proof * no_target_proof
| AndI      of nodeVal * no_target_proof * no_target_proof
| NotE      of nodeVal * no_target_proof * no_target_proof
| OrE       of nodeVal * no_target_proof * no_target_proof * no_target_proof



type context =
| ENDctx
| Root
| DownImpI  of context * nodeVal
| DownBotE  of context * nodeVal
| DownAndE  of context * nodeVal
| DownOrI1  of context * nodeVal
| DownOrI2  of context * nodeVal
| DownNotI  of context * nodeVal
| DownDNotE of context * nodeVal
| LeftImpE  of context * nodeVal * no_target_proof
| RightImpE of context * nodeVal * no_target_proof
| LeftAndI  of context * nodeVal * no_target_proof
| RightAndI of context * nodeVal * no_target_proof
| LeftNotE  of context * nodeVal * no_target_proof
| RightNotE of context * nodeVal * no_target_proof
| LeftOrE   of context * nodeVal * no_target_proof * no_target_proof
| MidOrE    of context * nodeVal * no_target_proof * no_target_proof
| RightOrE  of context * nodeVal * no_target_proof * no_target_proof


type proof = context * no_target_proof



let proof g f =
    (Root, Empty(g, f))

let qed (_, pf) =
  match pf with
  | Complete(t)   -> t
  | _             -> failwith "Dowód nieukończony"

let goal (_, pf) =
  match pf with
  | Empty(g, f) -> Some(g, f)
  | _           -> None


let go_down (ctx, tp) =
    match ctx with
    | Root -> failwith "ROOT"
    | DownImpI(ctx, v)  -> (ctx, ImpI(v, tp))
    | DownBotE(ctx, v)  -> (ctx, BotE(v, tp))
    | DownAndE(ctx, v) -> (ctx, AndE(v, tp))
    | DownOrI1(ctx, v)  -> (ctx, OrI1(v, tp))
    | DownOrI2(ctx, v)  -> (ctx, OrI2(v, tp))
    | DownNotI(ctx, v)  -> (ctx, NotI(v, tp))
    | DownDNotE(ctx, v) -> (ctx, DNotE(v, tp))

    | LeftImpE(ctx, v, rp)  -> (ctx, ImpE(v, tp, rp))
    | RightImpE(ctx, v, lp) -> (ctx, ImpE(v, lp, tp))
    | LeftAndI(ctx, v, rp)  -> (ctx, AndI(v, tp, rp))
    | RightAndI(ctx, v, lp) -> (ctx, AndI(v, lp, tp))

    | LeftOrE(ctx, v, mp, rp)   -> (ctx, OrE(v, tp, mp, rp))
    | MidOrE(ctx, v, lp, rp)    -> (ctx, OrE(v, lp, tp, rp))
    | RightOrE(ctx, v, lp, mp)  -> (ctx, OrE(v, lp, mp, tp))

    | LeftNotE(ctx, v, rp)     -> (ctx, NotE(v, tp, rp))
    | RightNotE(ctx,v,  lp)    -> (ctx, NotE(v, lp, tp))
    | ENDctx -> failwith "END"

let go_left (ctx, tp) =
    match tp with
    | ImpE(v, lp, rp)       -> (LeftImpE(ctx, v, rp), lp)
    | AndI(v, lp, rp)       -> (LeftAndI(ctx, v, rp), lp)
    | NotE(v, lp, rp)       -> (LeftNotE(ctx,v, rp), lp)

    | OrE(v, lp, mp, rp)    -> (LeftOrE(ctx, v, mp, rp), lp)
    | _                     -> (ENDctx, tp)

let go_up (ctx, tp) =
    match tp with
    | ImpI(v, mp)   -> (DownImpI(ctx, v), mp)
    | BotE(v, mp)   -> (DownBotE(ctx, v), mp)
    | AndE(v, mp)   -> (DownAndE(ctx, v), mp)
    | OrI1(v, mp)   -> (DownOrI1(ctx, v), mp)
    | OrI2(v, mp)   -> (DownOrI2(ctx, v), mp)
    | NotI(v, mp)   -> (DownNotI(ctx, v), mp)
    | DNotE(v, mp)  -> (DownDNotE(ctx, v), mp)

    | OrE(v, lp, mp, rp) -> (MidOrE(ctx, v, lp, rp), mp)
    | _ -> (ENDctx, tp)

let go_right (ctx, tp) =
    match tp with
    | ImpE(v, lp, rp)   -> (RightImpE(ctx, v, lp), rp)
    | AndI(v, lp, rp)   -> (RightAndI(ctx, v, lp), rp)
    | NotE(v, lp, rp)   -> (RightNotE(ctx, v, lp), rp)

    | OrE(v, lp, mp, rp)    -> (RightOrE(ctx, v, lp, mp), rp)
    | _                     -> (ENDctx, tp)

let get_left (_, tp) =
    match tp with
    | ImpE(_, lp, _)
    | AndI(_, lp, _)
    | NotE(_, lp, _)
    | OrE(_, lp, _, _)   -> lp
    | _                 -> ENDProof

let get_up (_, tp) =
    match tp with
        | ImpI(_, mp)
        | BotE(_, mp)
        | AndE(_, mp)
        | OrI1(_, mp)
        | OrI2(_, mp)
        | NotI(_, mp)
        | DNotE(_, mp)
        | OrE(_, _, mp, _)  -> mp
        | _                 -> ENDProof

let get_right (_, tp) =
    match tp with
    | ImpE(_, _, rp)
    | AndI(_, _, rp)
    | NotE(_,_, rp)
    | OrE(_, _, _, rp)  -> rp
    | _                 -> ENDProof

let get_ctx (ctx, _) = ctx

let get_tp (_, tp) = tp

let is_complete (_, tp) =
    match tp with
    | Complete(_) | ENDProof -> true
    | _                      -> false

let is_empty (_, tp) =
    match tp with
    | Empty(_)  -> true
    | _         -> false

let is_end (ctx, _) =
    match ctx with
    | ENDctx    -> true
    | _         -> false

let is_root (ctx, _) =
    match ctx with
    | Root  -> true
    | _     -> false


type direction =
| RootDir
| LeftDir
| MidDir
| RightDir
let get_dir ctx =
    match ctx with 
    | LeftAndI(_,_,_) | LeftImpE(_,_,_) 
    | LeftNotE(_,_,_) | LeftOrE(_,_,_, _)           -> LeftDir
    | DownImpI(_,_) | DownBotE(_,_) 
    | DownAndE(_,_)| DownOrI1(_,_) 
    | DownOrI2(_,_) | DownNotI(_,_) 
    | DownDNotE(_,_)| MidOrE(_,_,_,_)               -> MidDir
    | RightAndI(_,_,_)  | RightImpE(_,_,_)  
    | RightNotE(_,_,_)  | RightOrE(_,_,_,_)         -> RightDir
    | Root                                          -> RootDir                  
    | _ -> failwith "FAIL"

let rec next (ctx, tp) =
    match get_dir ctx with
    | RootDir   -> if is_complete (ctx, tp)
                    then (ctx, tp)
                    else next_left (ctx, tp)
    | LeftDir   -> go_down (ctx, tp) |> next_mid
    | MidDir    -> go_down (ctx, tp) |> next_right
    | RightDir  -> 
                    if  go_down (ctx, tp) |> is_root
                        then go_down (ctx, tp) |> next_left
                        else go_down (ctx, tp) |> go_down |> next_left

and next_left prp = 
    if is_empty prp
        then prp
        else if not (go_left prp |> is_end)
                then  go_left prp |> next_left
                else if not (go_up prp |> is_end)
                        then  go_up prp |> next_left
                        else if not( go_right prp |> is_end) 
                            then go_right prp |> next_left
                            else next prp

and next_mid prp =
    if is_empty prp 
        then prp
        else if not (go_up prp |> is_end)
                then go_up prp |> next_left
                else if not( go_right prp |> is_end) 
                        then go_right prp |> next_left
                        else next prp
                
and next_right prp =
    if is_empty prp 
        then prp
        else if not (go_right prp |> is_end )
                then go_right prp |> next_left
                else next prp



let try_from_assumption (g, f) =
    if snd (List.split g) |> List.exists (fun x -> x = f)
        then Complete(by_assumption f)
        else Empty(g, f) 

let complete (ctx, tp) =
    (ctx, match tp with
        | Empty(f)                      ->  try_from_assumption (f)
        | TopI                          -> Complete(top_i)
        | ImpI((_, f), Complete(thm))   -> Complete(imp_i f thm)
        | BotE((_, f), Complete(thm))   -> Complete(bot_e f thm)
        | AndE((_, f), Complete(thm))   -> Complete(and_e f thm)
        | OrI1((_, f), Complete(thm))   -> Complete(or_i1 thm f)
        | OrI2((_, f), Complete(thm))   -> Complete(or_i2 f thm)
        | NotI((_, f), Complete(thm))   -> Complete(not_i f thm)
        | DNotE((_, _), Complete(thm))  -> Complete(d_not_e thm)
        | ImpE((_, _), Complete(thm1), Complete(thm2)) -> Complete(imp_e thm1 thm2)
        | AndI((_, _), Complete(thm1), Complete(thm2)) -> Complete(and_i thm1 thm2)
        | OrE((_, _), Complete(thm1), Complete(thm2), Complete(thm3)) -> Complete(or_e thm1 thm2 thm3)
        | NotE(_,Complete(thm1), Complete(thm2))  -> Complete(not_e thm1 thm2)
        | _ -> tp
    )

let rec try_complete (ctx, tp) =
    if is_root (ctx, tp)
        then complete (ctx, tp) |> next
        else if (=) (ctx, tp) (complete (ctx, tp)) 
            then if is_empty (ctx, tp) 
                    then (ctx, tp)
                    else next (ctx, tp)
            else complete (ctx, tp) |> go_down |> try_complete

let try_auto_left (ctx, tp) =
    if go_left (ctx, tp) |> is_empty
    then go_left (ctx, tp) |> complete |> go_down
    else (ctx, tp)

let try_auto_mid(ctx, tp) =
    if go_up (ctx, tp) |> is_empty
    then go_up (ctx, tp) |> complete |> go_down
    else (ctx, tp)

let try_auto_right (ctx, tp) =
    if go_right (ctx, tp)   |> is_empty
    then go_right (ctx, tp) |> complete |> go_down
    else (ctx, tp)        

let try_auto_complete (ctx, tp) = 
    (ctx, tp) |> try_auto_left |> try_auto_mid |> try_auto_right |> try_complete

let by_assumtion_complete (ctx, tp) =
    match tp with
    | Empty(_, f) -> 
        if is_root (ctx, tp)
            then (ctx, Complete(by_assumption f))
            else (ctx, Complete(by_assumption f)) |> go_down |> try_complete
    | _ -> failwith "not empty"


let elim_d_not (ctx, tp) = 
    match goal (ctx, tp) with
    | None       -> failwith "Proof complete"
    | Some(g, f) -> (ctx, DNotE((g, f), Empty((g, (NOT(NOT(f))))))) |> try_auto_complete


let intro ?(left = false) name (ctx, tp)=
    match goal (ctx, tp) with
    | None          -> failwith "Proof complete"
    | Some(g, f)    ->  (ctx, 
                        begin match f with
                        | True      ->  Complete(top_i)
                        | AND(l, r) -> AndI((g, f), Empty((g, l)), Empty((g, r)))
                        | IMP(l, r) -> ImpI((g, f), Empty((name, l) :: g, r))
                        | NOT(v)    -> NotI((g, f), Empty((name, v) :: g, False))
                        | OR(l, r)  -> if left
                                        then OrI1((g, f), Empty(g, l))
                                        else OrI2((g, f), Empty(g, r))
                        | _ -> failwith ""
                        end) |> try_auto_complete


let elim form (ctx, tp)=
    match goal (ctx, tp) with
    | Some(g, f) -> (ctx, if f = False 
                then match form with
                    | NOT(form) -> NotE((g, f), Empty(g, form), Empty(g, NOT(form)))
                     | _ -> NotE((g, f), Empty(g, form), Empty(g, NOT(form)))
                else begin match form with
                    | False -> BotE((g, f), Empty(g, False))
                    | AND(l, r) when (l=form) || (r = form) -> AndE((g, f), Empty(g, form))
                    | IMP(l, r) when r=f -> ImpE((g,f), Empty(g, l), Empty(g, form))
                    | OR(l, r)  -> OrE((g, f), Empty(g, form), Empty(("", l) :: g, f), Empty(("", r) :: g, f))
                    | _ -> failwith "wrong form"
                    end) |> try_auto_complete
    | None       -> failwith "Proof complete"


let elim_by_name name (ctx, tp) = 
    match goal (ctx, tp) with
    | Some(g, f) -> elim (List.assoc name g) (ctx, tp)
    | None -> failwith "Proof complete"


let apply (ctx, tp) = by_assumtion_complete (ctx, tp)

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

let print_proof pt =
    print_string (String.make 40 '='); print_string "\n";
    match goal pt with
    | None       -> print_string "Dowod ukonczony\n" 
    | Some(g, f) -> List.iter (fun (name, ass) -> print_string (name ^ ": " ^ (string_of_formula ass) ^ "\n")) g;
                    print_string (String.make 40 '='); print_string "\n"; print_string (string_of_formula f);