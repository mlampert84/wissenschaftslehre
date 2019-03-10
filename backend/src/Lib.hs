module Lib where

import Graphics.Gloss
import System.Random

randomBinaries :: StdGen -> [Int]
randomBinaries s =  map f $ randomRs (0.0::Float,1.0::Float) s where
        f a  | a > 0.5 = 1
             | otherwise = 0

getRandomBinaries :: IO [Int]
getRandomBinaries = do
    g <- newStdGen
    return (randomBinaries g)

--Write a function that takes the dimensions of a matrix and returns a [[Int]] of random 1s and 0s.
--Do this by cutting up the randomBinaries
-- doubleMatrix :: Int -> Int -> [Int] -> [[Int]]
-- doubleMatrix x y numbs =  rows y numbs where
--          rows 0 _ = []
--          rows y rs = l : rows (y-1) ls where
--             (l, ls) = splitAt x rs


-- testRandom :: IO [[Int]]
-- testRandom = do
--     g <- newStdGen
--     return $ doubleMatrix 10 10 $ randomBinaries g

unitRectangle :: Picture
unitRectangle = rectangleSolid 10 10

drawing :: [(Float,Float)] -> [Int] ->  Picture
drawing ls ints = pictures $ map toPicture $ zip ls ints where
                toPicture ((x,y),1) = translate x y $ color red $ unitRectangle
                toPicture ((x,y),_) = translate x y $ color white $ unitRectangle


-- pixelate :: [(Float, Float)] -> [Int] -> [((Float,Float),Int)]
-- pixelate trans iff = zip trans iff


transpositions :: Float -> Float -> [(Float,Float)]
transpositions window pixel = map ( mapTuple f ) $ (,) <$> ls <*> ls where
                          ls = [1..(window / pixel)]
                          mapTuple f (a,b) = (f a, f b)
                          f x = x * pixel - (window + pixel) / 2



-- ex x w = take 10

someFunc :: IO ()
someFunc = do
  ls <- getRandomBinaries
  display ( InWindow "Nice Window" (200,200) (150,150)) white (drawing (transpositions 200 10) ls)
