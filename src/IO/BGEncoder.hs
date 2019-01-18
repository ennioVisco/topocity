
-- ------------------------------------------------------------

{- |
   Module     : [Experimental] IO.BGEncoder

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : experimental
   Portability: portable

   Module for encoding a bigraph into BigraphER syntax.

-}

-- ------------------------------------------------------------

module IO.BGEncoder where

import           Data.Bigraphs
import           Data.Tree.NTree.TypeDefs
import           Libs.Basics
import           Libs.NTreeExtras

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
