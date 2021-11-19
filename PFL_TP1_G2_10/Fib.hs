fibRec :: (Integral a) => a -> a
fibRec 0 = 0
fibRec 1 = 1
fibRec num = fibRec (num - 1) + fibRec (num - 2)


fibLista :: (Integral a) => a -> a
auxFibLista :: (Integral a) => a ->[a] -> [a]
fibLista n = (auxFibLista n []) !! fromIntegral n
auxFibLista 0 _ = [0]
auxFibLista 1 _ = [0, 1]
auxFibLista n fiblis
  | (length fiblis) <= fromIntegral(n + 1) = auxFibLista (n - 1) fiblis ++ [((auxFibLista (n - 1) fiblis) !! fromIntegral(n - 2)) + ((auxFibLista (n - 1) fiblis) !! fromIntegral(n - 1))]
  | otherwise = [] --ACABAR

fibListaInfinita :: Int -> Int
fiblist :: (Integral a) => [a]
fibListaInfinita n = fiblist !! n
fiblist = 0 : 1 : zipWith (+) fiblist (tail fiblist)
