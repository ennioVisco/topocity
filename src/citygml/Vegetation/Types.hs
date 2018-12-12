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

module CityGML.Vegetation.Types where

import           CityGML.GML.Types

import           GHC.Generics

data VegetationObject = PlantCover
    {   vegFeature   :: Feature
    ,   vegLod1Model :: Maybe VegLod1Model
    }   deriving (Read, Show, Eq, Generic)


data VegLod1Model = VegLod1MultiSurf MultiSurface
                 deriving (Read, Show, Eq, Generic)
