{-# LANGUAGE DeriveGeneric #-}

-- ------------------------------------------------------------

{- |
   Module     : CityGML.Building.Types

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : stable
   Portability: portable

   Types related to the Building module of the Thematic model of CityGML.

-}

-- ------------------------------------------------------------

module CityGML.Building.Types where

import           CityGML.GML.Types

import           GHC.Generics

data Lod0Model = FootPrint MultiSurface
               | RoofEdge MultiSurface
                deriving (Read, Show, Eq, Generic)

data Lod1Model = Lod1Solid Solid
                 deriving (Read, Show, Eq, Generic)
