{-# LANGUAGE DeriveGeneric #-}

-- ------------------------------------------------------------

{- |
   Module     : CityGML.WaterBody.Types

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : stable
   Portability: portable

   Types related to the WaterBody module of the Thematic model of CityGML.

-}

-- ------------------------------------------------------------

module CityGML.WaterBody.Types where

import           CityGML.GML.Types

import           GHC.Generics

data WaterObject = WaterBody
    {   wtrFeature   :: Feature
    ,   wtrLod1Model :: Maybe WtrLod1Model
    }   deriving (Read, Show, Eq, Generic)


data WtrLod1Model = WtrLod1MultiSurf MultiSurface
                 deriving (Read, Show, Eq, Generic)
