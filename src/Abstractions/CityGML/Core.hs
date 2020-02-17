
-- ------------------------------------------------------------

{- |
   Module     : Abstractions.CityGML.Core

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : stable
   Portability: portable

   This module contains the instances of the Abstractable class
   from 'CityGML.Core'.

-}

-- ------------------------------------------------------------

module Abstractions.CityGML.Core where

import           Abstractions.Abstractable
import           CityGML.Types
import           Data.Text                           (pack, unpack)
import           Data.Tree.NTree.TypeDefs
import           Identifiable

import           Abstractions.CityGML.Building
import           Abstractions.CityGML.Transportation

instance Abstractable CityModel where
    absObj (CityModel f ms)
        = NTree (uid f, ("CityModel", pack $ show (CityModel f ms))) (map absObj ms)

    reiObj (NTree (_, (_, d)) ms)
        = reshape' (read $ unpack d) ms
            where
                reshape' (CityModel f _) ms = CityModel f (map reiObj ms)

instance Abstractable Site where
    -- WARNING: this is wrong in general, only buildings supported
    --          (see also instance Abstractable CityObjectMember)
    absObj (Bld b) = absObj b
    absObj (Brg b) = absObj b

    reiObj d@(NTree (_, ("Building", _)) ms) = Bld (reiObj d)
    reiObj d@(NTree (_, ("Bridge", _)) ms)   = Brg (reiObj d)


instance Abstractable ReliefFeature where
    absObj (ReliefFeature f l cs)
        =  NTree (uid f, ("ReliefFeature", pack $ show (ReliefFeature f l cs)))
                 (map absObj cs)

    reiObj (NTree (_, ("ReliefFeature", d)) ms)
        = reshape' (read $ unpack d::ReliefFeature) ms
            where
                reshape' (ReliefFeature f l _) ms = ReliefFeature f l (map reiObj ms)



instance Abstractable CityObjectMember where
    absObj (Site s) = absObj s
    absObj (Tran r) = absObj r
    absObj (Wtr  w) = absObj w
    absObj (Gen  g) = absObj g
    absObj (Veg  v) = absObj v
    absObj (Dem  r) = absObj r
    absObj _        = error "UnhandledCityGMLObjectException"
    -- this is redundant but kept as there are still some missing CityGML features

    reiObj d@(NTree (_, ("Building", _)) _)         = Site (reiObj d)
    reiObj d@(NTree (_, ("Road", _)) _)             = Tran (reiObj d)
    reiObj d@(NTree (_, ("WaterBody", _)) _)        = Wtr  (reiObj d)
    reiObj d@(NTree (_, ("ReliefFeature", _)) _)    = Dem  (reiObj d)
    reiObj d@(NTree (_, ("GenericObject", _)) _)    = Gen  (reiObj d)
    reiObj d@(NTree (_, ("VegetationObject", _)) _) = Veg  (reiObj d)

instance Abstractable VegetationObject
instance Abstractable GenericCityObject
instance Abstractable WaterObject
instance Abstractable Relief
instance Abstractable ReliefComponent

instance Abstractable AbstractBridge
