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

val proof   : (string * formula) list -> formula -> proof
val qed     : context * no_target_proof -> theorem
val goal    : proof -> nodeVal option

val go_down : proof -> proof
val go_up   : proof -> proof
val go_left : proof -> proof
val go_right: proof -> proof

val get_left : proof -> no_target_proof
val get_up : proof -> no_target_proof
val get_right : proof -> no_target_proof
val get_ctx : proof -> context
val get_tp: proof -> no_target_proof

val is_complete : proof -> bool
val is_end : proof -> bool
val is_root : proof -> bool
val is_empty: proof -> bool

type direction =
| RootDir
| LeftDir
| MidDir
| RightDir

val get_dir: context -> direction
val complete: no_target_proof -> no_target_proof
val try_complete: proof -> proof

val next : proof -> proof
val next_left : proof -> proof
val next_mid: proof -> proof
val next_right : proof -> proof

val try_from_assumption: nodeVal -> no_target_proof
val complete: proof -> proof
val try_complete: proof -> proof
val by_assumtion_complete: proof -> proof
val try_auto_left: proof -> proof
val try_auto_mid: proof -> proof
val try_auto_right: proof -> proof
val try_auto_complete: proof -> proof

val elim_d_not: proof -> proof
val intro:   ?left:bool -> string -> proof ->  proof
val elim: formula -> proof ->  proof
val elim_by_name: string ->proof ->  proof
val apply: proof -> proof

val pp_print_proof : Format.formatter -> proof -> unit

val print_proof: proof -> unit