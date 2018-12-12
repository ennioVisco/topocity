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

import           CityGML.Bridge.Types         as Bridge
import           CityGML.Building.Types       as Building
import           CityGML.Generics.Types       as Generics
import           CityGML.GML.Types            as GML
import           CityGML.Relief.Types         as Relief
import           CityGML.Transportation.Types as Transportation
import           CityGML.Vegetation.Types     as Vegetation
import           CityGML.WaterBody.Types      as WaterBody

import           GHC.Generics

data CityModel = CityModel
    {   cFeature :: Feature
    ,   cMembers :: [CityObjectMember]
    }   deriving (Read, Show, Eq, Generic)

data CityObjectMember =
        Site Site
    |   Veg  VegetationObject
    |   Gen  GenericCityObject
    |   Wtr  WaterObject
    |   Tran TransportationObject
    |   Dem  ReliefFeature

    -- |   Grp  CityObjectGroup
    -- |   Frn  CityFurniture
    -- |   Luse LandUse
    deriving (Read, Show, Eq, Generic)



data Site =
        Bld AbstractBuilding
    |   Brg AbstractBridge

    -- |   Tun AbstractTunnel
    deriving (Read, Show, Eq, Generic)
