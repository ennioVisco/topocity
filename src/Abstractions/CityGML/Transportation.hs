
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
import           Identifiable

instance Abstractable TransportationObject where
    absObj (TCRO r) = absObj r
    absObj (TCRA r) = absObj r
    absObj (TCSQ s) = absObj s
    absObj (TCTR t) = absObj t
    absObj (TA   a) = absObj a
    absObj (AT   a) = absObj a

instance Abstractable Track
instance Abstractable Road
instance Abstractable Railway
instance Abstractable Square

instance Abstractable TrafficArea
instance Abstractable AuxiliaryTrafficArea

instance Abstractable TransportationComplex
