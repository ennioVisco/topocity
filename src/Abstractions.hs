module Abstractions where

import           CityGML.ADEs.TopoADE
import           CityGML.Types
import           Data.AbsCity
import           Data.Maybe
import           Data.Tree.NTree.TypeDefs
import           GHC.Generics
import           Identifiable
import           Libs.Abstractable

-- Object Abstractions

instance AbstractLink TopoRelation where
        absLink (Near i ns) = (i, ("Near", map a ns))
            where
            a (TopoBuilding i) = (i, ("Building", ""))

        reiLink (i, ("Near", ns)) = Near i (map r ns)
            where
            r (i, ("Building", _)) = TopoBuilding i

instance Abstractable CityModel where
    absObj (CityModel f ms)
        = NTree (uid f, ("CityModel", show (CityModel f ms))) (map absObj ms)

    reiObj (NTree (_, (_, d)) ms)
        = reshape' (read d) ms
            where
                reshape' (CityModel f _) ms = CityModel f (map reiObj ms)

instance Abstractable AbstractBuilding where
    absObj b@(Building (BldgData f _ _ _ _ _ bs ps _))
        = NTree (uid f, ("Building", show b))
                (map absObj bs ++ map absObj ps)
    absObj b@(BuildingPart (BldgData f _ _ _ _ _ bs ps _))
        = NTree (uid f, ("BuildingPart", show b))
                (map absObj bs ++ map absObj ps)

    reiObj (NTree (_, ("Building", d)) ms)
        = reshape' (read d) ms
            where
            reshape' (Building (BldgData g e bi ls it i bs _ a)) ps =
                Building (BldgData g e bi ls it i bs (map reiObj ps) a)
    reiObj (NTree (_, ("BuildingPart", d)) ms)
        = reshape' (read d) ms
            where
            reshape' (BuildingPart (BldgData g e bi ls it i bs _ a)) ps =
                BuildingPart (BldgData g e bi ls it i bs (map reiObj ps) a)

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
    absObj n        = NTree (uid n, (constrName n, show n)) []

    reiObj w@(NTree (_, ("WallSurface", _)) _) = reiObj w
    reiObj r@(NTree (_, ("RoofSurface", _)) _) = reiObj r
    reiObj (NTree (_, (_, d)) _)               = read d

instance Abstractable VegetationObject
instance Abstractable GenericCityObject
instance Abstractable WaterObject
instance Abstractable TransportationObject
instance Abstractable ReliefFeature

instance Abstractable Site where
    absObj (Bld b) = absObj b
    reiObj d = Bld (reiObj d)

instance Abstractable CityObjectMember where
    absObj (Site s) = absObj s
    absObj (Tran r) = absObj r
    absObj _        = error "uncaught exception"

    reiObj d@(NTree (_, ("Building", _)) _) = Site (reiObj d)
    reiObj d@(NTree (_, ("Road", _)) _)     = Tran (reiObj d)
