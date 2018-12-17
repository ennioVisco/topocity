module CityGML.Abstractions where

import           Data.AbsCity
import           Abstractable
import           CityGML.Types
import           Data.Maybe
import           Data.Tree.NTree.TypeDefs
import           GHC.Generics

instance Abstractable CityModel where
    absObj (CityModel f ms)
        = NTree (getId f, ("CityModel", show (CityModel f ms))) (map absObj ms)

    reiObj (NTree (_, (_, d)) ms)
        = reshape' (read d) ms
            where
                reshape' (CityModel f _) ms = CityModel f (map reiObj ms)


instance Abstractable AbstractBuilding --where
    --reiObj (NTree (_, (_, d)) _) = Site (Bld (read d))


instance Abstractable Site where
    absObj (Bld b) = absObj b
    reiObj d = Bld (reiObj d)

instance Abstractable CityObjectMember where
    absObj (Site s) = absObj s
    reiObj d = Site (reiObj d)



instance Identifiable AbstractBuilding where
    getId (Building f _ _ _ _) = getId f

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
