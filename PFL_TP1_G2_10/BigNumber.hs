
import Data.Char(digitToInt)
type Bignumber = [Int]

{-2.2-}
scanner :: String -> Bignumber
scanner str = [ digitToInt x  | x <- str]