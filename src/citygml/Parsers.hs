module CityGML.Parsers where

import           CityGML.Namespaces
import           CityGML.Types
import           Text.XML.HXT.Core

instance XmlPickler CityModel where
    xpickle = xpCityModel

instance XmlPickler BoundedBy where
    xpickle = xpBoundedBy

instance XmlPickler CityObjectMember where
    xpickle = xpCityObjectMember

instance XmlPickler Measure where
    xpickle = xpMeasure

instance XmlPickler Lod0Model where
    xpickle = xpAlt tag ps
        where
        tag (FootPrint _) = 0
        tag (RoofEdge  _) = 1
        ps = [  xpWrap  ( FootPrint
                        , \ (FootPrint ms) -> ms
                        )
                (xpElem "bldg:lod0FootPrint" xpickle)
             ,  xpWrap  ( RoofEdge
                             , \ (RoofEdge ms) -> ms
                             )
                (xpElem "bldg:lod0RoofEdge"  xpickle)
             ]
instance XmlPickler Lod1Model where
    xpickle = xpAlt tag ps
        where
        tag (Lod1Solid _) = 0
        ps = [  xpWrap  ( Lod1Solid
                        , \ (Lod1Solid ms) -> ms
                        )
                (   xpElem "bldg:lod1Solid" $
                    xpElem "gml:Solid"      $
                    xpElem "gml:exterior"
                    xpickle
                )
             ]


instance XmlPickler MultiSurface where
    xpickle = xpMultiSurface

instance XmlPickler CompositeSurface where
    xpickle = xpCompositeSurface

instance XmlPickler SurfaceMember where
    xpickle = xpSurface

instance XmlPickler Point where
    xpickle = xpPoint

xpCityModel :: PU CityModel
xpCityModel
    = xpElem "CityModel" $
      xpNamespaces namespaces $
      xpWrap ( uncurry3 CityModel
             , \ c -> (cName c, cBoundedBy c, cMembers c)) $
      xpTriple  (xpElem "gml:name" xpText)
                xpBoundedBy
                (xpList xpickle)

xpBoundedBy :: PU BoundedBy
xpBoundedBy
  = xpElem "gml:boundedBy" $
    xpElem "gml:Envelope"  $
    xpWrap (\(d,n,l,u) -> BoundedBy d n l u
           , \ b -> ( srsDimension b, srsName b
                    , lCorner b, uCorner b )
            ) $
    xp4Tuple    (xpAttr "srsDimension"      xpPrim)
                (xpAttr "srsName"           xpText)
                (xpElem "gml:lowerCorner"   xpText)
                (xpElem "gml:upperCorner"   xpText)

xpCityObjectMember :: PU CityObjectMember
xpCityObjectMember
  = xpElem "cityObjectMember" $
    xpElem "bldg:Building"    $
    xpWrap (\(i,h,f,r,s) -> Building i h f r s
           , \ b -> ( bId b, bHeight b
                    , bLod0FootPrint b, bLod0RoofEdge b
                    , bLod1Solid b
                    )
    ) $
    xp5Tuple    (xpAttr "gml:id"              xpText)
                 xpMeasure
                (xpOption xpickle)
                (xpOption xpickle)
                (xpOption xpickle)


xpMeasure :: PU Measure
xpMeasure
  = xpElem "bldg:measuredHeight" $
    xpWrap  ( uncurry Height
            , \m -> (mUom m, mValue m)) $
    xpPair  (xpAttr "uom" xpText)
            xpPrim

xpPoint :: PU Point
xpPoint
  = xpElem "gml:pos" $
    xpWrap  ( Coord
            , \ (Coord d) -> d
            )
    xpText

xpMultiSurface :: PU MultiSurface
xpMultiSurface
  = xpElem "gml:MultiSurface" $
    xpWrap  ( Multi
            , \ (Multi ss) -> ss
            )
    (xpList xpSurface)

xpCompositeSurface :: PU CompositeSurface
xpCompositeSurface
  = xpElem "gml:CompositeSurface" $
    xpWrap  ( Comp
            , \ (Comp ss) -> ss
            )
    (xpList xpSurface)

xpSurface :: PU SurfaceMember
xpSurface
  = xpElem "gml:surfaceMember" $
    xpElem "gml:Polygon"       $
    xpElem "gml:exterior"      $
    xpElem "gml:LinearRing"    $
    xpWrap  ( Surface
            , \ (Surface pp) -> pp
            )
    (xpList xpPoint)


-- | Extra Special Picklers

xpNamespaces :: [(String, String)] -> PU a -> PU a
xpNamespaces xs v = foldr (uncurry xpAddFixedAttr) v xs


-- | Pickle a coordinates Triple
{-xpCoords :: PU (Float, Float, Float)
xpCoords = xpWrapEither (readMaybe, show) xpText
    where
      readMaybe xs@(_:_) | _csplit xs == (Right _) = Right (fst xs)
       readMaybe xs@(_:_)
          | all isDigit xs = Right . _csplit
      readMaybe ('-' : xs) = fmap (0 -) . readMaybe $ xs
      readMaybe ('+' : xs) =              readMaybe $ xs
      readMaybe        xs  = Left $ "xpCoords: reading a Triple of Coordinates from string " ++ show xs ++ " failed"


_csplit :: String -> Either (String, String, String)
_csplit s = coords (splitOn " " s)
            where
                coords [x,y,z] = Right (x,y,z)
                coords _       = Left "Invalid coordinates."
-}
