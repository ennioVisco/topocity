
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

import Prelude hiding (null)
import            Data.Bigraphs
import            Data.Text                (Text, append, pack, null)
import            Data.Tree.NTree.TypeDefs
import            Utilities.Basics
import            Utilities.TextExtras
import Utilities.NTreeExtras ()
import            IO.Bigrapher.Basics


-- | General bigraph scheme:
-- | 1 - Controls
-- | 2 - Bigraph nesting with "." for leaves and "|" for branching
-- | 3 - {x1, x2, ...} for per-node names and links
-- | 3.1 - if they have variable links, x2, ... are added as leaves
encodeBG :: Bool -> BiGraph -> Text
encodeBG p b = let   h  = mergeBiGraphs b
                     ns = nsLs h 
                     vs = varyingCtrls ns
                  in ctrls vs ns <+> lineBig p (toRules vs h 0) <+> brs

-- | BRS line to make the bigraph a valid BRS
brs :: Text 
brs = line "begin brs init a0; rules = []; end"

-- | The boolean determines whether it must be 
-- | pretty-printed (True) 
-- | or not (False)
lineBig :: Bool -> (Bool -> Text) -> Text
lineBig False f = "big a0 = " |+> 
                  f False <+| ";" 
lineBig True  f = line "" <+> 
                  line "big a0 = " <+> 
                  f True <+> 
                  line ";"



toRules :: [Type] -> AbsHypergraph -> Int -> Bool -> Text
toRules vs (NTree n []) i p     | fst n `isVarying` vs = 
   ctrRule p vs i n <+> 
   children p (i + 1) (lnkAsChild (snd n) i p) <+> 
   line ""
                                | otherwise = ctrRule p vs i n 
toRules vs (NTree n (c:cs)) i p | fst n `isVarying` vs = 
   let rules = foldl (branch p vs i) (toRules vs c (i + 1) p) cs
       links = lnkAsChild (snd n) i p
       ls = length $ snd n
       next = nextTo (ls > 0)
      in ctrRule p vs i n <+> children p i (links <+> next <+> rules) 
                                | otherwise =
   let rules = foldl (branch p vs i) (toRules vs c (i + 1) p) cs
      in ctrRule p vs i n <+> children p i rules 

nextTo :: Bool -> Text 
nextTo True  = pack "|"
nextTo False = pack ""

lnkAsChild :: [BiGraphEdge] -> Int -> Bool -> Text 
lnkAsChild [] _ _ = pack ""
lnkAsChild [x] _ _ = "L{" |+> lineLnk x <+| "}" 
lnkAsChild (x:xs) n False = "L{" |+> lineLnk x <+| "}" `conbar` 
                                     lnkAsChild xs n False
lnkAsChild (x:xs) n True  = "L{" |+> lineLnk x <+| "}" `conbar` 
                                     lnkAsChild xs n True

ctrRule :: Bool -> [Type] -> Int -> (BiGraphNode, [BiGraphEdge]) -> Text
ctrRule False vs n (d, ls) = node d <+> lnkRule d vs ls
ctrRule True  vs n (d, ls) = tab  n <+> 
                                node d <+> 
                                lnkRule d vs ls <+> 
                                line ""

lnkRule :: BiGraphNode -> [Type] -> [BiGraphEdge] -> Text
lnkRule _ _ [] = pack "}"
lnkRule d ts (x:xs) 
   | d `isVarying` ts = pack "}"
   | otherwise  = "," |+> foldr (concomma.lineLnk) (lineLnk x) xs <+| "}"

branch :: Bool -> [Type] -> Int -> Text -> AbsHypergraph -> Text
branch False vs n x y = x `conbar` toRules vs y (n + 1) False
branch True vs n x y = x <+> tab n `conbar` toRules vs y (n + 1) True

children :: Bool -> Int -> Text -> Text
children False n xs | null xs   = xs
                    | otherwise = ".("  |+> xs <+| ")"
children True  n xs | null xs   = xs
                    | otherwise = tab n <+| ".("  <+> xs <+| ")"