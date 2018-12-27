module Policies.Stubs.Building (sBuilding) where

import           CityGML.Types

sBuilding i =
    Building
        ( BldgData
            (sObject i)
            []
            (BuildingInfo Nothing Nothing (Just $ Height "#m" 100) Nothing Nothing)
            (BuildingModels l0f l0r l1s Nothing Nothing)
            (BuildingIntersections Nothing Nothing)
            []
            []
            []
            Nothing
        )

sObject  i = CityObject (sFeature i) Nothing Nothing [] [] Nothing Nothing
sFeature i = Feature (GML (Just i) [] Nothing) Nothing

l0f = Just (FootPrint fp)
l0r = Just (RoofEdge  re)
l1s = Just (BldgLod1Solid (Solid cs []))

fp = MultiSurface (Feature (GML Nothing [] Nothing) Nothing)
    [
        Polygon (Feature (GML Nothing [] Nothing) Nothing)
            (LinearRing (sFeature "RandomID")
              [  Coord "85010.059 447216.119 0.000"  Nothing
              ,  Coord "85065.266 447162.431 0.000"  Nothing
              ,  Coord "85069.605 447169.206 0.000"  Nothing
              ,  Coord "85067.298 447170.684 0.000"  Nothing
              ,  Coord "85069.019 447173.370 0.000"  Nothing
              ,  Coord "85068.943 447173.419 0.000"  Nothing
              ,  Coord "85070.556 447175.936 0.000"  Nothing
              ,  Coord "85017.737 447228.101 0.000"  Nothing
              ,  Coord "85010.059 447216.119 0.000"  Nothing
              ]) []
    ]

re = MultiSurface (Feature (GML Nothing [] Nothing) Nothing)
    [
        Polygon (Feature (GML Nothing [] Nothing) Nothing)
            (LinearRing (sFeature "RandomID")
              [  Coord "85010.059 447216.119 70.000" Nothing
              ,  Coord "85065.266 447162.431 70.000" Nothing
              ,  Coord "85069.605 447169.206 70.000" Nothing
              ,  Coord "85067.298 447170.684 70.000" Nothing
              ,  Coord "85069.019 447173.370 70.000" Nothing
              ,  Coord "85068.943 447173.419 70.000" Nothing
              ,  Coord "85070.556 447175.936 70.000" Nothing
              ,  Coord "85017.737 447228.101 70.000" Nothing
              ,  Coord "85010.059 447216.119 70.000" Nothing
              ]) []
    ]

cs = CompositeSurface
    [
        Polygon (Feature (GML Nothing [] Nothing) Nothing)
            (LinearRing (sFeature "RandomID")
              [  Coord "85017.737 447228.101 0.000"  Nothing
              ,  Coord "85070.556 447175.936 0.000"  Nothing
              ,  Coord "85068.943 447173.419 0.000"  Nothing
              ,  Coord "85069.019 447173.370 0.000"  Nothing
              ,  Coord "85067.298 447170.684 0.000"  Nothing
              ,  Coord "85069.605 447169.206 0.000"  Nothing
              ,  Coord "85065.266 447162.431 0.000"  Nothing
              ,  Coord "85010.059 447216.119 0.000"  Nothing
              ,  Coord "85017.737 447228.101 0.000"  Nothing
              ]
            ) []
        ,
        Polygon (Feature (GML Nothing [] Nothing) Nothing)
            (LinearRing (sFeature "RandomID")
              [  Coord "85010.059 447216.119 70.000" Nothing
              ,  Coord "85065.266 447162.431 70.000" Nothing
              ,  Coord "85069.605 447169.206 70.000" Nothing
              ,  Coord "85067.298 447170.684 70.000" Nothing
              ,  Coord "85069.019 447173.370 70.000" Nothing
              ,  Coord "85068.943 447173.419 70.000" Nothing
              ,  Coord "85070.556 447175.936 70.000" Nothing
              ,  Coord "85017.737 447228.101 70.000" Nothing
              ,  Coord "85010.059 447216.119 70.000" Nothing
              ]
            ) []
        ,
        Polygon (Feature (GML Nothing [] Nothing) Nothing)
            (LinearRing (sFeature "RandomID")
              [  Coord "85070.556 447175.936 0.000"  Nothing
              ,  Coord "85017.737 447228.101 0.000"  Nothing
              ,  Coord "85017.737 447228.101 70.000" Nothing
              ,  Coord "85070.556 447175.936 70.000" Nothing
              ,  Coord "85070.556 447175.936 0.000"  Nothing
              ]
            ) []
        ,
        Polygon (Feature (GML Nothing [] Nothing) Nothing)
            (LinearRing (sFeature "RandomID")
              [  Coord "85068.943 447173.419 0.000"  Nothing
              ,  Coord "85070.556 447175.936 0.000"  Nothing
              ,  Coord "85070.556 447175.936 70.000" Nothing
              ,  Coord "85068.943 447173.419 70.000" Nothing
              ,  Coord "85068.943 447173.419 0.000"  Nothing
              ]
            ) []
        ,
        Polygon (Feature (GML Nothing [] Nothing) Nothing)
            (LinearRing (sFeature "RandomID")
              [  Coord "85069.019 447173.370 0.000"  Nothing
              ,  Coord "85068.943 447173.419 0.000"  Nothing
              ,  Coord "85068.943 447173.419 70.000" Nothing
              ,  Coord "85069.019 447173.370 70.000" Nothing
              ,  Coord "85069.019 447173.370 0.000"  Nothing
              ]
            ) []
        ,
        Polygon (Feature (GML Nothing [] Nothing) Nothing)
            (LinearRing (sFeature "RandomID")
              [  Coord "85067.298 447170.684 0.000"  Nothing
              ,  Coord "85069.019 447173.370 0.000"  Nothing
              ,  Coord "85069.019 447173.370 70.000" Nothing
              ,  Coord "85067.298 447170.684 70.000" Nothing
              ,  Coord "85067.298 447170.684 0.000"  Nothing
              ]
            ) []
        ,
        Polygon (Feature (GML Nothing [] Nothing) Nothing)
            (LinearRing (sFeature "RandomID")
              [  Coord "85069.605 447169.206 0.000"  Nothing
              ,  Coord "85067.298 447170.684 0.000"  Nothing
              ,  Coord "85067.298 447170.684 70.000" Nothing
              ,  Coord "85069.605 447169.206 70.000" Nothing
              ,  Coord "85069.605 447169.206 0.000"  Nothing
              ]
            ) []
        ,
        Polygon (Feature (GML Nothing [] Nothing) Nothing)
            (LinearRing (sFeature "RandomID")
              [  Coord "85065.266 447162.431 0.000"  Nothing
              ,  Coord "85069.605 447169.206 0.000"  Nothing
              ,  Coord "85069.605 447169.206 70.000" Nothing
              ,  Coord "85065.266 447162.431 70.000" Nothing
              ,  Coord "85065.266 447162.431 0.000"  Nothing
              ]
            ) []
        ,
        Polygon (Feature (GML Nothing [] Nothing) Nothing)
            (LinearRing (sFeature "RandomID")
              [  Coord "85010.059 447216.119 0.000"  Nothing
              ,  Coord "85065.266 447162.431 0.000"  Nothing
              ,  Coord "85065.266 447162.431 70.000" Nothing
              ,  Coord "85010.059 447216.119 70.000" Nothing
              ,  Coord "85010.059 447216.119 0.000"  Nothing
              ]
            ) []
        ,
        Polygon (Feature (GML Nothing [] Nothing) Nothing)
            (LinearRing (sFeature "RandomID")
              [  Coord "85017.737 447228.101 0.000"  Nothing
              ,  Coord "85010.059 447216.119 0.000"  Nothing
              ,  Coord "85010.059 447216.119 70.000" Nothing
              ,  Coord "85017.737 447228.101 70.000" Nothing
              ,  Coord "85017.737 447228.101 0.000"  Nothing
              ]
            ) []
    ]
