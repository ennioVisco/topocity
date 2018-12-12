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
    xpickle = xpGenLod1Model

xpGenLod1Model :: PU GenLod1Model
xpGenLod1Model
  = xpAlt tag ps
        where
        tag (GenLod1Geometry _) = 0
        ps = [  xpWrap  ( GenLod1Geometry
                        , \ (GenLod1Geometry s) -> s
                        ) $
                xpElem "gen:lod1Geometry" xpMultiSurface
             ]

instance XmlPickler GenericCityObject where
    xpickle = xpGenerics

xpGenerics :: PU GenericCityObject
xpGenerics =
    xpElem "gen:GenericCityObject"    $
    xpWrap  ( \ (f,l1) -> GenericCityObject f l1
            , \ g ->    ( genFeature g , genLod1Model g )
            ) $
    xpPair      xpFeature
                xpGenLod1Model
