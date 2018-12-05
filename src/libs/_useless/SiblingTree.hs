module SiblingTree where
--                   Children  Siblings
data Tree a = Node a (Tree a) (Tree a)
            | Nil

instance (Show a) => Show (Tree a) where
    show Nil          =  ""
    show (Node d _ _) = show d

instance (Eq a) => Eq (Tree a) where
    Nil == Nil = True
    Nil == _   = False
    _ == Nil   = False
    Node d c s == Node d' c' s' | d == d'
                                    && c == c'
                                    && s == s' = True
                                | otherwise    = False


instance Functor Tree where
    -- fmap ::  (a -> b) -> Tree a -> Tree b
    fmap f Nil          = Nil
    fmap f (Node d c s) = Node (f d) (fmap f c) (fmap f s)

printTree :: (Show a) => Tree a -> String
printTree (Node a c _) = printTree' (Node a c Nil) 0
    where
        printTree' x depth = case x of
          Node a children siblings ->
                replicate (1 * depth) '\t' ++
                show a ++ "\n" ++
                printTree' children (depth + 1) ++ "\n" ++
                printTree' siblings depth
          Nil -> ""

displayTree :: (Show a) => Tree a -> IO()
displayTree = putStr.printTree

findNodes :: (Eq a) => a -> Tree a -> [Tree a]
findNodes _ Nil = []
findNodes p n@(Node p' c s) | p == p'   = n : (findNodes p c ++ findNodes p s)
                            | otherwise = findNodes p c ++ findNodes p s


getChildren :: Tree a -> [Tree a]
getChildren Nil          = []
getChildren (Node _ c _) = c : getSiblings c

getSiblings :: Tree a -> [Tree a]
getSiblings Nil          = []
getSiblings (Node _ _ s) = s : getSiblings s

addChildrenAt :: (Eq a) => Tree a -> Tree a -> [Tree a] -> Tree a
addChildrenAt p = foldl (addChildAt p)



addChildAt :: (Eq a) => Tree a -> Tree a -> Tree a -> Tree a
addChildAt _ Nil _ = Nil
addChildAt p@(Node d' _ _) t@(Node d c s) n
            | d == d' = addChild t n
            | otherwise = Node d (addChildAt p c n) (addChildAt p s n)


addChild ::Tree a -> Tree a -> Tree a
addChild Nil n            = n
addChild t Nil            = t
addChild (Node d Nil s) n = Node d n s
addChild (Node d c s) n   = Node d (addSibling c n) s

addSibling :: Tree a -> Tree a -> Tree a
addSibling Nil n            = n
addSibling t Nil            = t
addSibling (Node d c Nil) n = Node d c n
addSibling (Node d c s) n   = Node d c (addSibling s n)

isLeaf :: Tree a -> Bool
isLeaf (Node _ Nil _) = True
isLeaf _              = False

notNil :: Tree a -> Bool
notNil Nil = False
notNil _   = True

inTree :: (Eq a) => a -> Tree a -> Bool
inTree p t = not (null (findNodes p t))


-- TESTING
tree1  = Node "City" (Node "Building" (Node "Door1" Nil Nil) (Node "Building" Nil (Node "Building" Nil Nil))) Nil
tree2  = Node "City" (Node "Building" (Node "Door1" Nil Nil) (Node "Building" Nil (Node "Building2" Nil Nil))) Nil
test = displayTree tree1
