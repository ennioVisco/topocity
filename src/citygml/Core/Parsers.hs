
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
import           CityGML.GML.Parsers

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
        ps =    [   xpWrap  ( Site
                            , \ (Site s) -> s
                            )
                    xpSite
                --,
                ]

xpSite :: PU Site
xpSite
  = xpAlt tag ps
      where
      tag (Bld _) = 0
      ps =    [  xpWrap  ( Bld
                          , \ (Bld b) -> b
                          )
                  xpBuilding
              --,
              ]
