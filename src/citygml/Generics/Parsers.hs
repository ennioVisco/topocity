-- ------------------------------------------------------------

{- |
   Module     : CityGML.Generics.Parsers

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : stable
   Portability: portable

   Parsers (i.e. 'XMLPickler's) related to the Types defined in
   'CityGML.Generics.Types'.

-}

-- ------------------------------------------------------------

module CityGML.Generics.Parsers where

import           CityGML.GML.Parsers
import           CityGML.Types
import           Text.XML.HXT.Core


instance XmlPickler GenLod1Model where
    xpickle = xpAlt tag ps
        where
        tag (GenLod1Geometry _) = 0
        ps = [  xpWrap  ( GenLod1Geometry
                        , \ (GenLod1Geometry s) -> s
                        ) $
                xpElem "gen:lod1Geometry" xpGeometry
             ]

instance XmlPickler GenericCityObject where
    xpickle = xpGenerics

xpGenerics :: PU GenericCityObject
xpGenerics =
    xpElem "gen:GenericCityObject"    $
    xpWrap  (\(f,l1) -> GenericCityObject f l1
            , \ w ->    ( genFeature w
                        , genLod1Model w
                        )
            ) $
    xpPair      xpFeature
                (xpOption xpickle)
