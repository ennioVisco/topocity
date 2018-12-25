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

{-
    Building
    {   bFeature       :: Feature
    -- Building Optional Information
    ,   bHeight        :: Maybe Measure
    ,   bRoofType      :: Maybe String
    ,   bYearOfConstr  :: Maybe String
    ,   bFunction      :: Maybe String
    ,   bStAboveGround :: Maybe Int
    -- Building Models
    ,   bLod0FootPrint :: Maybe BldgLod0Model
    ,   bLod0RoofEdge  :: Maybe BldgLod0Model
    ,   bLod1Solid     :: Maybe BldgLod1Model
    ,   bLod3Solid     :: Maybe BldgLod3Model
    -- Building External Interfaces
    ,   bInstallations :: [BuildingInstallation]
    ,   bBoundedBy     :: [BldgBoundary]
    }
-}
instance Abstractable AbstractBuilding where
    absObj b@(Building f _ _ _ _ _ _ _ _ _ _ bs)
        = NTree (getId f, ("Building", show b))
                (map absObj bs)

    reiObj (NTree (_, (_, d)) ms)
        = reshape' (read d) ms
            where
                reshape' (Building g h s y r f l0f l0r l1 l3 i _) bs =
                    Building g h s y r f l0f l0r l1 l3 i (map reiObj bs)



instance Abstractable Opening

instance Abstractable BldgBoundary

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

-- Object Identifiers

instance Identifiable Opening where
    getId (Door f   _) = getId f
    getId (Window f _) = getId f

instance Identifiable BldgBoundary where
    getId (Wall    w) = getId w
    getId (Closure c) = getId c
    getId (Roof    r) = getId r
    getId (Ground  g) = getId g


instance Identifiable VegetationObject where
    getId (PlantCover f _) = getId f
instance Identifiable GenericCityObject where
    getId (GenericCityObject f _) = getId f
instance Identifiable WaterObject where
    getId (WaterBody f _) = getId f
instance Identifiable TransportationObject where
    getId (Road f _) = getId f
instance Identifiable ReliefFeature where
    getId (ReliefFeature f _ _) = getId f

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
