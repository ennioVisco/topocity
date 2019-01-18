module IO.BGEncoder where

import           Data.Bigraphs
import           Data.Graph.Inductive.Example
import           Data.Graph.Inductive.Graph
import           Data.Graph.Inductive.PatriciaTree (Gr)
import           Data.GraphViz
import           Data.GraphViz.Parsing
import           Data.GraphViz.Printing
import           Data.Text.Lazy                    (Text, pack, unpack)
import           Data.Tree.NTree.TypeDefs
import           Libs.Basics
import           Libs.NTreeExtras

type Dictionary = [(Node, BiGraphNode)]

keyDic :: NTree BiGraphNode -> Dictionary
keyDic t = inc 1 $ toList t
    where
        -- inc :: Int -> [a] -> [(Int, a)]
        inc n  [x]   = [(n, x)]
        inc n (x:xs) = (n, x) : inc (n + 1) xs

encodeBG :: BiGraph -> String
encodeBG b = let h = mergeBiGraphs b
                in encodeCtrls h ++ "big a0 = " ++ toRules h ++ ";\n"

encodeCtrls :: AbsHypergraph -> String
encodeCtrls n@(NTree d cs) = foldr ((++).showCtrl) (showCtrl n) cs

toRules :: AbsHypergraph -> String
toRules n@(NTree _ []) = nodeToRule n
toRules n@(NTree _ cs) = nodeToRule n ++ ".(" ++
                            foldr (conbar.toRules) "" cs ++ ")"

nodeToRule :: AbsHypergraph -> String
nodeToRule (NTree (d, ls) _) = showNode d ++ linksToRules ls

linksToRules :: [BiGraphEdge] -> String
linksToRules []     = ""
linksToRules (x:xs) = "{" ++ foldr (concomma.showLink) (showLink x) xs ++ "}"

showLink :: BiGraphEdge -> String
showLink (i, (t, _)) = i ++ "-" ++ t

showNode :: BiGraphNode -> String
showNode (i, t) = i ++ "-" ++ t

showCtrl :: AbsHypergraph -> String
showCtrl (NTree (n, ls) _) = "ctrl " ++ showNode n ++ " = " ++ show (length ls) ++ ";\n"
