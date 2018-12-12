-- ------------------------------------------------------------

{- |
   Module     : CityGML.Building.Parsers

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : stable
   Portability: portable

   Parsers (i.e. 'XMLPickler's) related to the Types defined in
   'CityGML.Building.Types'.

-}

-- ------------------------------------------------------------

module CityGML.Transportation.Parsers where

import           CityGML.GML.Parsers
import           CityGML.Types
import           Text.XML.HXT.Core


instance XmlPickler TransLod1Model where
    xpickle = xpAlt tag ps
        where
        tag (TransLod1MultiSurf _) = 0
        ps = [  xpWrap  ( TransLod1MultiSurf
                        , \ (TransLod1MultiSurf s) -> s
                        ) $
                xpElem "tran:lod1MultiSurface" xpMultiSurface
             ]

instance XmlPickler TransportationObject where
    xpickle = xpTransportation

xpTransportation :: PU TransportationObject
xpTransportation =
    xpElem "tran:Road"    $
    xpWrap  (\(f,l1) -> Road f l1
            , \ w ->    ( transFeature w
                        , transLod1Model w
                        )
            ) $
    xpPair      xpFeature
                (xpOption xpickle)
