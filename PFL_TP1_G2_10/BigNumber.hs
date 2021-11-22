 --Bignumber-
{-2.1-}
import Data.Char(digitToInt)
type Bignumber = [Int]


{-2.2-}
--scanner :: String -> Bignumber
--scanner str = [ digitToInt x  | x <- reverse(str), x != "-"] if  head(str) == "-" then  srt[0] = srt[0]* -1



{-2.3-}
output :: Bignumber ->  String
output  xs =  concat(map (show) (reverse xs))





{-Aux-}
--func :: Bignumber -> Int
bnToInt :: Bignumber -> Int
bnToInt  bn = read (output bn ) :: Int

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


somaBN :: Bignumber -> Bignumber ->  Bignumber

somaBN xs ys =  somaBN' 0 sameSizexs sameSizeys
    where
        (sameSizexs, sameSizeys) = machtSize xs ys
       


somaBN'::Int -> Bignumber -> Bignumber -> Bignumber
somaBN' 0 x [] = x 
somaBN' carry (x:xs) (y:ys) = (r `mod` 10) : (somaBN' (r `div` 10) xs ys)
    where r = x + y + carry 
somaBN' carry (x:[]) (y:[]) = [(r `mod` 10),(r `div` 10)]
    where r = x + y + carry


machtSize :: Bignumber -> Bignumber ->  (Bignumber, Bignumber)
machtSize xs ys = (addZeros diff xs , addZeros (-diff) ys)
  where
    diff = length ys - length xs
    addZeros n ps = ps ++ replicate n 0
