{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE InstanceSigs #-}

import Control.Monad
import Data.Foldable
import Data.List
import Data.Maybe
import System.IO

main = do
  --1.feladat
  eheti <- bekeres
  --2. feladat
  putStr "A megadott szamok rendezve novekvo sorrendben: "
  tombKiir stdout eheti
  putStrLn ""
  --3., 4. feladat
  adatok <- beolvas "../!Forrasok/lottosz.dat"
  putStr "Adja meg a keresett hetet: "
  be <- readInt <$> getLine
  putStr ("A(z) " ++ show be ++ ". het szamai: ")
  tombKiir stdout (adatok !! (be - 1))
  putStrLn ""
  --5. feladat
  if kihuzatlanSzamKeres adatok then putStr "Volt" else putStr "Nem volt"
  putStrLn " olyan szam amit nem huztak ki az 51 het alatt"
  --6. feladat
  putStrLn (show (length (filter (\x -> mod x 2 == 1) (concat adatok))) ++ " darab paratlan szamot huztak ki az 51 het alatt")
  --7. feladat
  let osszesAdat = adatok ++ [eheti]
  out <- openFile "lotto52.ki" WriteMode
  traverse_ (\x -> tombKiir out x >> hPutChar out '\n') osszesAdat
  hClose out
  --8. feladat
  let szamok = concat osszesAdat
  let gyakorisagTomb = szamGyakorisag szamok
  let gyakorisag = [maybeToInt (lookup x gyakorisagTomb) | x <- [1 .. 90]]
  traverse_ (\x -> tombKiir stdout x >> putChar '\n') (feloszt6_15 gyakorisag)
  --9. feladat
  let primek = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89]
  let kihuzatlanPrimek = [x | x <- primek, isNothing (lookup x gyakorisagTomb)]
  putStr "Primszamok 1 es 90 kozott amiket egyszer sem huztak ki: "
  tombKiir stdout kihuzatlanPrimek
  putStrLn ""
  pure ()

bekeres :: IO [Int]
bekeres = do
  putStr "Kerem adja meg az 52. het lottoszamait szokozzel elvalasztva: "
  sor <- words <$> getLine
  let szamok = map readInt sor
  if length szamok /= 5
    then error "5 szam kell"
    else pure (sort szamok)

beolvas :: String -> IO [[Int]]
beolvas fajl = do
  tartalom <- readFile fajl
  let sorokStr = lines tartalom
  let adatokStr = map words sorokStr
  let adatok = map (map readInt) adatokStr
  pure adatok

kihuzatlanSzamKeres :: [[Int]] -> Bool
kihuzatlanSzamKeres adatok = [1 .. 90] /= removeDuplicates (sort (concat adatok))

szamGyakorisag :: [Int] -> Env
szamGyakorisag l = execState (go l) []
  where
    go :: [Int] -> State Env [Int]
    go [] = pure []
    go [x] = do
      prev <- get
      put (updateEnv prev x)
      pure [x]
    go (x : xs) = do
      prev <- get
      put (updateEnv prev x)
      go xs

feloszt6_15 :: [Int] -> [[Int]]
feloszt6_15 [] = []
feloszt6_15 (a : b : c : d : e : f : g : h : i : j : k : l : m : n : o : xs) =
  [a, b, c, d, e, f, g, h, i, j, k, l, m, n, o] : feloszt6_15 xs

tombKiir h = mapM_ (hPutStr h . (\x -> show x ++ " "))

maybeToInt (Just n) = n
maybeToInt Nothing = 0

readInt :: String -> Int
readInt = read

removeDuplicates :: [Int] -> [Int]
removeDuplicates [] = []
removeDuplicates [x] = [x]
removeDuplicates (x : y : xs) =
  if y == x
    then removeDuplicates (x : xs)
    else x : removeDuplicates (y : xs)

type Env = [(Int, Int)]

type Key = Int

updateEnv :: Env -> Key -> Env
updateEnv env k =
  case lookup k env of
    Nothing -> (k, 1) : env
    Just n -> map (\x -> if x == (k, n) then (k, n + 1) else x) env

-----------------------------------------------------------------------
{- State -}

newtype State s a = State {runState :: s -> (a, s)} deriving (Functor)

instance Applicative (State s) where
  pure = return
  (<*>) = ap

instance Monad (State s) where
  return :: a -> State s a
  return a = State (\s -> (a, s))

  (>>=) :: State s a -> (a -> State s b) -> State s b
  (State f) >>= g = State (\s -> case (f s) of (a, s') -> runState (g a) s')

get :: State s s
get = State (\s -> (s, s))

put :: s -> State s ()
put s = State (\_ -> ((), s))

modify :: (s -> s) -> State s ()
modify f = do s <- get; put (f s)

evalState :: State s a -> s -> a
evalState ma = fst . runState ma

execState :: State s a -> s -> s
execState ma = snd . runState ma
