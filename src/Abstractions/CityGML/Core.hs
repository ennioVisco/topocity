
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
import           Data.Tree.NTree.TypeDefs
import           Identifiable

import           Abstractions.CityGML.Building
import           Abstractions.CityGML.Transportation

instance Abstractable CityModel where
    absObj (CityModel f ms)
        = NTree (uid f, ("CityModel", show (CityModel f ms))) (map absObj ms)

    reiObj (NTree (_, (_, d)) ms)
        = reshape' (read d) ms
            where
                reshape' (CityModel f _) ms = CityModel f (map reiObj ms)

instance Abstractable Site where
    absObj (Bld b) = absObj b
    reiObj d = Bld (reiObj d)

instance Abstractable CityObjectMember where
    absObj (Site s) = absObj s
    absObj (Tran r) = absObj r
    absObj _        = error "uncaught exception"

    reiObj d@(NTree (_, ("Building", _)) _) = Site (reiObj d)
    reiObj d@(NTree (_, ("Road", _)) _)     = Tran (reiObj d)
