
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

(+++) :: Text -> Text -> Text
(+++) x y = x `append` y

p :: String -> Text
p x = pack x

-- | General bigraph scheme:
-- | 1 - Controls
-- | 2 - Bigraph nesting with "." for leaves and "|" for branching
-- | 3 - {x1, x2, ...} for per-node names and links
encodeBG :: BiGraph -> Text
encodeBG b = {-# SCC "TC_ViewEncode" #-} let h = mergeBiGraphs b
                in encodeCtrls h +++ 
                p "big a0 = " +++ toRules h +++  p ";\n"


encodeCtrls :: AbsHypergraph -> Text
encodeCtrls n@(NTree d cs) = foldr (append.showCtrl) (showCtrl n) cs

toRules :: AbsHypergraph -> Text
toRules n@(NTree _ []) = nodeToRule n
toRules n@(NTree _ (c:cs)) = nodeToRule n +++ p ".("  +++ 
                           --foldr (conbar.toRules) (pack "") cs 
                           foldl (\x y -> conbar x (toRules y)) (toRules c) cs
                           +++ p ")"

nodeToRule :: AbsHypergraph -> Text
nodeToRule (NTree (d, ls) _) = showNode d +++ linksToRules ls

linksToRules :: [BiGraphEdge] -> Text
linksToRules []     = p ""
linksToRules (x:xs) = p "{" +++
                      foldr (concomma.showLink) (showLink x) xs +++
                      p "}"

showLink :: BiGraphEdge -> Text
showLink (i, (t, _)) = p i +++ p "-" +++ p t

showNode :: BiGraphNode -> Text
showNode (i, t) = p (sanitize i) +++ p "-" +++ p (sanitize t)

showCtrl :: AbsHypergraph -> Text
showCtrl (NTree (n, ls) _) =  p "ctrl " +++ showNode n +++ p " = " +++ 
                              p (show $ length ls) +++ p ";\n"

sanitize :: String -> String
sanitize "" = ""
sanitize ('-' : xs) = '_' : sanitizeID xs
sanitize (':' : xs) = '_' : sanitizeID xs

-- | String concatenation by comma ( , ).
concomma :: Text -> Text -> Text
concomma x y = x +++ p "," +++ y

-- | String concatenation by bar ( | ).
conbar ::  Text -> Text -> Text
conbar x y = x +++ p " | " +++ y