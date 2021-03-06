
-- ------------------------------------------------------------

{- |
   Module     : Data.AbsCity

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : stable
   Portability: portable

   This module contains the types and helpers for abstract city representation.

-}

-- ------------------------------------------------------------

module Data.AbsCity where

import           Data.Tree.NTree.TypeDefs
import           Libs.Basics
import           Libs.NTreeExtras


-- ......................:::::::: Data Types ::::::::....................... --

type AbsCityNode = (UID, (Type, Data))
type AbsCityTree = NTree AbsCityNode

type AbsRelation = (UID, (Type, [AbsCityNode]))
type AbsTopology = NTree (AbsCityNode, [AbsRelation])

type AbsCity = (AbsCityTree, [AbsRelation])


-- ........................:::::::: Helpers ::::::::........................ --

mergeCityTopo :: AbsCity -> AbsTopology
mergeCityTopo (c, l) = fmap (augmentCNode l) c

augmentCNode :: [AbsRelation] -> AbsCityNode -> (AbsCityNode, [AbsRelation])
augmentCNode ls n@(i, (t, _)) = (n, subGraph (i, (t, "")) ls)
