module Policies.Default where

import           BX.Shared
import           Data.AbsCity
import           Data.Bigraphs
import           Data.Text                (append, pack)
import           Data.Tree.NTree.TypeDefs
import           Utilities.Basics
import           Policies.Stubs.Building

-- data Default =

-- .......................:::::::: Link Graph ::::::::....................... --

refresh :: AbsTopology -> LinkGraph -> AbsTopology
refresh (NTree (n, _) cs) l = NTree (n, map project l) cs


-- .......................:::::::: Place Graph ::::::::...................... --



-- Parent's update (node added)
commit :: AbsCityTree -> AbsCityTree -> AbsCityTree
commit (NTree d cs) (NTree cd _) = NTree (d `difference` cd) cs

difference :: AbsCityNode -> AbsCityNode -> AbsCityNode
difference (i, (t, d)) (_, (_, cd)) = (i, (t, d))
--difference (i, (t, d)) (_, (_, cd)) = (i, (t, d ++ "{" ++ "++" ++ cd ++ "}"))  -- TODO: subtract cd from d


-- Parent's update (node removed)
revert :: AbsCityTree -> AbsCityTree -> AbsCityTree
revert (NTree d cs) (NTree cd _) = NTree (d `union` cd) cs

union :: AbsCityNode -> AbsCityNode -> AbsCityNode
union (i, (t, d)) (_, (_, cd)) = (i, (t, d))
--union (i, (t, d)) (_, (_, cd)) = (i, (t, d ++ "{" ++ "--" ++ cd ++ "}")) -- TODO: add cd to d


-- | New node initialization:
-- parent
create :: AbsCityTree  -> PlaceGraph -> AbsCityTree
create (NTree d ms) (NTree (i, t) [])
    = case t of
        "Building" -> NTree (i, (t, pack $ show $ sBuilding i)) []
create (NTree d _) (NTree cd _) = NTree (extract cd d) []

extract :: BiGraphNode -> AbsCityNode -> AbsCityNode
extract (i, t) (_, (_, pd)) = (i, (t, d))
                              where
                                d = pack t `append` pack i `append` pack "{@@"
                                      `append` pd `append` pack "}"
