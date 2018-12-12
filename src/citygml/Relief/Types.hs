{-# LANGUAGE DeriveGeneric #-}

-- ------------------------------------------------------------

{- |
   Module     : CityGML.Relief.Types

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : stable
   Portability: portable

   Types related to the Relief module of the Thematic model of CityGML.

-}

-- ------------------------------------------------------------

module CityGML.Relief.Types where

import           CityGML.GML.Types

import           GHC.Generics

data ReliefFeature = ReliefFeature
        {   demFFeature   :: Feature
        ,   demFLod       :: Integer
        ,   demComponents :: [Relief]
        }
    deriving (Read, Show, Eq, Generic)

data ReliefComponent = ReliefComponent
        {   demCFeature :: Feature
        ,   demCLod     :: Integer
        }
    deriving (Read, Show, Eq, Generic)

data Relief =
        TINRelief
        {   demTINComponent :: ReliefComponent
        ,   demTin          :: TriangulatedSurface
        }
    |   MassPointRelief
        {   demMPComponent :: ReliefComponent
        ,   reliefPoints   :: MultiPoint
        }
    |   BreaklineRelief
        {   demBLComponent     :: ReliefComponent
        ,   demBreaklines      :: Maybe MultiCurve
        ,   ridgeOrValleyLines :: Maybe MultiCurve
        }
    deriving (Read, Show, Eq, Generic)
