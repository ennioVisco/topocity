{-# LANGUAGE DeriveGeneric #-}

-- ------------------------------------------------------------

{- |
   Module     : CityGML.GML.Geometry.Types

   Maintainer : Ennio Visconti ("ennio.visconti\@mail.polimi.it")
   Stability  : stable
   Portability: portable

   Types related to the GML model of CityGML.

   Note: Combined geometries can be aggregates, complexes or composites of
   primitives.

   1. __/Aggregates/__ have no restricted spatial relation between components.
   They are implemented in CityGML by the "Multi" prefix.
   2. __/Complexes/__ are topologically structured: their parts must be
   disjoint, must not overlap and are allowed to touch, at most, at their
   boundaries or
   share parts of their boundaries.
   3. __/Composites/__ are a special kind of complexes. They only contain
   elements of the same dimension. Additionally, their elements must be
   topologically connected among their boundaries.

-}

-- ------------------------------------------------------------

module CityGML.GML.Geometry.Types where

import           GHC.Generics

-- ........................:::::::: _Geometry ::::::::...................... --

data Geometry =
        GC GeometricComplex
    |   GP GeometricPrimitive
    |   GA GeometricAggregate
    deriving (Read, Show, Eq, Generic)

-- .....................:::::::: GeometricComplex :::::..................... --

newtype GeometricComplex = GeometricComplex [GeometricPrimitive]
    deriving (Read, Show, Eq, Generic)

-- ...............:::::::: _AbstractGeometricAggregate :::::................ --

data GeometricAggregate =
        MGE MultiGeometry
    |   MSO MultiSolid
    |   MSU MultiSurface
    |   MCU MultiCurve
    |   MPO MultiPoint
    deriving (Read, Show, Eq, Generic)

-- ...................:::::::: GeometricAggregates ::::::::................. --

newtype MultiGeometry = MultiGeometry [Geometry]
    deriving (Read, Show, Eq, Generic)

newtype MultiSolid = MultiSolid [Solid]
    deriving (Read, Show, Eq, Generic)

newtype MultiSurface = MultiSurface [Surface]
    deriving (Read, Show, Eq, Generic)

newtype MultiCurve = MultiCurve [Curve]
    deriving (Read, Show, Eq, Generic)

newtype MultiPoint = MultiPoint [Point]
    deriving (Read, Show, Eq, Generic)

-- ...................:::::::: GeometricPrimitive ::::::::.................. --

data GeometricPrimitive =
        SO Solid
    |   SU Surface
    |   CU Curve
    |   PO Point
    deriving (Read, Show, Eq, Generic)

-- .........................:::::::: _Solid ::::::::........................ --
data Solid =
        Solid
        {   sdExterior ::  Surface
        ,   sdInterior :: [Surface]
        }
    |   CompositeSolid [Solid]
    deriving (Read, Show, Eq, Generic)

-- ........................:::::::: _Surface ::::::::....................... --

data Surface =
        Polygon
        {   scExterior ::  Ring
        ,   scInterior :: [Ring]
        }
    |   CompositeSurface [Surface]
    |   Surface [SurfacePatch]
    |   OrientableSurface
        {   sOrientation :: String
        ,   baseSurface  :: Surface
        }
    deriving (Read, Show, Eq, Generic)

data SurfacePatch = T Triangle | R Rectangle
    deriving (Read, Show, Eq, Generic)

newtype TriangulatedSurface = Patches [Triangle]
    deriving (Read, Show, Eq, Generic)

newtype Triangle = Triangle Ring
    deriving (Read, Show, Eq, Generic)

newtype Rectangle = Rectangle Ring
    deriving (Read, Show, Eq, Generic)

newtype Ring = LinearRing [Point]
    deriving (Read, Show, Eq, Generic)

-- .........................:::::::: _Curve ::::::::........................ --

data Curve =
        LineString [Point]
    |   CompositeCurve [Curve]
    deriving (Read, Show, Eq, Generic)

-- ..........................:::::::: Point ::::::::........................ --

newtype Point = Coord
    {   pCoords :: String
    }   deriving (Read, Show, Eq, Generic)
