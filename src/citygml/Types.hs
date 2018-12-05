{-# LANGUAGE DeriveGeneric #-}

module CityGML.Types where

import           GHC.Generics

data CityModel = CityModel
    {   cName      :: String
    ,   cBoundedBy :: BoundedBy
    ,   cMembers   :: [CityObjectMember]
    }   deriving (Read, Show, Eq, Generic)

data BoundedBy = BoundedBy
    {   srsDimension :: Int
    ,   srsName      :: String
    ,   lCorner      :: String
    ,   uCorner      :: String
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

data Lod0Model = FootPrint MultiSurface
               | RoofEdge MultiSurface
                deriving (Read, Show, Eq, Generic)

data Lod1Model = Lod1Solid CompositeSurface
                 deriving (Read, Show, Eq, Generic)

data CompositeSurface = Comp [SurfaceMember]
                        deriving (Read, Show, Eq, Generic)

data MultiSurface = Multi [SurfaceMember]
                     deriving (Read, Show, Eq, Generic)

data SurfaceMember = Surface [Point]
                     deriving (Read, Show, Eq, Generic)

newtype Point = Coord
    {   pCoords :: String
    }   deriving (Read, Show, Eq, Generic)
