module ListTree where

import           Basics
import           Data.List

data Tree a = Nil | Node a [Tree a]

-- ......................:::::: CLASSES INSTANCE ::::::..................... --

instance (Show a) => Show (Tree a) where
    show Nil        =  ""
    show (Node d _) = show d

-- NOTE maybe this equality is too costly
instance (Eq a) => Eq (Tree a) where
    Nil == Nil                                 = True
    Nil == _                                   = False
    _ == Nil                                   = False
    Node d c == Node d' c'| d == d' && c == c' = True
                          | otherwise          = False

instance Functor Tree where
  -- fmap ::  (a -> b) -> Tree a -> Tree b
  fmap f Nil         = Nil
  fmap f (Node d cs) = Node (f d) (map (fmap f) cs)

-- .......................:::::: BASIC HELPERS ::::::....................... --

size :: Tree a -> Int
size Nil         = 0
size (Node _ []) = 1
size (Node _ cs) = 1 + sum (map size cs)

isLeaf :: Tree a -> Bool
isLeaf (Node _ []) = True
isLeaf _           = False

isNil :: Tree a -> Bool
isNil Nil = True
isNil _   = False

inTree :: (Eq a) => a -> Tree a -> Bool
inTree p t = findNodes p t /= []

-- ....................:::::: CHILDREN MANAGEMENT ::::::.................... --

getChildren :: Tree a -> [Tree a]
getChildren Nil         = []
getChildren (Node _ cs) = cs

removeChild :: (Eq a) => Tree a -> Tree a -> Tree a
removeChild Nil _         = Nil
removeChild t Nil         = t
removeChild (Node d cs) c = Node d (delete c cs)

addChild ::Tree a -> Tree a -> Tree a
addChild Nil c         = c
addChild t Nil         = t
addChild (Node d []) c = Node d [c]
addChild (Node d cs) c = Node d (c:cs)

addChildrenAt :: (Eq a) => Tree a -> Tree a -> [Tree a] -> Tree a
addChildrenAt p = foldl (addChildAt p)

addChildAt :: (Eq a) => Tree a -> Tree a -> Tree a -> Tree a
addChildAt p t n = aca p n t
    where
        aca _ _ Nil                                = Nil
        aca Nil _ _                                = Nil
        aca p@(Node d' _) n t@(Node d c) | d == d' = addChild t n
                                         | otherwise = Node d (fmap (aca p n) c)

-- .......................:::::: TREE PRINTERS ::::::....................... --

printTree :: (Show a) => Tree a -> String
printTree = printTree' 0
  where
      printTree' d x = case x of
        Node a [] ->
            replicate (1 * d) '\t' ++
            show a
        Node a cs ->
            replicate (1 * d) '\t' ++
            show a ++ "\n" ++
            unlines (map (printTree' (d + 1)) cs)
        Nil -> ""

displayTree :: (Show a) => Tree a -> IO()
displayTree = putStr.printTree

-- ......................:::::: ADVANCED HELPERS ::::::..................... --

findNodes :: (Eq a) => a -> Tree a -> [Tree a]
findNodes _ Nil                        = []
findNodes p n@(Node p' cs) | p == p'   = n : concatMap (findNodes p) cs
                           | otherwise = concatMap (findNodes p) cs



-- checks if the provided function is True down to the leaves
check :: (Tree a -> Tree b -> Bool) -> Tree a -> Tree b -> Bool
check f t = _chk (size t) f t

-- checks if the provided function is True but stopping at children level
check1 :: (Tree a -> Tree b -> Bool) -> Tree a -> Tree b -> Bool
check1 = _chk 1

_chk :: Int -> (Tree a -> Tree b -> Bool) -> Tree a -> Tree b -> Bool
_chk _ _ Nil Nil                       = True
_chk _ _ Nil _                         = False
_chk _ _ _ Nil                         = False
_chk 0 f a b                           = f a b
_chk n f a@(Node _ []) b@(Node _ [])   = f a b
_chk n f (Node _ _ ) (Node _ [])       = False
_chk n f (Node _ []) (Node _ _ )       = False
_chk n f a@(Node d cs) b@(Node d' cs') = f a b
                                && and (zipWith (_chk (n - 1) f) cs cs')


-- TODO to be removed
{-_chk :: Int -> (a -> b -> Bool) -> Tree a -> Tree b -> Bool
_chk _ _ Nil Nil                   = True
_chk _ _ Nil _                     = False
_chk _ _ _ Nil                     = False
_chk 0 f (Node d _) (Node d' _)   = f d d'
_chk n f (Node d []) (Node d' [])  = f d d'
_chk n f (Node d _ ) (Node d' [])  = False
_chk n f (Node d []) (Node d' _ )  = False
_chk n f (Node d cs) (Node d' cs') = f d d'
                                && and (zipWith (_chk (n - 1) f) cs cs')
-}
