--Fibonacci
import Bignumber
--1.1
fibRec :: (Integral a) => a -> a
fibRec 0 = 0
fibRec 1 = 1
fibRec num = fibRec (num - 1) + fibRec (num - 2)


--1.2
fibLista :: (Integral a) => a -> a
fibLista n = (auxFibLista n []) !! fromIntegral n

auxFibLista :: (Integral a) => a ->[a] -> [a]
auxFibLista 0 _ = [0]
auxFibLista 1 _ = [0, 1]
auxFibLista n fiblis
  | length fiblis <= fromIntegral(n + 1) =
      auxFibLista (n - 1) fiblis ++ [((auxFibLista (n - 1) fiblis) !! fromIntegral(n - 2)) + ((auxFibLista (n - 1) fiblis) !! fromIntegral(n - 1))]
  | otherwise = []


--1.3
fibListaInfinita :: Int -> Int
fibListaInfinita n = fiblist !! n

fiblist :: (Integral a) => [a]
fiblist = 0 : 1 : zipWith (+) fiblist (tail fiblist)


--3.1
fibRecBN :: Int -> Bignumber
fibRecBN 0 = [0]
fibRecBN 1 = [1]
fibRecBN num = somaBN (fibRecBN (num - 1)) (fibRecBN (num - 2))


--3.2
fibListaBN :: Int -> Bignumber
fibListaBN n = (auxFibListaBN n []) !! fromIntegral n

auxFibListaBN :: Int -> [Bignumber] -> [Bignumber]
auxFibListaBN 0 _ = [[0]]
auxFibListaBN 1 _ = [[0], [1]]
auxFibListaBN n lisBN
  | length lisBN <= (n + 1) =
      auxFibListaBN (n - 1) lisBN ++ [somaBN ((auxFibListaBN (n - 1) lisBN) !! (n - 2)) ((auxFibListaBN (n - 1) lisBN) !! (n - 1))]
  | otherwise = []


--3.3
fibListaInfinitaBN :: Int -> Bignumber
fibListaInfinitaBN n = fiblistBN !! n

fiblistBN :: [Bignumber]
fiblistBN = [0] : [1] : zipWith (somaBN) fiblistBN (tail fiblistBN)
