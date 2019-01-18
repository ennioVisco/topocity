
-- ------------------------------------------------------------

{- |
   Module     : Libs.Basics

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : stable
   Portability: portable

   This module contains some very general helper functions indipendent
   from any Haskell module.

-}

-- ------------------------------------------------------------

module Libs.Basics where

-- | Symbolic type to represent Unique IDs.
type UID    = String

-- | Type representation, used by 'AbsCity' and 'BiGraph'.
type Type   = String

-- | Generic data type, usually used by serializing complex data types.
type Data = String

-- | Stubs type, used by 'Policies'.
type Stubs = [(String, String)]

-- | Always True Function.
noCond :: a -> Bool
noCond _ = True

-- | filters a list by selecting elements in which a subelement is present
-- | (used by 'BiGraph').
subGraph :: (Eq a) => a -> [(b, (c, [a]))] -> [(b, (c, [a]))]
subGraph n = filter (isPresent n)

-- | Checks if n is an element of a triple (used by 'BiGraph').
isPresent :: (Eq a) => a -> (b, (c, [a])) -> Bool
isPresent n e@(_, (_, ns)) = n `elem` ns

-- | Takes a Boolean Function and if not f(a, b),
-- | pushes a to the end of [a]
alignLists :: (a -> b -> Bool) -> [a] -> [b] -> [a]
alignLists _ [] _ = []
alignLists _ xs [] = xs
alignLists f (x:xs) (y:ys) = if f x y
                             then x : alignLists f xs ys
                             else alignLists f xs (y:ys) ++ [x]

-- | Cobines two lists removing duplicates.
combineNub :: Eq a => [a] -> [a] -> [a]
combineNub [] ys = ys
combineNub xs [] = xs
combineNub xs (y:ys) | y `elem` xs = combineNub xs ys
                     | otherwise   = combineNub (y:xs) ys

-- | String concatenation by comma ( , ).
concomma :: String -> String -> String
concomma x y = x ++ "," ++ y

-- | String concatenation by bar ( | ).
conbar ::  String -> String -> String
conbar x y = x ++ " | " ++ y
