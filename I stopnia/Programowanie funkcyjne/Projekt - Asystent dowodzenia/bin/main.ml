open Asystent
open Parser
open Command
open Proof
open Logic

let repl prop = 
    let rec step (ctx, pt) =
      if ctx <> ENDctx
      then match goal (ctx, pt) with 
            | Some(g, f) -> print_proof (ctx, pt);
            | None -> print_string "Dowod ukonczony\n";
      else print_string "";
      print_string "\n";
      print_string "> ";
      flush stdout;
      match command (read_line ()) with
      | Some cmd -> step (do_cmd cmd (ctx, pt))
      | None -> print_string "Unknown cmd\n"; step (ctx, pt)
    in step (ENDctx, ENDProof);;


repl ();;