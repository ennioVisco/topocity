module Basics where

-- Stub type to represent Unique IDs
type UID    = String
type Type   = String
type Data = String
type LinkType = String
type Stubs = [(String, String)]

-- Always True Function
noCond :: a -> Bool
noCond _ = True

subGraph :: (Eq a) => a -> [(b, (c, [a]))] -> [(b, (c, [a]))]
subGraph n = filter (isPresent n)

isPresent :: (Eq a) => a -> (b, (c, [a])) -> Bool
isPresent n e@(_, (_, ns)) = n `elem` ns

-- Takes a Boolean Function and if not f(a, b),
-- pushes a to the end of [a]
alignLists :: (a -> b -> Bool) -> [a] -> [b] -> [a]
alignLists _ [] _ = []
alignLists _ xs [] = xs
alignLists f (x:xs) (y:ys) = if f x y
                             then x : alignLists f xs ys
                             else alignLists f xs (y:ys) ++ [x]

combineNub :: Eq a => [a] -> [a] -> [a]
combineNub [] ys = ys
combineNub xs [] = xs
combineNub xs (y:ys) | y `elem` xs = combineNub xs ys
                     | otherwise   = combineNub (y:xs) ys
