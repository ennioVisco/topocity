
-- ------------------------------------------------------------

{- |
   Module     : [Experimental] IO.BGEncoder

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : experimental
   Portability: portable

   Module for encoding a bigraph into BigraphER syntax.

-}

-- ------------------------------------------------------------

module IO.Bigrapher.Encoder where

import            Data.Bigraphs
import            Data.Text                (Text, append, pack)
import            Data.Tree.NTree.TypeDefs
import            Utilities.Basics
import            Utilities.TextExtras
import            Utilities.NTreeExtras
import            IO.Bigrapher.Basics


-- | General bigraph scheme:
-- | 1 - Controls
-- | 2 - Bigraph nesting with "." for leaves and "|" for branching
-- | 3 - {x1, x2, ...} for per-node names and links
encodeBG :: Bool -> BiGraph -> Text
encodeBG False b =
   let h = mergeBiGraphs b
      in ctrls h <+| "big a0 = " <+> toRules False h 0 <+| ";" 
encodeBG True b = 
   let h = mergeBiGraphs b
      in ctrls h <+> line "big a0 = " <+> toRules True h 0 <+> line ";"



toRules :: Bool -> AbsHypergraph -> Int -> Text
toRules p (NTree n []) i = nodeToRule p i n
toRules p (NTree n (c:cs)) i = 
   let others = foldl (branch p i) (toRules p c (i + 1)) cs
      in nodeToRule p i n <+| ".("  <+> others <+| ")"

nodeToRule :: Bool -> Int -> (BiGraphNode, [BiGraphEdge]) -> Text
nodeToRule False n (d, ls) = node d <+> linksToRules ls
nodeToRule True  n (d, ls) = tab  n <+> node d <+> linksToRules ls <+> line ""

linksToRules :: [BiGraphEdge] -> Text
linksToRules (x:xs) = foldr (concomma.link) (link x) xs <+| "}"

branch :: Bool -> Int -> Text -> AbsHypergraph -> Text
branch p n x y = x `conbar` toRules p y (n + 1)



-- | Control encoding criterion:
-- | We add a line for each control
-- encodeCtrls :: AbsHypergraph -> Text
-- encodeCtrls n@(NTree d cs) = foldr (append.showCtrl) (showCtrl n) cs

-- showCtrl :: AbsHypergraph -> Text
-- showCtrl (NTree (n, ls) _) =  "ctrl " |+> showNode n <+| " = " <+| 
--                              show (length ls) <+| ";\n"
