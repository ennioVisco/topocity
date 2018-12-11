{-# LANGUAGE DeriveGeneric #-}

-- ------------------------------------------------------------

{- |
   Module     : CityGML.Types

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : stable
   Portability: portable

   Wrapper for all the types of the CityGML package

-}

-- ------------------------------------------------------------

module CityGML.Types
    (
    module Core,
    module Building,
    module Geometry
    )
where

import           CityGML.Building.Types as Building
import           CityGML.Core.Types     as Core
import           CityGML.Geometry.Types as Geometry

import           GHC.Generics
