let hd str = str 0;;
let tl str = fun idx -> str (idx + 1);;
let add str value = fun idx -> value + str idx;;
let map str f = fun idx -> f(str idx);;
let map2 str1 str2 f = fun idx -> (f (str1 idx)(str2 idx));;
let replace str n value = fun idx -> if idx == n then value else str idx;;
let take_every str n = fun idx -> str (n * idx);;

(*Zadanie 4*)
let scan str f a = let rec scanrec idx = if idx == 0 then f a (str idx) else f (scanrec (idx - 1)) (str idx) in scanrec;;

(*Zadanie 5*)
let tabulate str ?(s=0) e = let rec f pos = if pos > e then [] else (str pos) :: f (pos + 1) in f s;;


let even x = 2*x;;
let odd = add even 1;;
let double a = a * 2;;

tabulate even 10;;
tabulate odd 10;;
hd even;;
hd (tl (tl even));;
tabulate (map even double) 10;;
tabulate (map2 even odd (+)) 10;;
tabulate (replace (replace even 2 200) 5 100) 10;;
tabulate (take_every even 3) 10;;
tabulate even ~s:5 10;;
(scan even (+) 5) 3;;