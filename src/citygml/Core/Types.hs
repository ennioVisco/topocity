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

data CityObjectMember = Building
    {   bId            :: String
    ,   bHeight        :: Measure
    ,   bLod0FootPrint :: Maybe Lod0Model
    ,   bLod0RoofEdge  :: Maybe Lod0Model
    ,   bLod1Solid     :: Maybe Lod1Model
    }   deriving (Read, Show, Eq, Generic)

data Measure = Height
    {   mUom   :: String
    ,   mValue :: Float
    }   deriving (Read, Show, Eq, Generic)
