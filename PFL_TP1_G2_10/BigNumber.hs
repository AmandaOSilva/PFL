--Bignumber-
{-2.1-}
import Data.Char(digitToInt)
type Bignumber = [Int]


{-2.2-}

--scanner :: String -> Bignumber
--scanner str = if  head(str) == "-" then update length str ( last srt  * -1 ) $ fromList [ digitToInt x  | x <- reverse(str), x /= "-"]

{-
scanner :: String -> Bignumber
scanner str = bn
    where bn = if head(srt) == '-' then  (digitToInt head(str) * -1)::[ digitToInt x  | x <- reverse( tail (str))] else [ digitToInt x  | x <- reverse( tail str)]

-}
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
isPos :: Bignumber -> Bool
isPos bn = last bn > 0

toPos :: Bignumber -> Bignumber
toPos bn = init bn ++ [abs (last bn)]

toNeg :: Bignumber -> Bignumber
toNeg bn = init bn ++ [abs (last bn) * (-1)]

maiorQue :: Bignumber -> Bignumber -> Bool
maiorQue x y = bnToInt x > bnToInt y

somaBN :: Bignumber -> Bignumber -> Bignumber
somaBN x y
    | isPos x && isPos y =
          somaBN' 0 sameSizexs sameSizeys
    | not (isPos x) && not (isPos y) =
          toNeg (somaBN' 0 sameSizexs sameSizeys)
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
-- somaBN' 0 x []= x

somaBN' rest (x:[]) (y:[]) = final
    where r = x+y+rest
          final =
              if  (r `div` 10) /= 0 then [(r `mod` 10), (r `div` 10)]
              else [(r `mod` 10)]
somaBN' rest (x:xs) (y:ys) = (r `mod` 10 ) : (somaBN' (r `div` 10) xs ys)
    where r = x+y+rest

{-2.5-}
subBN :: Bignumber -> Bignumber ->  Bignumber
subBN xs ys =  subBNaux3 0 (subBNaux2 sameSizexs sameSizeys)
     where (sameSizexs, sameSizeys) = machtSize xs ys

subBNaux2 :: Bignumber -> Bignumber -> Bignumber
subBNaux2 xs ys = zipWith (-) xs ys

subBNaux3 :: Int -> Bignumber -> Bignumber
subBNaux3 carry (ls:[]) = [abs ls - carry]
subBNaux3 carry (fs:bn)
  | ((fs <= 0 && last bn <= 0) || (fs >= 0 && last bn >= 0)) =
    if fs - carry < 0 then [10 + fs - carry] ++ subBNaux3 1 bn else [abs fs - carry] ++ subBNaux3 0 bn
  | otherwise = [10 + fs - carry] ++ subBNaux3 1 bn



subBN':: Int -> Bignumber -> Bignumber -> Bignumber
subBN' carry (x:[]) (y:[]) = [10 * c + (x - y - carry)]
    where c = if (x - y - carry) <= 0 then 1 else 0

subBN' carry (x:xs) (y:ys) = (10 * c + (x - y - carry)) : (subBN' c xs ys)
    where c = if (x - y - carry) <= 0 then 1 else 0




{-2.6-}

{-2.7-}


{-Aux-}
bnToInt :: Bignumber -> Int
bnToInt  bn = read (output bn ) :: Int


machtSize :: Bignumber -> Bignumber -> (Bignumber, Bignumber)
machtSize xs ys = (addZeros diff xs , addZeros (-diff) ys)
  where
    diff = length ys - length xs
    addZeros n ps = ps ++ replicate n 0

{-2.4-}
--somaBN :: Bignumber -> Bignumber -> Bignumber
--somaBN xs ys =   scanner (show ( bnToInt(xs) + bnToInt( ys)))

{-2.6-}
--mulBN :: Bignumber -> Bignumber -> Bignumber
--mulBN xs ys =   scanner (show ( bnToInt(xs) - bnToInt(ys)))


{-2.5-}
--subBN :: Bignumber -> Bignumber -> Bignumber
--subBN xs ys =   scanner (show ( bnToInt(xs) * bnToInt( ys)))



{-Ideia pra usar dos cum div 2.6  !!!NAO APAGAR!!!-}
--somaBN :: Bignumber -> Bignumber -> Bignumber
--aux xs ys = zipWith(+) xs ys
--somaBN xs ys =  [ num  |num <- aux(), mod num 10 >= 1 ]

--somaBN :: Bignumber -> Bignumber -> Int
--aux xs ys = zipWith(+) xs ys
--somaBN xs ys = [mod num 10 |num <- aux xs ys] + sum[x if x >= 10 else 0 for x in zipWith(+) xs ys]

{- Colocar resto mod em um acumulador, depois chamar somaBN
recursivamente apos transformar  a acumulador em Bignumber .
-}
