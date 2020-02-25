
-- ------------------------------------------------------------

{- |
   Module     : NTreeExtras

   Maintainer : Ennio Visconti (ennio.visconti\@mail.polimi.it)
   Stability  : stable
   Portability: portable

   n-ary tree structure (rose trees) helpers
   based on NTree implementation from HXT.

-}

-- ------------------------------------------------------------

module Libs.NTreeExtras where

import           Data.List
import           Data.Tree.NTree.TypeDefs
import           Libs.Basics

{-
data NTree a = NTree a [NTree a]
-- ......................:::::: CLASSES INSTANCE ::::::..................... --

instance (Show a) => Show (NTree a) where
    show (NTree d _) = show d

-- NOTE maybe this equality is too costly
instance (Eq a) => Eq (NTree a) where
    NTree d c == NTree d' c'| d == d' && c == c' = True
                          | otherwise          = False

instance Functor NTree where
  -- fmap ::  (a -> b) -> NTree a -> NTree b
  fmap f (NTree d cs) = NTree (f d) (map (fmap f) cs)
-}

-- .......................:::::: BASIC HELPERS ::::::....................... --

size :: NTree a -> Int
size (NTree _ []) = 1
size (NTree _ cs) = 1 + sum (map size cs)

isLeaf :: NTree a -> Bool
isLeaf (NTree _ []) = True
isLeaf _            = False

inTree :: (Eq a) => a -> NTree a -> Bool
inTree p t = findNodes p t /= []

getData :: NTree a -> a
getData (NTree d _) = d

toList :: NTree a -> [a]
toList (NTree d []) = [d]
toList (NTree d cs) = foldr ((++) . toList) [d] cs

-- ....................:::::: CHILDREN MANAGEMENT ::::::.................... --

getChildren :: NTree a -> [NTree a]
getChildren (NTree _ cs) = cs

removeChild :: (Eq a) => NTree a -> NTree a -> NTree a
removeChild (NTree d cs) c = NTree d (delete c cs)

addChild :: NTree a -> NTree a -> NTree a
addChild (NTree d []) c = NTree d [c]
addChild (NTree d cs) c = NTree d (c:cs)

addChildrenAt :: (Eq a) => NTree a -> NTree a -> [NTree a] -> NTree a
addChildrenAt p = foldl (addChildAt p)

addChildAt :: (Eq a) => NTree a -> NTree a -> NTree a -> NTree a
addChildAt p t n = aca p n t
    where
        aca p@(NTree d' _) n t@(NTree d c) | d == d' = addChild t n
                                           | otherwise = NTree d (fmap (aca p n) c)

-- .......................:::::: NTree PRINTERS ::::::....................... --

setChildren :: [NTree a] -> [NTree a]
setChildren cs = cs

printTree :: (Show a) => NTree a -> String
printTree = printTree' 0
  where
      printTree' d x = case x of
        NTree a [] ->
            replicate (1 * d) '\t' ++
            show a ++ "\n"
        NTree a cs ->
            replicate (1 * d) '\t' ++
            show a ++ "\n" ++
            unlines (map (printTree' (d + 1)) cs)

displayTree :: (Show a) => NTree a -> IO()
displayTree = putStr.printTree

-- ......................:::::: ADVANCED HELPERS ::::::..................... --

findNodes :: (Eq a) => a -> NTree a -> [NTree a]
findNodes p n@(NTree p' cs) | p == p'   = n : concatMap (findNodes p) cs
                           | otherwise = concatMap (findNodes p) cs

-- Given a Tree on a (a, b), returns a Tree on a
separatePair :: (Ord b) => NTree (a, [b]) -> (NTree a, [b])
separatePair h = (fmap fst h, foldr combineNub [] $
                    (toList . fmap snd) h)

-- checks if the provided function is True down to the leaves
check :: (NTree a -> NTree b -> Bool) -> NTree a -> NTree b -> Bool
check f t = _chk (size t) f t

-- checks if the provided function is True but stopping at children level
check1 :: (NTree a -> NTree b -> Bool) -> NTree a -> NTree b -> Bool
check1 = _chk 1

_chk :: Int -> (NTree a -> NTree b -> Bool) -> NTree a -> NTree b -> Bool
_chk 0 f a b                             = f a b
_chk n f a@(NTree _ []) b@(NTree _ [])   = f a b
_chk n f (NTree _ _ ) (NTree _ [])       = False
_chk n f (NTree _ []) (NTree _ _ )       = False
_chk n f a@(NTree d cs) b@(NTree d' cs') = f a b
                                && and (zipWith (_chk (n - 1) f) cs cs')
