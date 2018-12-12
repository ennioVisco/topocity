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

module CityGML.Vegetation.Parsers where

import           CityGML.GML.Parsers
import           CityGML.Types
import           Text.XML.HXT.Core


instance XmlPickler VegLod1Model where
    xpickle = xpAlt tag ps
        where
        tag (VegLod1MultiSurf _) = 0
        ps = [  xpWrap  ( VegLod1MultiSurf
                        , \ (VegLod1MultiSurf s) -> s
                        ) $
                xpElem "veg:lod1MultiSurface" xpMultiSurface
             ]

instance XmlPickler VegetationObject where
    xpickle = xpVegetation

xpVegetation :: PU VegetationObject
xpVegetation =
    xpElem "veg:PlantCover"    $
    xpWrap  (\(f,l1) -> PlantCover f l1
            , \ w ->    ( vegFeature w
                        , vegLod1Model w
                        )
            ) $
    xpPair      xpFeature
                (xpOption xpickle)
