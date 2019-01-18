module BX.Shared where

import           Data.AbsCity
import           Data.Bigraphs
import           Data.Tree.NTree.TypeDefs
import           Libs.Basics
import           Libs.NTreeExtras

-- ....................:::::: BASICS ::::::.................... --

(=@=) :: NTree (UID, a) -> NTree (UID, b) -> Bool
(=@=) a b = tKey a == tKey b

key :: (UID, a) -> UID
key (i, _) = i

tKey :: NTree (UID, a) -> UID
tKey (NTree d _) = key d

key2 :: NTree ((UID, a), b) -> UID
key2 (NTree (d, _) _) = key d

equivLink :: [AbsRelation] -> [BiGraphEdge] -> Bool
equivLink s v = map revProj s == v

equiv :: AbsCityTree -> PlaceGraph -> Bool
equiv = check1 (=@=)

dummyNode :: PlaceGraph -> AbsCityTree
dummyNode (NTree (i, _) _) = NTree (i, ("Dummy","Error")) []

dummyNode2 :: BiGraphNode -> AbsCityNode
dummyNode2 (i, t) = (i, (t, ""))

dummyLink :: AbsHypergraph -> AbsTopology
dummyLink (NTree ((i, _), ls) _)
    = NTree ((i, ("Dummy","Error")), map project ls) []


-- TODO: will be probablyremoved after refactoring of AbsCityNode
project :: BiGraphEdge -> AbsRelation
project (e, (t, ls)) = (e, (t, map pr ls))
    where
        pr (i, t) = (i, (t, ""))

revProj :: AbsRelation -> BiGraphEdge
revProj (i, (t, ls)) = (i, (t, map pr ls))
    where
        pr (i, (t, _)) = (i, t)
