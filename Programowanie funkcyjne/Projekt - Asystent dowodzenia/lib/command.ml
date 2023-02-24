open Logic
open Proof

type cmd =
| Intro
| IntroByName of string
| Apply
| Elim of formula
| ElimByName of string
| ElimDNot
| QED
| Proof of formula
| Left
| Right
| Goal
| Next


let do_cmd cmd pt =
    match cmd with
    | Intro -> intro "" pt
    | IntroByName(name) -> intro name pt
    | Apply -> apply pt
    | Goal  -> begin match goal pt with 
                | Some(g, f) -> print_string (string_of_formula f); pt
                | None -> print_string "Dowod ukonczony\n"; pt
                end
    | QED -> print_theorem (qed pt); pt
    | Elim(f) -> elim f pt
    | ElimByName(name) -> elim_by_name name pt
    | ElimDNot -> elim_d_not pt
    | Left -> intro "" ~left:true pt
    | Right -> intro "" ~left:false pt
    | Next -> next pt
    | Proof(f) -> proof [] f
    | _ -> pt
