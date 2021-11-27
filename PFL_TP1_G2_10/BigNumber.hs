 --Bignumber-
{-2.1-}
import Data.Char(digitToInt)
type Bignumber = [Int]


{-2.2-}

scanner :: String -> Bignumber
scannerAux :: String -> Bignumber
scannerAux str = [digitToInt x | x <- reverse str]
scanner (fstchar:str)
  |fstchar == '-' = init (scannerAux str) ++ [digitToInt (head str) * (-1)]
  |otherwise = scannerAux (fstchar:str)



{-2.3-}
output :: Bignumber ->  String
output  xs =  concat(map (show) (reverse xs))



{-2.4-}

somaBN :: Bignumber -> Bignumber -> Bignumber
somaBN x y
    | isPos x && isPos y =
          somaBN' 0 sameSizexs sameSizeys
    | not (isPos x) && not (isPos y) =
          toNeg (subBN' 0 sameSizexs sameSizeys)
    | not (isPos x) && isPos y =
          if maiorQue posX y then
                toNeg(subBNaux3 0 (subBNaux2 sameSizexs sameSizeys))
          else
                subBNaux3 0 (subBNaux2 sameSizeys sameSizexs)
    | isPos x && not (isPos y) =
          if maiorQue x posY then
                subBNaux3 0 (subBNaux2 sameSizexs sameSizeys)
          else
                toNeg(subBNaux3 0 (subBNaux2 sameSizeys sameSizexs))
    | otherwise = error "ERROR IN somaBN -> isPos"
          where
                (sameSizexs, sameSizeys) = machtSize posX posY
                posX = toPos x
                posY = toPos y


somaBN':: Int->Bignumber->Bignumber-> Bignumber
somaBN' rest (x:[]) (y:[]) = final
    where r = x + y + rest
          final =
              if  (r `div` 10) /= 0 then [(r `mod` 10), (r `div` 10)]
              else [(r `mod` 10)]
somaBN' rest (x:xs) (y:ys) = (r `mod` 10 ) : (somaBN' (r `div` 10) xs ys)
    where r = x+y+rest



{-2.5-}

subBN :: Bignumber -> Bignumber ->  Bignumber

subBN xs ys   
      | length(ys) > length (xs)  = trocarSinal(subBAux ys xs) 
      | length(xs) >= length (xs) = subBAux xs ys
      | (xs == ys) = [0] --- acho q  precisa :)
            where negsy = toNeg(ys)
                  negsx = toNeg(xs)
     
     
      

subBAux :: Bignumber -> Bignumber ->  Bignumber
subBAux x y
   | isPos x && isPos y =
          subBN' 0 sameSizexs sameSizeys
    | not (isPos x) && not (isPos y) =
          toNeg (subBN' 0 sameSizexs sameSizeys)
    | not (isPos x) && isPos y =
          if maiorQue posX y then
                toNeg(somaBN' 0  sameSizexs sameSizeys)
          else
                somaBN' 0 sameSizeys sameSizexs
    | isPos x && not (isPos y) =
          if maiorQue x posY then
                somaBN' 0 sameSizexs sameSizeys
          else
                toNeg(somaBN' 0 sameSizexs sameSizeys)
    | otherwise = error "ERROR IN subBN -> isPos"
          where
                (sameSizexs, sameSizeys) = machtSize posX posY
                posX = toPos x
                posY = toPos y



subBN':: Int -> Bignumber -> Bignumber -> Bignumber
subBN' carry (x:[]) (y:[])
      | ( last (final) == 0 ) = []
      | ( last (final) /= 0 ) = final
    where final  = if (x - y - carry) < 0 then [10 + (x - y - carry)] else [(x - y - carry)]

subBN' carry (x:xs) (y:ys) = (10 * c + (x - y - carry)) : (subBN' c xs ys)
    where c = if (x - y - carry) < 0 then 1 else 0





subBNaux2 :: Bignumber -> Bignumber -> Bignumber
subBNaux2 xs ys = zipWith (-) xs ys

subBNaux3 :: Int -> Bignumber -> Bignumber
subBNaux3 carry (ls:[]) = [abs ls - carry]
subBNaux3 carry (fs:bn)
  | ((fs <= 0 && last bn <= 0) || (fs >= 0 && last bn >= 0)) =
    if fs - carry < 0 then [10 + fs - carry] ++ subBNaux3 1 bn else [abs fs - carry] ++ subBNaux3 0 bn
  | otherwise = [10 + fs - carry] ++ subBNaux3 1 bn







{-2.6-}
{-
mulBN ::Bignumber -> Bignumber ->  Bignumber
mulBN xs ys =  mulBN' 0 xs ys
      | isPos x && isPos y =
          mulBN' 0 xs ys
      | not (isPos x) || not (isPos y) =
          toNeg (somaBN' 0 toPos(xs) toPos (ys))
         
mulBN' :: Int -> Bignumber-> Bignumber-> Bignumber 
mulBN' n (x:xs) ys =  somaBN((mul10^N(n  (map (x*)ys))  ) (mulBN' (n + 1) xs ys))
    where mul10^N n l = (replicate n 0) ++ l
         
mulBN' n (x:[]) ys = mul10^N(n map (x*)ys ) 
    where  mul10^N n l = (replicate n 0) ++  l
-}




{-2.7-}

divBN :: Bignumber -> Bignumber -> (Bignumber,Bignumber)
divBN xs ys = res
      where res =  if maiorQue ys xs then  ([0], xs) else divBN' [0] xs xs ys 
      

divBN':: Bignumber -> Bignumber -> Bignumber -> Bignumber -> (Bignumber,Bignumber)
divBN' q r xs ys  
     | maiorIgual r ys =  divBN' (somaBN q [1]) (subBN r ys ) xs ys
     | otherwise = (q, r)
      

{-Aux-}
bnToInt :: Bignumber -> Int
bnToInt  bn = read (output bn ) :: Int



machtSize :: Bignumber -> Bignumber -> (Bignumber, Bignumber)
machtSize xs ys = (addZeros diff xs , addZeros (-diff) ys)
  where
    diff = length ys - length xs
    addZeros n ps = ps ++ replicate n 0

{-aux Soma-}
isPos :: Bignumber -> Bool
isPos bn = last bn > 0

toPos :: Bignumber -> Bignumber
toPos bn = init bn ++ [abs (last bn)]

toNeg :: Bignumber -> Bignumber
toNeg bn = init bn ++ [abs (last bn) * (-1)]

maiorQue :: Bignumber -> Bignumber -> Bool
maiorQue xs ys = (length(xs) > length( ys)) || ( (length(xs) == length( ys)) &&  (last(xs) > last(ys)))

maiorIgual ::Bignumber -> Bignumber -> Bool
maiorIgual xs ys = (length(xs) >= length( ys)) || ( (length(xs) == length( ys)) &&  (last(xs) >= last(ys)))

trocarSinal:: Bignumber -> Bignumber
trocarSinal bn = init bn ++ [(last bn) * (-1)]



{-2.4-}
--somaBN :: Bignumber -> Bignumber -> Bignumber
--somaBN xs ys =   scanner (show ( bnToInt(xs) + bnToInt( ys)))

{-2.6-}
--mulBN :: Bignumber -> Bignumber -> Bignumber
--mulBN xs ys =   scanner (show ( bnToInt(xs) - bnToInt(ys)))


{-2.5-}
--subBN :: Bignumber -> Bignumber -> Bignumber
--subBN xs ys =   scanner (show ( bnToInt(xs) * bnToInt( ys)))



         
