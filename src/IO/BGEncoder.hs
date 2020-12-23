
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
import           Data.Text                (Text, append, pack)
import           Data.Tree.NTree.TypeDefs
import           Libs.Basics
import           Libs.NTreeExtras

(|+|) :: String -> String -> Text
(|+|) x y = pack x `append` pack y

(|+>) :: String -> Text -> Text
(|+>) x y = pack x `append` y

(<+|) :: Text -> String -> Text
(<+|) x y = x `append` pack y

(<+>) :: Text -> Text -> Text
(<+>) x y = x `append` y

-- | General bigraph scheme:
-- | 1 - Controls
-- | 2 - Bigraph nesting with "." for leaves and "|" for branching
-- | 3 - {x1, x2, ...} for per-node names and links
encodeBG :: BiGraph -> Text
encodeBG b =   {-# SCC "TC_ViewEncode" #-} 
               let h = mergeBiGraphs b
               in encodeCtrls h <+| "big a0 = " <+> toRules h <+| ";\n"


-- | Control encoding criterion:
-- | We add a line for each control
encodeCtrls :: AbsHypergraph -> Text
encodeCtrls n@(NTree d cs) = foldr (append.showCtrl) (showCtrl n) cs

toRules :: AbsHypergraph -> Text
toRules n@(NTree _ []) = nodeToRule n
toRules n@(NTree _ (c:cs)) = nodeToRule n <+| ".("  <+> 
                           --foldr (conbar.toRules) (pack "") cs 
                           foldl (\x y -> conbar x (toRules y)) (toRules c) cs
                           <+| ")"

nodeToRule :: AbsHypergraph -> Text
nodeToRule (NTree (d, ls) _) = showNode d <+> linksToRules ls

linksToRules :: [BiGraphEdge] -> Text
linksToRules []     = pack ""
linksToRules (x:xs) = "{" |+>
                           foldr (concomma.showLink) (showLink x) xs 
                      <+| "}"

showLink :: BiGraphEdge -> Text
showLink (i, (t, _)) = i |+| "-" <+| t

showNode :: BiGraphNode -> Text
showNode (i, t) = sanitize i |+| "-" <+| sanitize t

showCtrl :: AbsHypergraph -> Text
showCtrl (NTree (n, ls) _) =  "ctrl " |+> showNode n <+| " = " <+| 
                              show (length ls) <+| ";\n"

sanitize :: String -> String
sanitize "" = ""
sanitize ('-' : xs) = '_' : sanitize xs
sanitize (':' : xs) = '_' : sanitize xs

-- | String concatenation by comma ( , ).
concomma :: Text -> Text -> Text
concomma x y = x <+| "," <+> y

-- | String concatenation by bar ( | ).
conbar ::  Text -> Text -> Text
conbar x y = x <+| " | " <+> y