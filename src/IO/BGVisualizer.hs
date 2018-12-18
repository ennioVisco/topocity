module IO.BGVisualizer where

import           Data.Bigraphs
import           Data.Graph.Inductive.Example
import           Data.Graph.Inductive.Graph
import           Data.Graph.Inductive.PatriciaTree (Gr)
import           Data.GraphViz
import           Data.GraphViz.Parsing
import           Data.GraphViz.Printing
import           Data.Text.Lazy                    (Text, pack, unpack)
import           Data.Tree.NTree.TypeDefs
import           Libs.NTreeExtras

{-}
data BiNode = BiNode String String
    deriving (Show, Eq)

instance PrintDot BiNode where
    unqtDot (BiNode i t) = unqtDot i <> colon <+> unqtDot t

    -- We have a space in there, so we need quotes.
    toDot = doubleQuotes . unqtDot

instance ParseDot BiNode where
    parseUnqt = BiNode  <$> parseUnqt
                        <*  character ':'
                        <*  whitespace1
                        <*> parseUnqt
    -- Has at least one space, so it will be quoted.
    parse = quotedParse parseUnqt

doubleQuotes p = char '"' <> p <> char '"'
-}


type Dictionary = [(Node, BiGraphNode)]
keyDic :: NTree BiGraphNode -> Dictionary
keyDic t = inc 1 $ toList t

inc :: Int -> [a] -> [(Int, a)]
inc n  [x]   = [(n, x)]
inc n (x:xs) = (n, x) : inc (n + 1) xs

findKey :: (Eq a) => [(Int, a)] -> a -> Int
findKey []     d              = 0    -- using 0 to mark an error
findKey (x:xs) d | snd x == d = fst x
                 | otherwise  = findKey xs d


edge :: NTree BiGraphNode -> [(Node, Node, String)]
edge t@(NTree _ cs) = let dic = keyDic t
                           in map (child dic t) cs ++ concatMap edge cs

child :: Dictionary -> NTree BiGraphNode -> NTree BiGraphNode -> (Node, Node, String)
child d (NTree a _) (NTree b _) = (findKey d a, findKey d b, "Contains")


bi2graph :: BiGraph -> (Gr Text Text, Gr Text Text)
bi2graph (p, l) = let nodes = keyDic p
                    in  (mkGraph (map tos2 nodes)
                                            (map tos3 $ edge p)
                        ,
                         mkGraph (map tos2 nodes)
                                            (map (convertLink nodes) l)
                        )
showBigraph :: (Gr Text Text, Gr Text Text) -> (String, String)
showBigraph (p, l) = (genGraph p, genGraph l)

t2g :: Gr Text Text
t2g = let nodes = keyDic place
        in mkGraph (map tos2 nodes) (map tos3 $ edge place)

g2g :: Gr Text Text
g2g = let nodes = keyDic place
     in mkGraph (map tos2 nodes) (map (convertLink nodes) link_)

tos2 :: (Node, BiGraphNode) -> (Node, Text)
tos2 (x, y) = (x, pack $ showN y)

tos3 :: (Node, Node, String) -> (Node, Node, Text)
tos3 (x, y, z) = (x, y, pack z)

b2g :: Gr Text Text
b2g = let nodes = keyDic place
     in mkGraph (map tos2 nodes)
        (map tos3 (edge place) ++ map (convertLink nodes) link_)

convertLink :: Dictionary -> BiGraphEdge -> (Node, Node, Text)
convertLink d (i, (t, n:ns)) =  let l = pack $ showN (i, t)
                                    key = findKey d
                                    in (key n, key $ head ns, l)

showN :: (String, String) -> String
showN (i, t) = "(" ++ i ++ "," ++ t ++ ")"

genGraph :: Graph gr => gr Text Text -> String
genGraph x = unpack $ renderDot $ toDot $ graphToDot
             nonClusteredParams
                {   fmtNode = fn
                ,   fmtEdge = fe
                } x
            where   fn (_,l)   = [textLabel l]
                    fe (_,_,l) = [textLabel l]

-- storeGraph x = writeFile "test.dot" (genGraph x)
