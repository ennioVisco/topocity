
-- ------------------------------------------------------------

{- |
   Module     : Data.BiGraph

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : stable
   Portability: portable

   This module contains the types and helpers for bigraphs.

-}

-- ------------------------------------------------------------

{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE TypeSynonymInstances #-}

module Data.Bigraphs where

import           Data.Tree.NTree.TypeDefs
import           Libs.Basics
import           Libs.NTreeExtras

-- ......................:::::::: Data Types ::::::::....................... --

type BiGraph     = (PlaceGraph, LinkGraph)
type LinkGraph   = [BiGraphEdge]
type PlaceGraph  = NTree BiGraphNode

type BiGraphNode = (UID, Type)
type BiGraphEdge = (UID, (Type, [BiGraphNode]))

type AbsHypergraph = NTree (BiGraphNode, [BiGraphEdge])

-- ........................:::::::: Helpers ::::::::........................ --

mergeBiGraphs :: BiGraph -> AbsHypergraph
mergeBiGraphs (p, l) = fmap (augmentBiNode l) p

augmentBiNode :: LinkGraph -> BiGraphNode -> (BiGraphNode, [BiGraphEdge])
augmentBiNode l n = (n, subGraph n l)
