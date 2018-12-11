{-# LANGUAGE DeriveGeneric #-}

-- ------------------------------------------------------------

{- |
   Module     : CityGML.Core.Types

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : stable
   Portability: portable

   Types related to the Core module of the Thematic model of CityGML.

-}

-- ------------------------------------------------------------

module CityGML.Core.Types where

import           CityGML.Building.Types

import           CityGML.GML.Types

import           GHC.Generics

data CityModel = CityModel
    {   cFeature :: Feature
    ,   cMembers :: [CityObjectMember]
    }   deriving (Read, Show, Eq, Generic)

data CityObjectMember =
        Site Site
    -- |   Veg  VegetationObject
    -- |   Gen  GenericObject
    -- |   Wtr  WaterObject
    -- |   Tran Transportation
    -- |   Dem  Relief

    -- |   Grp  CityObjectGroup
    -- |   Frn  CityFurniture
    -- |   Luse LandUse
    deriving (Read, Show, Eq, Generic)



data Site =
        Bld AbstractBuilding
    -- |   Brg AbstractBridge

    -- |   Tun AbstractTunnel
    deriving (Read, Show, Eq, Generic)
