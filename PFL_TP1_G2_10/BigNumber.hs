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



           
{-2.3-}
output :: Bignumber ->  String
output  xs =  concat(map (show) (reverse xs))


          
{-2.4-}
somaBN:: Bignumber-> Bignumber-> Bignumber
somaBN x y = somaBN' 0 x y

somaBN':: Int->Bignumber->Bignumber-> Bignumber
-- somaBN' 0 x []= x 

somaBN' carry (x:[]) (y:[]) = final
    where r = x + y + carry
          final = 
              if  (r `div` 10) /= 0 then [(r `mod` 10), (r `div` 10)]
              else [(r `mod` 10)]
somaBN' carry (x:xs) (y:ys) = (r `mod` 10 ) : (somaBN' (r `div` 10) xs ys)
    where r = x + y + carry 

{-2.5-}

subBN :: Bignumber -> Bignumber ->  Bignumber

subBN xs ys =  subBN' 0 sameSizexs sameSizeys
    where
        (sameSizexs, sameSizeys) = machtSize xs ys
       


subBN'::Int -> Bignumber -> Bignumber -> Bignumber
subBN' carry (x:[]) (y:[]) = [10*carry - r]
    where r = x - y - carry 
          carry = if r <= 0 then 1 else 0

subBN' carry (x:xs) (y:ys) = (10*carry - r) : (subBN' carry xs ys)
    where r = x - y - carry 
          carry  = if r <= 0 then 1 else 0
    
                    


{-2.6-}
--mulBN ::Bignumber -> Bignumber ->  Bignumber
mulBN xs ys =  mulBN' 0 xs ys



--mulBN' :: Int -> Bignumber-> Bignumber-> Bignumber 
mulBN' n (x:xs) ys =  somaBN((addZeros n l) (mulBN' (n + 1) xs ys))
    where addZeros n ps = replicate n 0 ++ ps
          l = map (x*)ys 

mulBN' n (x:[]) ys = addZeros n l
    where addZeros n ps = replicate n 0 ++ ps
          l = map (x*)ys  
{-2.7-}


{-Aux-}

bnToInt :: Bignumber -> Int
bnToInt  bn = read (output bn ) :: Int


machtSize :: Bignumber -> Bignumber ->  (Bignumber, Bignumber)
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

{- Colocar carryo mod em um acumulador, depois chamar somaBN 
recursivamente apos transformar  a acumulador em Bignumber . 
-}












 
