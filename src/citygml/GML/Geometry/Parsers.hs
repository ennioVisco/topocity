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

instance XmlPickler MultiSurface where
    xpickle = xpMultiSurface

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

-- ...............:::::::: AbstractGeometricAggregate ::::::::.............. --

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
    xpElem "trianglePatches" $
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
    xpRing

xpTriangle :: PU Triangle
xpTriangle
  = xpElem "gml:Triangle" $
    xpWrap  ( Triangle
            , \ (Triangle r) -> r
            )
    xpRing

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
