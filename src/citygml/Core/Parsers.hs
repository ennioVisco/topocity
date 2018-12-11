
-- ------------------------------------------------------------

{- |
   Module     : CityGML.Core.Parsers

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : stable
   Portability: portable

   Parsers (i.e. 'XMLPickler's) related to the Types defined in
   'CityGML.Core.Types'.

-}

-- ------------------------------------------------------------

module CityGML.Core.Parsers where

import           CityGML.Core.Types
import           CityGML.Namespaces
import           Text.XML.HXT.Core

import           CityGML.Building.Parsers
import           CityGML.Building.Types

instance XmlPickler CityModel where
    xpickle = xpCityModel

instance XmlPickler BoundedBy where
    xpickle = xpBoundedBy

instance XmlPickler Measure where
    xpickle = xpMeasure

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


xpMeasure :: PU Measure
xpMeasure
  = xpElem "bldg:measuredHeight" $
    xpWrap  ( uncurry Height
            , \m -> (mUom m, mValue m)) $
    xpPair  (xpAttr "uom" xpText)
            xpPrim

-- | Extra Special Picklers

xpNamespaces :: [(String, String)] -> PU a -> PU a
xpNamespaces xs v = foldr (uncurry xpAddFixedAttr) v xs


instance XmlPickler CityObjectMember where
    xpickle = xpCityObjectMember

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
