{-# LANGUAGE DeriveGeneric #-}

-- ------------------------------------------------------------

{- |
   Module     : CityGML.Generics.Types

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : stable
   Portability: portable

   Types related to the Generics module of the Thematic model of CityGML.

-}

-- ------------------------------------------------------------

module CityGML.Generics.Types where

import           CityGML.GML.Types

import           GHC.Generics

data GenericCityObject = GenericCityObject
    {   genFeature   :: Feature
    ,   genLod1Model :: Maybe GenLod1Model
    }   deriving (Read, Show, Eq, Generic)


data GenLod1Model = GenLod1Geometry Geometry
                 deriving (Read, Show, Eq, Generic)
