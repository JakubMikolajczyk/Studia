open Logic

type no_target_proof =
| None
| Empty of (string * formula) list * formula
| ImpI of no_target_proof * no_target_proof
| ImpE of no_target_proof * no_target_proof * no_target_proof
| BotE of no_target_proof * no_target_proof
| Completed of theorem

type context =
| Root
| Left of context * no_target_proof * no_target_proof
| Right of context * no_target_proof * no_target_proof


type proof = context * no_target_proof

let proof g f =
  (Root , Empty(g, f))

let qed pf =
  (* TODO: zaimplementuj *)
  failwith "not implemented"

let goal pf = match pf with
| (Root, t) -> t
| (Left(_,t,_), _) -> t
| (Right(_,t,_),_) -> t


let next pf =
  (* TODO: zaimplementuj *)
  failwith "not implemented"

let intro name pf =
  (* TODO: zaimplementuj *)
  failwith "not implemented"

let apply f pf =
  (* TODO: zaimplementuj *)
  failwith "not implemented"

let apply_thm thm pf =
  (* TODO: zaimplementuj *)
  failwith "not implemented"

let apply_assm name pf =
  (* TODO: zaimplementuj *)
  failwith "not implemented"

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