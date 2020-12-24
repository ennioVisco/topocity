
-- ------------------------------------------------------------

{- |
   Module     : BX.Shared

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : stable
   Portability: portable

   Collection of helpers shared by the BX core.

-}

-- ------------------------------------------------------------

module BX.Shared where

import           Data.AbsCity
import           Data.Bigraphs
import           Data.Text                (pack)
import           Data.Tree.NTree.TypeDefs
import           Utilities.Basics
import           Utilities.NTreeExtras

-- ................:::::: KEY EXTRACTORS ::::::................ --

-- | 'key' is the most fundamental key extractor
key :: (UID, a) -> UID
key (i, _) = i

-- | 'tKey' is the key extractor for Trees
tKey :: NTree (UID, a) -> UID
tKey (NTree d _) = key d

-- | 'hKey' is the key extractor for hypergraphs
hKey :: NTree ((UID, a), b) -> UID
hKey (NTree (d, _) _) = key d

-- | Basic equivalence relation between identifiable Trees:
-- | t1 '=@=' t2 iff they have the same key.
(=@=) :: NTree (UID, a) -> NTree (UID, b) -> Bool
(=@=) a b = tKey a == tKey b

-- | Equivalence relation between relations and links:
-- | r1 'equivLink' r2 iff they have the same (key, type) pair.
equivLink :: [AbsRelation] -> [BiGraphEdge] -> Bool
equivLink s v = map project v == s

-- | Equivalence relation between a CityTree and a PlaceGraph:
-- | c 'equiv' p iff '(=@=)' holds thoroughout the trees.
equiv :: AbsCityTree -> PlaceGraph -> Bool
equiv = check1 (=@=)

-- | Transforms a link into an empty relation.
project :: BiGraphEdge -> AbsRelation
project (e, (t, ls)) = (e, (t, map pr ls))
    where
        pr (i, t) = (i, (t, pack ""))


-- ...............:::::: Dummy Generators ::::::............... --

dummyNode :: PlaceGraph -> AbsCityTree
dummyNode (NTree (i, _) _) = NTree (i, ("Dummy", pack "Error")) []

dummyNode2 :: BiGraphNode -> AbsCityNode
dummyNode2 (i, t) = (i, (t, pack ""))

dummyLink :: AbsHypergraph -> AbsTopology
dummyLink (NTree ((i, _), ls) _)
    = NTree ((i, ("Dummy", pack "Error")), map project ls) []
