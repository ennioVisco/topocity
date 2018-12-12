-- ------------------------------------------------------------

{- |
   Module     : CityGML.Bridge.Parsers

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : stable
   Portability: portable

   Parsers (i.e. 'XMLPickler's) related to the Types defined in
   'CityGML.Bridge.Types'.

-}

-- ------------------------------------------------------------

module CityGML.Bridge.Parsers where

import           CityGML.GML.Parsers
import           CityGML.Types
import           Text.XML.HXT.Core


instance XmlPickler BrgLod1Model where
    xpickle = xpAlt tag ps
        where
        tag (BrgLod1MultiSurf _) = 0
        ps = [  xpWrap  ( BrgLod1MultiSurf
                        , \ (BrgLod1MultiSurf s) -> s
                        ) $
                xpElem "brg:lod1MultiSurface" xpMultiSurface
             ]

instance XmlPickler AbstractBridge where
    xpickle = xpBridge

xpBridge :: PU AbstractBridge
xpBridge =
    xpElem "brg:Bridge"    $
    xpWrap  (\(f,l1) -> Bridge f l1
            , \ b ->    ( brgFeature b
                        , brgLod1Model b
                        )
            ) $
    xpPair      xpFeature
                (xpOption xpickle)
