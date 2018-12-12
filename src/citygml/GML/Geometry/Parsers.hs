-- ------------------------------------------------------------

{- |
   Module     : CityGML.GML.Geometry.Parsers

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : stable
   Portability: portable

   Parsers related to 'CityGML.GML.Geometry.Types'

-}

-- ------------------------------------------------------------

module CityGML.GML.Geometry.Parsers where

import           CityGML.GML.Types
import           Text.XML.HXT.Core

-- ........................:::::::: _Geometry ::::::::...................... --
instance XmlPickler Geometry where
    xpickle = xpGeometry

-- .....................:::::::: GeometricComplex ::::::::.................. --
instance XmlPickler GeometricComplex where
    xpickle = xpGeometricComplex

-- ....................:::::::: GeometricAggregate ::::::::................. --
instance XmlPickler GeometricAggregate where
    xpickle = xpGeometricAggregate

instance XmlPickler MultiGeometry where
    xpickle = xpMultiGeometry

instance XmlPickler MultiSolid where
    xpickle = xpMultiSolid

instance XmlPickler MultiSurface where
    xpickle = xpMultiSurface

instance XmlPickler MultiCurve where
    xpickle = xpMultiCurve

instance XmlPickler MultiPoint where
    xpickle = xpMultiPoint

-- ....................:::::::: GeometricPrimitive ::::::::................. --
instance XmlPickler GeometricPrimitive where
    xpickle = xpGeometricPrimitive

instance XmlPickler Curve where
    xpickle = xpCurve

instance XmlPickler Solid where
    xpickle = xpSolid

instance XmlPickler Surface where
    xpickle = xpSurface

instance XmlPickler TriangulatedSurface where
    xpickle = xpTriangulatedSurface

instance XmlPickler SurfacePatch where
    xpickle = xpPatch

instance XmlPickler Rectangle where
    xpickle = xpRectangle

instance XmlPickler Triangle where
    xpickle = xpTriangle

instance XmlPickler Ring where
    xpickle = xpRing

instance XmlPickler Point where
    xpickle = xpPoint

-- ........................:::::::: _Geometry ::::::::...................... --

xpGeometry :: PU Geometry
xpGeometry =
    xpAlt tag ps
        where
        tag (GC _) = 0
        tag (GP _) = 1
        tag (GA _) = 2
        ps  =   [   xpWrap  ( GC
                            , \ (GC g) -> g
                            )
                    xpGeometricComplex
                ,   xpWrap  ( GP
                            , \ (GP g) -> g
                            )
                    xpGeometricPrimitive
                ,   xpWrap  ( GA
                            , \ (GA g) -> g
                            )
                    xpGeometricAggregate
            ]

-- .....................:::::::: GeometricComplex ::::::::.................. --

xpGeometricComplex :: PU GeometricComplex
xpGeometricComplex
  = xpWrap  ( GeometricComplex
            , \ (GeometricComplex gs) -> gs
            )
    (xpList $ xpElem "element" xpGeometricPrimitive)

-- ....................:::::::: GeometricAggregate ::::::::................. --

xpGeometricAggregate :: PU GeometricAggregate
xpGeometricAggregate =
    xpAlt tag ps
        where
        tag (MGE _) = 0
        tag (MSO _) = 1
        tag (MSU _) = 2
        tag (MCU _) = 3
        tag (MPO _) = 4
        ps  =   [   xpWrap  ( MGE
                            , \ (MGE g) -> g
                            )
                    xpMultiGeometry
                ,   xpWrap  ( MSO
                            , \ (MSO g) -> g
                            )
                    xpMultiSolid
                ,   xpWrap  ( MSU
                            , \ (MSU g) -> g
                            )
                    xpMultiSurface
                ,   xpWrap  ( MCU
                            , \ (MCU g) -> g
                            )
                    xpMultiCurve
                ,   xpWrap  ( MPO
                            , \ (MPO g) -> g
                            )
                    xpMultiPoint
            ]

-- ...............:::::::: AbstractGeometricAggregate ::::::::.............. --

xpMultiGeometry :: PU MultiGeometry
xpMultiGeometry
  = xpElem "gml:MultiGeometry" $
    xpWrap  ( MultiGeometry
            , \ (MultiGeometry ss) -> ss
            )
    (xpList $ xpElem "gml:geometryMember" xpGeometry)

xpMultiSolid :: PU MultiSolid
xpMultiSolid
  = xpElem "gml:MultiSolid" $
    xpWrap  ( MultiSolid
            , \ (MultiSolid ss) -> ss
            )
    (xpList $ xpElem "gml:solidMember" xpSolid)

xpMultiSurface :: PU MultiSurface
xpMultiSurface
  = xpElem "gml:MultiSurface" $
    xpWrap  ( MultiSurface
            , \ (MultiSurface ss) -> ss
            )
    (xpList $ xpElem "gml:surfaceMember" xpSurface)

xpMultiCurve :: PU MultiCurve
xpMultiCurve
  = xpElem "gml:MultiCurve" $
    xpWrap  ( MultiCurve
            , \ (MultiCurve cs) -> cs
            )
    (xpList $ xpElem "gml:curveMember" xpCurve)

xpMultiPoint :: PU MultiPoint
xpMultiPoint
  = xpElem "gml:MultiPoint" $
    xpWrap  ( MultiPoint
            , \ (MultiPoint ps) -> ps
            )
    (xpList $ xpElem "gml:pointMember" xpPoint)

-- ...................:::::::: GeometricPrimitive ::::::::.................. --

xpGeometricPrimitive :: PU GeometricPrimitive
xpGeometricPrimitive =
    xpAlt tag ps
        where
        tag (SO _) = 0
        tag (SU _) = 1
        tag (CU _) = 2
        tag (PO _) = 3
        ps  =   [   xpWrap  ( SO
                            , \ (SO g) -> g
                            )
                    xpSolid
                ,   xpWrap  ( SU
                            , \ (SU g) -> g
                            )
                    xpSurface
                ,   xpWrap  ( CU
                            , \ (CU g) -> g
                            )
                    xpCurve
                ,   xpWrap  ( PO
                            , \ (PO g) -> g
                            )
                    xpPoint
            ]

-- .........................:::::::: _Solid ::::::::........................ --

xpSolid :: PU Solid
xpSolid
  = xpAlt tag ps
        where
        tag (Solid _ _)        = 0
        tag (CompositeSolid _) = 1
        ps  = [ xpElem "gml:Solid" $
                xpWrap  ( uncurry Solid
                        , \ s -> (sdExterior s, sdInterior s)
                        ) $
                xpPair  (xpElem "gml:exterior" xpSurface)
                        (xpList $ xpElem "gml:interior" xpSurface)

              , xpElem "gml:CompositeSolid" $
                xpWrap  ( CompositeSolid
                        , \ (CompositeSolid ss) -> ss
                        )
                (xpList $ xpElem "gml:solidMember" xpSolid)
              ]

-- ........................:::::::: _Surface ::::::::....................... --

xpTriangulatedSurface :: PU TriangulatedSurface
xpTriangulatedSurface
  = xpElem "gml:TriangulatedSurface" $
    xpElem "gml:trianglePatches" $
    xpWrap  ( Patches
            , \ (Patches pp) -> pp
            )
    (xpList xpTriangle)


xpSurface :: PU Surface
xpSurface
  = xpAlt tag ps
        where
        tag (Polygon _ _)           = 0
        tag (CompositeSurface _)    = 1
        tag (Surface _)             = 2
        tag (OrientableSurface _ _) = 3
        ps  = [ xpPolygon
              , xpCompositeSurface
              , xpSingleSurface
              , xpOrientableSurface
              ]

xpPolygon :: PU Surface
xpPolygon
  = xpElem "gml:Polygon" $
    xpWrap  ( uncurry Polygon
            , \ p -> (scExterior p, scInterior p)) $
    xpPair  (xpElem "gml:exterior" xpRing)
            (xpList $ xpElem "gml:interior" xpRing)

xpCompositeSurface :: PU Surface
xpCompositeSurface
  = xpElem "gml:CompositeSurface" $
    xpWrap  ( CompositeSurface
            , \ (CompositeSurface ss) -> ss
            )
    (xpList $ xpElem "gml:surfaceMember" xpSurface)

xpSingleSurface :: PU Surface
xpSingleSurface
  = xpElem "gml:Surface" $
    xpWrap  ( Surface
            , \ (Surface pp) -> pp
            )
    (xpList xpPatch)

xpOrientableSurface :: PU Surface
xpOrientableSurface
  = xpElem "gml:OrientableSurface" $
    xpWrap  ( uncurry OrientableSurface
            , \ s -> (sOrientation s, baseSurface s)) $
    xpPair  (xpAttr "orientation" xpText)
            xpSurface

xpPatch :: PU SurfacePatch
xpPatch
  = xpAlt tag ps
        where
        tag (T _) = 0
        tag (R _) = 1
        ps = [  xpWrap  ( T , \ (T f) -> f) xpTriangle
             ,  xpWrap  ( R , \ (R f) -> f) xpRectangle
             ]


xpRectangle :: PU Rectangle
xpRectangle
  = xpElem "gml:Rectangle" $
    xpWrap  ( Rectangle
            , \ (Rectangle r) -> r
            )
    (xpElem "gml:exterior" xpRing)

xpTriangle :: PU Triangle
xpTriangle
  = xpElem "gml:Triangle" $
    xpWrap  ( Triangle
            , \ (Triangle r) -> r
            )
    (xpElem "gml:exterior" xpRing)

xpRing :: PU Ring
xpRing
    = xpElem "gml:LinearRing"    $
      xpWrap  ( LinearRing
              , \ (LinearRing pp) -> pp
              )
      (xpList xpPoint)

-- .........................:::::::: _Curve ::::::::........................ --

xpCurve :: PU Curve
xpCurve
  = xpAlt tag ps
        where
        tag (LineString _)     = 0
        tag (CompositeCurve _) = 1
        ps  = [ xpElem "gml:LineString" $
                xpWrap  ( LineString
                        , \ (LineString ps) -> ps
                        )
                (xpList xpPoint)
             ,  xpElem "gml:CompositeCurve" $
                xpWrap  ( CompositeCurve
                        , \ (CompositeCurve cs) -> cs
                        )
                (xpList $ xpElem "gml:curveMember" xpCurve)
             ]

-- ..........................:::::::: Point ::::::::........................ --

xpPoint :: PU Point
xpPoint
  = xpElem "gml:pos" $
    xpWrap  ( Coord
            , \ (Coord d) -> d
            )
    xpText
