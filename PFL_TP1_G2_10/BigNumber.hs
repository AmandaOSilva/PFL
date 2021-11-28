--BigNumber
module BigNumber where
--2.1
import Data.Char(digitToInt)
type BigNumber = [Int]


--2.2
scanner :: String -> BigNumber
scanner (fstchar:str)
    |fstchar == '-' =
        init (scannerAux str) ++ [digitToInt (head str) * (-1)]
    |otherwise = scannerAux (fstchar:str)

scannerAux :: String -> BigNumber
scannerAux str = [digitToInt x | x <- reverse str]


--2.3
output :: BigNumber ->  String
output xs = concat(map show (reverse xs))


--2.4
somaBN :: BigNumber -> BigNumber -> BigNumber
somaBN x y
    | isPos x && isPos y =
          somaBN' 0 sameSizexs sameSizeys
    | not (isPos x) && not (isPos y) =
          toNeg (subBN' 0 sameSizexs sameSizeys)
    | not (isPos x) && isPos y =
          if maiorQue posX y
                then toNeg(subBNaux3 0 (subBNaux2 sameSizexs sameSizeys))
          else
                subBNaux3 0 (subBNaux2 sameSizeys sameSizexs)
    | isPos x && not (isPos y) =
          if maiorQue x posY
                then subBNaux3 0 (subBNaux2 sameSizexs sameSizeys)
          else
                toNeg(subBNaux3 0 (subBNaux2 sameSizeys sameSizexs))
    | otherwise = error "ERROR IN somaBN -> isPos"
          where
                (sameSizexs, sameSizeys) = machtSize posX posY
                posX = toPos x
                posY = toPos y


somaBN':: Int -> BigNumber -> BigNumber -> BigNumber
somaBN' rest (x:[]) (y:[]) =
    if  (r `div` 10) /= 0
        then [(r `mod` 10), (r `div` 10)]
        else [(r `mod` 10)]
    where
        r = x + y + rest
somaBN' rest (x:xs) (y:ys) = (r `mod` 10 ) : (somaBN' (r `div` 10) xs ys)
    where
        r = x + y + rest


--2.5
subBN :: BigNumber -> BigNumber -> BigNumber
subBN xs ys
    | maiorQue xs ys = subBAux xs ys
    | maiorQue ys xs = trocarSinal(subBAux ys xs)
    | otherwise = [0]

subBAux :: BigNumber -> BigNumber -> BigNumber
subBAux x y
    | isPos x && isPos y =
          subBN' 0 sameSizexs sameSizeys
    | not (isPos x) && isPos y =
          if maiorQue posX y
                then toNeg (somaBN' 0 sameSizexs sameSizeys)
                else somaBN' 0 sameSizeys sameSizexs
    | isPos x && not (isPos y) =
          if maiorQue x posY
                then somaBN' 0 sameSizexs sameSizeys
                else toNeg (somaBN' 0 sameSizexs sameSizeys)
    | not (isPos x) && not (isPos y) =
          toNeg (subBN' 0 sameSizexs sameSizeys)
    | otherwise = error "ERROR IN subBN -> isPos"
          where
                (sameSizexs, sameSizeys) = machtSize posX posY
                posX = toPos x
                posY = toPos y

subBN':: Int -> BigNumber -> BigNumber -> BigNumber
subBN' carry (x:[]) (y:[])
    | last (final) == 0 = []
    | last (final) /= 0 = final
        where
            final = if (x - y - carry) < 0
                then [10 + (x - y - carry)]
                else [(x - y - carry)]
subBN' carry (x:xs) (y:ys) =
    (10 * c + (x - y - carry)) : (subBN' c xs ys)
        where
            c = if (x - y - carry) < 0
                then 1
                else 0

subBNaux2 :: BigNumber -> BigNumber -> BigNumber
subBNaux2 xs ys = zipWith (-) xs ys

subBNaux3 :: Int -> BigNumber -> BigNumber
subBNaux3 carry (ls:[]) = [abs ls - carry]
subBNaux3 carry (fs:bn)
    | (fs <= 0 && last bn <= 0) || (fs >= 0 && last bn >= 0) =
        if fs - carry < 0
            then [10 + fs - carry] ++ subBNaux3 1 bn
            else [abs fs - carry] ++ subBNaux3 0 bn
    | otherwise = [10 + fs - carry] ++ subBNaux3 1 bn


--2.6
mulBN :: BigNumber -> BigNumber -> BigNumber
mulBN _ [0] = [0]
mulBN [0] _ = [0]
mulBN xs ys
  | isPos xs && isPos ys || not (isPos xs) && not (isPos ys)
      = mulBNaux3 (mulBNaux2 (toPos xs) (toPos ys))
  | not (isPos xs) && isPos ys || isPos xs && not (isPos ys)
      = toNeg (mulBNaux3 (mulBNaux2 (toPos xs) (toPos ys)))

mulBNaux1 :: Int -> BigNumber -> Int -> BigNumber
mulBNaux1 0 [] _ = []
mulBNaux1 carry [] _ =
    (carry `mod` 10) : (mulBNaux1 (carry `div` 10) [] 0)
mulBNaux1 carry (x:[]) y =
    ((x * y + carry) `mod` 10) : (mulBNaux1 ((x * y + carry) `div` 10) [] y)
mulBNaux1 carry (x:xs) y =
    ((x * y + carry) `mod` 10) : (mulBNaux1 ((x * y + carry) `div` 10) xs y)

mulBNaux2 :: BigNumber -> BigNumber -> [BigNumber]
mulBNaux2 xs ys =
    [mulBNaux1 0 xs ((ys !! y) * (10 ^ y)) | y <- [0..(length ys - 1)]]

mulBNaux3 :: [BigNumber] -> BigNumber
mulBNaux3 [] = []
mulBNaux3 lisBN
  | length lisBN == 1 = head lisBN
  | length lisBN == 2 =
      somaBN (lisBN !! 0) (lisBN !! 1)
  | length lisBN > 2 =
      mulBNaux3 ((somaBN (lisBN !! 0) (lisBN !! 1)) : tail (tail lisBN))
  | otherwise = error "something wrong in mulBNaux3"


--2.7
divBN :: BigNumber -> BigNumber -> (BigNumber,BigNumber)
divBN _ [0] = error "division by zero"
divBN xs ys
    | isPos xs && isPos ys =
        if maiorQue ys xs
            then ([0], xs)
            else divBN' [0] xs xs ys
    | not(isPos xs) && isPos ys =
        if maiorQue ys posX
            then ([0], xs)
            else (toNeg (fst divided), toNeg (snd divided))
    | isPos xs && not (isPos ys) =
        if maiorQue posY xs
            then ([0], xs)
            else (toNeg (fst divided), snd divided)
    | not (isPos xs) && not (isPos ys) =
        if maiorQue posY posX
            then ([0], xs)
            else (toNeg (fst divided), snd divided)
    | otherwise = error "ERROR IN divBN -> isPos"
        where
            posX = toPos xs
            posY = toPos ys
            divided = (divBN posX posY)


divBN':: BigNumber -> BigNumber -> BigNumber -> BigNumber -> (BigNumber,BigNumber)
divBN' q r xs ys
     | maiorIgual r ys =  divBN' (somaBN q [1]) (subBN r ys ) xs ys
     | otherwise = (q, r)


--5
safeDivBN :: BigNumber -> BigNumber -> Maybe (BigNumber, BigNumber)
safeDivBN numerBN denomBN
    | dif denomBN [0] = Just (divBN numerBN denomBN)
    | otherwise = Nothing


--Aux functions
machtSize :: BigNumber -> BigNumber -> (BigNumber, BigNumber)
machtSize xs ys = (addZeros diff xs , addZeros (-diff) ys)
    where
        diff = length ys - length xs
        addZeros n ps = ps ++ replicate n 0


isPos :: BigNumber -> Bool
isPos bn = last bn > 0


toPos :: BigNumber -> BigNumber
toPos bn = init bn ++ [abs (last bn)]


toNeg :: BigNumber -> BigNumber
toNeg bn = init bn ++ [abs (last bn) * (-1)]


maiorQue :: BigNumber -> BigNumber -> Bool
maiorQue (x:[]) (y:[]) = x > y
maiorQue xs ys
  | length xs /= length ys = length(xs) > length(ys)
  | last xs /= last ys = last xs > last ys
  | otherwise = maiorQue (init xs) (init ys)


maiorIgual ::BigNumber -> BigNumber -> Bool
maiorIgual (x:[]) (y:[]) = x >= y
maiorIgual xs ys
  | length xs /= length ys = length(xs) >= length(ys)
  | last xs /= last ys = last xs >= last ys
  | otherwise = maiorIgual (init xs) (init ys)


trocarSinal:: BigNumber -> BigNumber
trocarSinal bn = init bn ++ [(last bn) * (-1)]


dif ::BigNumber -> BigNumber -> Bool
dif (x:[]) (y:[]) = x /= y
dif xs ys
  | length xs /= length ys = True
  | last xs /= last ys = True
  | otherwise = maiorIgual (init xs) (init ys)
