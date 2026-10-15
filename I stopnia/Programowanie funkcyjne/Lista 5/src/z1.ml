let rec fix f x = f (fix f) x

let fib_f fib n =
     if n <= 1 then n
     else fib (n-1) + fib (n-2)

let fib = fix fib_f

let rec fix_with_limit n f x = if n = 0 then failwith "Limit" else f (fix_with_limit (n-1) f) x

let fib_limit = fix_with_limit 5 fib_f

let hash_tab = Hashtbl.create 100

let rec fix_memo f x = if (Hashtbl.mem hash_tab x)
    then Hashtbl.find hash_tab x
    else let cal = f (fix_memo f) x in Hashtbl.add hash_tab x cal;
     cal

let fib_memo = fix_memo fib_f