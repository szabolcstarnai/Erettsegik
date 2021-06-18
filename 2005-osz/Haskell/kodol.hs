import Control.Monad
import Data.Char
import Data.List
import Data.Maybe
import System.IO

main = do
  --1. feladat
  putStr "Adja meg a szoveget: "
  szoveg <- getLine
  ellenoriz szoveg 255
  --2. feladat
  let nyilt = atalakit szoveg
  --3. feladat
  putStrLn ("Nyilt szoveg: " ++ nyilt)
  --4. feladat; nem kell atalakitas, sem ellenorzes, de egyszeru
  --ezert ugy lesz elkeszitve
  putStr "Adja meg a kulcsszot: "
  szoveg <- getLine
  ellenoriz szoveg 5
  --5. feladat
  let kulcs = atalakit szoveg
  let kieg = kiegeszit nyilt kulcs
  putStrLn ("Kulcsszoveg: " ++ kieg)
  --6. feladat
  vtabla <- beolvas "..\\!Forrasok\\Vtabla.dat"
  kodolt <- kodol vtabla nyilt kieg
  --7. feladat
  putStrLn "Kodolva:"
  putStrLn kodolt
  out <- openFile "kodolt.dat" WriteMode
  hPutStrLn out kodolt
  hClose out
  pure ()

index = zip ['A' .. 'Z'] [0 .. 25]

ellenoriz :: String -> Int -> IO ()
ellenoriz s n
  | null s = error "nem lehet ures szoveg"
  | length s > n = error ("nem lehet hosszabb " ++ show n ++ " karakternel")
  | otherwise = pure ()

atalakit :: String -> String
atalakit s = map ekezet (filter isAlpha (map toUpper s))

kiegeszit :: String -> String -> String
kiegeszit nyilt kulcs = take (length nyilt) (cycle kulcs)

ekezet :: Char -> Char
ekezet 'Á' = 'A'
ekezet 'É' = 'E'
ekezet 'Í' = 'I'
ekezet 'Ö' = 'O'
ekezet 'Ő' = 'O'
ekezet 'Ó' = 'O'
ekezet 'Ú' = 'U'
ekezet 'Ű' = 'U'
ekezet 'Ü' = 'U'
ekezet x = x

beolvas :: String -> IO [[Char]]
beolvas fajl = do
  tartalom <- readFile fajl
  let sorokStr = lines tartalom
  pure sorokStr

kodol :: [[Char]] -> String -> String -> IO String
kodol tabla nyilt kulcs =
  let ik = map (\x -> fromJust (lookup x index)) nyilt
   in let jk = map (\x -> fromJust (lookup x index)) kulcs
       in pure (go ik jk)
  where
    go :: [Int] -> [Int] -> String
    go [] [] = []
    go [x] [y] = [(tabla !! x) !! y]
    go (x : xs) (y : ys) = ((tabla !! x) !! y) : go xs ys
    go _ _ = error "unknown"
