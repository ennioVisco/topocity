module Abstractions where

import           CityGML.ADEs.TopoADE
import           CityGML.Types
import           Data.AbsCity
import           Data.Maybe
import           Data.Tree.NTree.TypeDefs
import           GHC.Generics
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
        = NTree (getId f, ("CityModel", show (CityModel f ms))) (map absObj ms)

    reiObj (NTree (_, (_, d)) ms)
        = reshape' (read d) ms
            where
                reshape' (CityModel f _) ms = CityModel f (map reiObj ms)


instance Abstractable AbstractBuilding

instance Abstractable Opening

instance Abstractable BldgBoundary

instance Abstractable Site where
    absObj (Bld b) = absObj b
    reiObj d = Bld (reiObj d)

instance Abstractable CityObjectMember where
    absObj (Site s) = absObj s
    reiObj d = Site (reiObj d)

-- Object Identifiers

instance Identifiable Opening where
    getId (Door f   _) = getId f
    getId (Window f _) = getId f

instance Identifiable BldgBoundary where
    getId (Wall    w) = getId w
    getId (Closure c) = getId c
    getId (Roof    r) = getId r
    getId (Ground  g) = getId g

instance Identifiable WallSurface where
    getId (WallSurface f _ _) = getId f

instance Identifiable RoofSurface where
    getId (RoofSurface f _ _) = getId f

instance Identifiable BuildingSurface where
    getId (BuildingSurface f _) = getId f

instance Identifiable AbstractBuilding where
    getId (Building f _ _ _ _ _ _ _ _ _ _ _) = getId f

instance Identifiable Site where
    getId (Bld b) = getId b

instance Identifiable CityObjectMember where
    getId (Site s) = getId s

instance Identifiable CityModel where
    getId (CityModel f _) = getId f

instance Identifiable Feature where
    getId (Feature g _) = getId g

instance Identifiable GML where
    getId (GML Nothing [] Nothing)                  = "UNKNOWN_ID"
    getId (GML (Just i) _ _)                        = i
    getId (GML _ (n:_) _) | isNothing (codeSpace n) = value n
                          | otherwise               = fromJust (codeSpace n) ++
                                                      value n
    getId (GML _ _ (Just d))                        = d
