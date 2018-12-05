--{-# LANGUAGE DeriveGeneric #-}
module CityGML.Abstractions where

import           AbsCity
import           Abstractable
import           CityGML.Types
import           Data.Tree.NTree.TypeDefs
import           GHC.Generics

instance Abstractable CityModel where
    absObj (CityModel n b ms)
        = NTree (n, ("CityModel", show (CityModel n b ms))) (map absObj ms)

    reiObj (NTree (_, (_, d)) ms)
        = reshape' (read d) ms
            where
                reshape' (CityModel n b _) ms = CityModel n b (map reiObj ms)


instance Abstractable CityObjectMember where
    absObj b@(Building i h l0f l0r l1)
        = NTree (i, ("Building", show b)) []

    -- reiObj = default
