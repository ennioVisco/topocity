
-- ------------------------------------------------------------

{- |
   Module     : Libs.Abstractable

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : stable
   Portability: portable

   Module responsible for abstracting 'CityGML' objects into
   generic city objects of 'AbsCity'.

-}

-- ------------------------------------------------------------


module Abstractions.Abstractable where

import           Data.AbsCity
import           Data.Data
import           Data.Text                (pack, unpack)
import           Data.Tree.NTree.TypeDefs
import           GHC.Generics
import           Identifiable
import           Utilities.Basics              (Type)
import           Utilities.NTreeExtras

class
    (Show o, Read o, Generic o, Data o, Identifiable o) =>
    Abstractable o
    where

    absObj :: o -> AbsCityTree
    absObj n = NTree (uid n, (constructorToString n, pack $ show n)) []

    reiObj :: AbsCityTree -> o
    reiObj (NTree (_, (_, d)) _) = read $ unpack d

class
    (Show o, Read o, Generic o, Data o) =>
    AbstractLink o
    where

    absLink :: o -> AbsRelation
    absLink n = ("UNKNOWN_ID", (show $ toConstr n, []))

    reiLink :: AbsRelation -> o


constructorToString :: (Show o, Data o) => o -> String
constructorToString n = show $ toConstr n

-- | 'filterObjects' gets a list of abstract objects and a String corresponding
-- to the datatype constructor and returns a list of reified objects having
-- that constructor.
filterObjects :: Abstractable a => [AbsCityTree] -> Type -> [a]
filterObjects xs t = map reiObj $ filter (checkAbsType t) xs

checkAbsType :: Type -> AbsCityTree -> Bool
checkAbsType t o = (fst . snd) (getData o) == t
