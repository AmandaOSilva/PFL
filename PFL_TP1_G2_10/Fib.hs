fibRec :: (Integral a) => a -> a
fibRec 0 = 0
fibRec 1 = 1
fibRec num = fibRec (num - 1) + fibRec (num - 2)

{--
fibLista :: (Integral a) => a -> [a]
fibLista 0 = 0
-}

fibListaInfinita :: Int -> Int
fiblist :: (Integral a) => [a]
fibListaInfinita n = fiblist !! n
fiblist = 0 : 1 : zipWith (+) fiblist (tail fiblist)
