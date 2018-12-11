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

module CityGML.Building.Parsers where

import           CityGML.GML.Parsers
import           CityGML.Types
import           Text.XML.HXT.Core


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
                        , \ (Lod1Solid s) -> s
                        ) $
                xpElem "bldg:lod1Solid" xpSolid
             ]
