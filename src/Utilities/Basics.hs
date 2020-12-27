
-- ------------------------------------------------------------

{- |
   Module     : Utilities.Basics

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : stable
   Portability: portable

   This module contains some very general helper functions indipendent
   from any Haskell module.

-}

-- ------------------------------------------------------------

module Utilities.Basics where

import           Data.List.Ordered
import           Data.Text         (Text)

-- | Symbolic type to represent Unique IDs.
type UID    = String

-- | Type representation, used by 'AbsCity' and 'BiGraph'.
type Type   = String

-- | Generic data type, usually used by serializing complex data types.
type Data = Text

-- | Stubs type, used by 'Policies'.
type Stubs = [(Text, Text)]

-- | Always True Function.
noCond :: a -> Bool
noCond _ = True

-- | filters a list by selecting elements in which a subelement is present
-- | (used by 'BiGraph').
subGraph :: (Eq a) => (a, d) -> [(b, (c, [(a, d)]))] -> [(b, (c, [(a, d)]))]
subGraph n = filter (isPresent n)

-- | Checks if n is an element of a triple (used by 'BiGraph').
isPresent :: (Eq a) => (a, d) -> (b, (c, [(a, d)])) -> Bool
isPresent n (_, (_, ns)) = n `linkMember` ns

-- | Checks whether the node is a member of the link or not
linkMember :: (Eq a) => (a, b) -> [(a, b)] -> Bool 
linkMember x [] = False
linkMember x@(i, _) ((i', _):xs) | i == i' = True 
                                 | otherwise = linkMember x xs

-- | Takes a Boolean Function and if not f(a, b),
-- | pushes a to the end of [a]
alignLists :: (a -> b -> Bool) -> [a] -> [b] -> [a]
alignLists _ [] _ = []
alignLists _ xs [] = xs
alignLists f (x:xs) (y:ys) = if f x y
                             then x : alignLists f xs ys
                             else alignLists f xs (y:ys) ++ [x]

-- | Cobines two lists removing duplicates.
combineNub :: Ord a => [a] -> [a] -> [a]
{-
combineNub [] ys = ys
combineNub xs [] = xs
combineNub xs (y:ys) | y `elem` xs = combineNub xs ys
                     | otherwise   = combineNub (y:xs) ys
-}
combineNub x y = nubSort $ x ++ y
