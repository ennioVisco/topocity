{-# LANGUAGE ScopedTypeVariables #-}

-- ------------------------------------------------------------

{- |
   Module     : Abstractions.CityGML.Transportation

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : stable
   Portability: portable

   This module contains the instances of the Abstractable class
   from 'CityGML.Modules.Transportation'.

-}

-- ------------------------------------------------------------

module Abstractions.CityGML.Transportation where

import           Abstractions.Abstractable
import           CityGML.Types
import           Data.AbsCity
import           Data.Data
import           Data.Tree.NTree.TypeDefs
import           Identifiable

instance Abstractable TransportationObject where
    absObj (TCRO r) = absObj r
    absObj (TCRA r) = absObj r
    absObj (TCSQ s) = absObj s
    absObj (TCTR t) = absObj t
    absObj (TA   a) = absObj a
    absObj (AT   a) = absObj a

    reiObj d@(NTree (_, ("Road", _)) _)                 = TCRO (reiObj d)
    reiObj d@(NTree (_, ("Railway", _)) _)              = TCRA (reiObj d)
    reiObj d@(NTree (_, ("Square", _)) _)               = TCSQ (reiObj d)
    reiObj d@(NTree (_, ("Track", _)) _)                = TCTR (reiObj d)
    reiObj d@(NTree (_, ("TrafficArea", _)) _)          = TA   (reiObj d)
    reiObj d@(NTree (_, ("AuxiliaryTrafficArea", _)) _) = AT   (reiObj d)

instance Abstractable Track where
    absObj t@(Track o c) = NTree (uid o, ("Track", show t)) (fromTComplex c)

    reiObj (NTree (_, ("Track", d)) cs)
        = reshape (read d) cs
            where
                reshape (Track o tc) cs = Track o (toTComplex cs tc)

instance Abstractable Road where
    absObj t@(Road o c) = NTree (uid o, ("Road", show t)) (fromTComplex c)

    reiObj (NTree (_, ("Road", d)) cs)
        = reshape (read d) cs
            where
                reshape (Road o tc) cs = Road o (toTComplex cs tc)

instance Abstractable Railway where
    absObj t@(Railway o c) = NTree (uid o, ("Railway", show t)) (fromTComplex c)

    reiObj (NTree (_, ("Railway", d)) cs)
        = reshape (read d) cs
            where
                reshape (Railway o tc) cs = Railway o (toTComplex cs tc)

instance Abstractable Square where
    absObj t@(Square o c) = NTree (uid o, ("Square", show t)) (fromTComplex c)

    reiObj (NTree (_, ("Square", d)) cs)
        = reshape (read d) cs
            where
                reshape (Square o tc) cs = Square o (toTComplex cs tc)

instance Abstractable TrafficArea
instance Abstractable AuxiliaryTrafficArea


toTComplex :: [AbsCityTree] -> TransportationComplex -> TransportationComplex
toTComplex cs (TransportationComplex l0 l1 d _ _)
  = TransportationComplex l0 l1 d
        (filterObjects cs "TrafficArea")
        (filterObjects cs "AuxiliaryTrafficArea")

fromTComplex :: TransportationComplex -> [AbsCityTree]
fromTComplex (TransportationComplex _ _ _ t a) = map absObj t ++ map absObj a
