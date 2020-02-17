
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

encodeBG :: BiGraph -> Text
encodeBG b = {-# SCC "TC_ViewEncode" #-} let h = mergeBiGraphs b
                in append (encodeCtrls h)
                 $ append (pack "big a0 = ")
                 $ append (toRules h) (pack ";\n")


encodeCtrls :: AbsHypergraph -> Text
encodeCtrls n@(NTree d cs) = Prelude.foldr (append.showCtrl) (showCtrl n) cs

toRules :: AbsHypergraph -> Text
toRules n@(NTree _ []) = nodeToRule n
toRules n@(NTree _ cs) = append (nodeToRule n)
                       $ append (pack ".(")
                       $ append (Prelude.foldr (conbar.toRules) (pack "") cs) (pack ")")

nodeToRule :: AbsHypergraph -> Text
nodeToRule (NTree (d, ls) _) = showNode d `append` linksToRules ls

linksToRules :: [BiGraphEdge] -> Text
linksToRules []     = pack ""
linksToRules (x:xs) = append (pack "{")
                    $ append (Prelude.foldr (concomma.showLink) (showLink x) xs)
                             (pack "}")

showLink :: BiGraphEdge -> Text
showLink (i, (t, _)) = pack i `append` pack "-" `append` pack t

showNode :: BiGraphNode -> Text
showNode (i, t) = pack i `append` pack "-" `append` pack t

showCtrl :: AbsHypergraph -> Text
showCtrl (NTree (n, ls) _) = append (pack "ctrl ")
                           $ append (showNode n)
                           $ append (pack " = ")
                           $ append (pack $ show $ Prelude.length ls)
                                    (pack ";\n")

-- | String concatenation by comma ( , ).
concomma :: Text -> Text -> Text
concomma x y = append x $ append (pack ",") y

-- | String concatenation by bar ( | ).
conbar ::  Text -> Text -> Text
conbar x y = append x $ append (pack " | ") y
