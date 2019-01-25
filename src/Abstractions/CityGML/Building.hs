
-- ------------------------------------------------------------

{- |
   Module     : Abstractions.CityGML.Building

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : stable
   Portability: portable

   This module contains the instances of the Abstractable class
   from 'CityGML.Modules.Building'.

-}

-- ------------------------------------------------------------

module Abstractions.CityGML.Building where

import           Abstractions.Abstractable
import           CityGML.Types
import           Data.Data
import           Data.Tree.NTree.TypeDefs
import           Identifiable


instance Abstractable AbstractBuilding where
    absObj b@(Building (BldgData f _ _ _ _ bs ps _))
        = NTree (uid f, ("Building", show b))
                (map absObj bs ++ map absObj ps)
    absObj b@(BuildingPart (BldgData f _ _ _ _ bs ps _))
        = NTree (uid f, ("BuildingPart", show b))
                (map absObj bs ++ map absObj ps)

    reiObj (NTree (_, ("Building", d)) ms)
        = reshape' (read d) ms
            where
            reshape' (Building (BldgData g bi ls it i bs _ a)) ps =
                Building (BldgData g bi ls it i bs (map reiObj ps) a)
    reiObj (NTree (_, ("BuildingPart", d)) ms)
        = reshape' (read d) ms
            where
            reshape' (BuildingPart (BldgData g bi ls it i bs _ a)) ps =
                BuildingPart (BldgData g bi ls it i bs (map reiObj ps) a)

instance Abstractable WallSurface where
    absObj w@(WallSurface f _ _ os) = NTree (uid f, ("WallSurface", show w)) (map absObj os)

    reiObj (NTree (_, ("WallSurface", d)) os)
        = reshape' (read d) os
            where
            reshape' (WallSurface f l2 l3 _) os =
                    WallSurface f l2 l3 (map reiObj os)

instance Abstractable RoofSurface where
    absObj w@(RoofSurface f _ _ os) = NTree (uid f, ("RoofSurface", show w)) (map absObj os)

    reiObj (NTree (_, ("RoofSurface", d)) os)
        = reshape' (read d) os
            where
            reshape' (RoofSurface f l2 l3 _) os =
                    RoofSurface f l2 l3 (map reiObj os)

instance Abstractable BuildingSurface

instance Abstractable Opening

instance Abstractable BldgBoundary where
    absObj (Wall s) = absObj s
    absObj (Roof s) = absObj s
    absObj n        = NTree (uid n, (show $ toConstr n, show n)) []

    reiObj w@(NTree (_, ("WallSurface", _)) _) = reiObj w
    reiObj r@(NTree (_, ("RoofSurface", _)) _) = reiObj r
    reiObj (NTree (_, (_, d)) _)               = read d
