module CityGML.Abstractions where

import           AbsCity
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

instance Abstractable CityObjectMember

instance Identifiable AbstractBuilding where
    getId (Building i _ _ _ _) = i

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
