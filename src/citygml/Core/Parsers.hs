
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

import           CityGML.Bridge.Parsers         as Bridge
import           CityGML.Building.Parsers       as Building
import           CityGML.Generics.Parsers       as Generics
import           CityGML.GML.Parsers            as GML
import           CityGML.Relief.Parsers         as Relief
import           CityGML.Transportation.Parsers as Transportation
import           CityGML.Vegetation.Parsers     as Vegetation
import           CityGML.WaterBody.Parsers      as WaterBody

import           Text.XML.HXT.Core

instance XmlPickler CityModel where
    xpickle = xpCityModel



xpCityModel :: PU CityModel
xpCityModel
    = xpElem "CityModel" $
      xpNamespaces namespaces $
      xpWrap    ( uncurry CityModel
                , \ c -> (cFeature c, cMembers c)
                ) $
      xpPair    xpFeature
                (xpList xpCityObjectMember)

-- | Extra Special Picklers

xpNamespaces :: [(String, String)] -> PU a -> PU a
xpNamespaces xs v = foldr (uncurry xpAddFixedAttr) v xs


instance XmlPickler CityObjectMember where
    xpickle = xpCityObjectMember

instance XmlPickler Site where
    xpickle = xpSite

xpCityObjectMember :: PU CityObjectMember
xpCityObjectMember
  = xpElem "cityObjectMember" $
    xpAlt tag ps
        where
        tag (Site _) = 0
        tag (Veg  _) = 1
        tag (Gen  _) = 2
        tag (Wtr  _) = 3
        tag (Tran _) = 4
        tag (Dem  _) = 5
        ps =    [   xpWrap  ( Site
                            , \ (Site s) -> s
                            )
                    xpSite

                ,   xpWrap  ( Veg
                            , \ (Veg v) -> v
                            )
                    xpVegetation

                ,   xpWrap  ( Gen
                            , \ (Gen g) -> g
                            )
                    xpGenerics

                ,   xpWrap  ( Wtr
                            , \ (Wtr w) -> w
                            )
                    xpWaterBody

                ,   xpWrap  ( Tran
                            , \ (Tran t) -> t
                            )
                    xpTransportation

                ,   xpWrap  ( Dem
                            , \ (Dem r) -> r
                            )
                    xpReliefFeature
                ]

xpSite :: PU Site
xpSite
  = xpAlt tag ps
      where
      tag (Bld _) = 0
      tag (Brg _) = 1
      ps =    [  xpWrap  ( Bld
                          , \ (Bld b) -> b
                          )
                  xpBuilding

              ,   xpWrap  ( Brg
                          , \ (Brg b) -> b
                          )
                  xpBridge
              ]
