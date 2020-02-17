
-- ------------------------------------------------------------

{- |
   Module     : Abstractions.Abstractions

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : stable
   Portability: portable

   This module is a wrapper for all the others and contains
   the instances of the Abstractable class for smaller or
   non-standard modules.

-}

-- ------------------------------------------------------------

module Abstractions.Abstractions where

import           Abstractions.Abstractable
import           CityGML.ADEs.TopoADE
import           CityGML.Types
import           Data.Tree.NTree.TypeDefs

import           Abstractions.CityGML.Core


-- | Link Abstractions
instance AbstractLink TopoRelation where
        absLink (Near i ns) = (i, ("Near", map a ns))
            where
            a (TopoBuilding i) = (i, ("", ""))

        reiLink (i, ("Near", ns)) = Near i (map r ns)
            where
            r (i, ("", _)) = TopoBuilding i
