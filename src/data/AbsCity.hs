module Data.AbsCity where

import           Basics
import           Data.Tree.NTree.TypeDefs
import           NTreeExtras




-- CityGML abstracts representation
type AbsCityNode = (UID, (Type, Data))
type AbsCityTree = NTree AbsCityNode

type AbsRelation = (UID, (LinkType, [AbsCityNode]))
type AbsTopology = NTree (AbsCityNode, [AbsRelation])

type AbsCity = (AbsCityTree, [AbsRelation])


mergeCityTopo :: AbsCity -> AbsTopology
mergeCityTopo (c, l) = fmap (augmentCNode l) c

augmentCNode :: [AbsRelation] -> AbsCityNode -> (AbsCityNode, [AbsRelation])
augmentCNode ls n@(i, (t, _)) = (n, subGraph (i, (t, "")) ls)


-- TESTING
buildings = [
                NTree ("2", ("Building", "Building2")) [],
                NTree ("3", ("Building", "Building3")) [],
                NTree ("4", ("Building", "Building4")) [],
                NTree ("5", ("Building", "Building5")) []
            ]

-- building 1 description
doors   = [NTree ("6", ("Door", "Door6")) []]
windows =   [
                NTree ("7", ("Window", "Window7")) [],
                NTree ("8", ("Window", "Window8")) []
            ]

city =  NTree ("1", ("City", "City1")) []
city2 = addChildrenAt city city buildings
city3 = addChildrenAt (head buildings) city2 (doors ++ windows)
