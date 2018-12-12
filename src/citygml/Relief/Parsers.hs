-- ------------------------------------------------------------

{- |
   Module     : CityGML.Relief.Parsers

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : stable
   Portability: portable

   Parsers (i.e. 'XMLPickler's) related to the Types defined in
   'CityGML.Relief.Types'.

-}

-- ------------------------------------------------------------

module CityGML.Relief.Parsers where

import           CityGML.GML.Parsers
import           CityGML.Types
import           Text.XML.HXT.Core


instance XmlPickler ReliefFeature where
    xpickle = xpReliefFeature

instance XmlPickler ReliefComponent where
    xpickle = xpReliefComponent

instance XmlPickler Relief where
    xpickle = xpRelief

xpReliefFeature :: PU ReliefFeature
xpReliefFeature
  = xpElem   "dem:ReliefFeature" $
    xpWrap   ( uncurry3 ReliefFeature
             , \ f -> (demFFeature f, demFLod f, demComponents f)
             ) $
    xpTriple xpFeature
             xpPrim
             (xpList $ xpElem "dem:reliefComponent" xpRelief)

xpReliefComponent :: PU ReliefComponent
xpReliefComponent
  = xpElem  "dem:ReliefFeature" $
    xpWrap  ( uncurry ReliefComponent
            , \ f -> (demCFeature f, demCLod f)
            ) $
    xpPair xpFeature
            xpPrim


xpRelief :: PU Relief
xpRelief
  = xpElem "dem:ReliefComponent" $
    xpAlt tag ps
      where
      tag (TINRelief _ _)         = 0
      tag (MassPointRelief _ _)   = 1
      tag (BreaklineRelief _ _ _) = 2
      ps =  [   xpElem "dem:TINRelief" $
                xpWrap  ( uncurry TINRelief
                        , \ r -> ( demTINComponent r, demTin r )
                        ) $
                xpPair  xpReliefComponent
                        xpTriangulatedSurface

            ,   xpElem "dem:MassPointRelief" $
                xpWrap  ( uncurry MassPointRelief
                        , \ r -> ( demMPComponent r, reliefPoints r )
                        ) $
                xpPair  xpReliefComponent
                        xpMultiPoint

            ,   xpElem "dem:BreaklineRelief" $
                xpWrap  ( uncurry3 BreaklineRelief
                        , \ r -> ( demBLComponent r, demBreaklines r
                                 , ridgeOrValleyLines r )
                        ) $
                xpTriple xpReliefComponent
                         (xpOption xpMultiCurve)
                         (xpOption xpMultiCurve)
            ]
