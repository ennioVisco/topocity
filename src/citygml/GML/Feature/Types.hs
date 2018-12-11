{-# LANGUAGE DeriveGeneric #-}

-- ------------------------------------------------------------

{- |
   Module     : CityGML.GML.Feature.Types

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : stable
   Portability: portable

   This module provides the data types for the _Feature class of the GML
   specification (actually focusing on the CityGML subset of features).

-}

-- ------------------------------------------------------------

module CityGML.GML.Feature.Types where

import           CityGML.GML.Base
import           GHC.Generics

{- | 'Feature' is the implementation of _Feature as from section 7.4.1.2 of GML
    specification. As stated there:

    gml:_Feature can be thought of as “anything that is a GML feature” and can
    be used to define variables or templates in which the value of a GML
    property is “any feature”. This occurs in particular in a GML Feature
    Collection
-}
data Feature = Feature
    {   gml       :: GML
    ,   boundedBy :: Maybe BoundedBy
        -- location (?)
    }
    deriving (Read, Show, Eq, Generic)

-- | 'BoundedBy' incomplete specification based on section 7.4.1.3 of GML spec.
data BoundedBy = BoundedBy
    {   srsDimension :: Int
    ,   srsName      :: String
    ,   lCorner      :: String
    ,   uCorner      :: String
    }   deriving (Read, Show, Eq, Generic)

-- | 'FeatureCollection' is the implementation of _FeatureCollection as from
-- section 7.4.1.8 of GML specification. Note: 'featureMembers' is NOT
-- implemented.
data FeatureCollection = FeatureCollection
    {   feature       :: Feature
    ,   featureMember :: [Feature]
        -- featureMembers (?)
    }
    deriving (Read, Show, Eq, Generic)
