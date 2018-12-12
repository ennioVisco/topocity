{-# LANGUAGE DeriveGeneric #-}

-- ------------------------------------------------------------

{- |
   Module     : CityGML.Building.Types

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : stable
   Portability: portable

   Types related to the Transportation module of the Thematic model of CityGML.

-}

-- ------------------------------------------------------------

module CityGML.Transportation.Types where

import           CityGML.GML.Types

import           GHC.Generics

data TransportationObject = Road
    {   transFeature   :: Feature
    ,   transLod1Model :: Maybe TransLod1Model
    }   deriving (Read, Show, Eq, Generic)


data TransLod1Model = TransLod1MultiSurf MultiSurface
                 deriving (Read, Show, Eq, Generic)
