{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE KindSignatures       #-}
{-# LANGUAGE TypeOperators        #-}
{-# LANGUAGE TypeSynonymInstances #-}

module Abstractable where

import           AbsCity
import           Data.Tree.NTree.TypeDefs
import           GHC.Generics

-- Class for getting the constructor name as in
-- https://stackoverflow.com/questions/48179380/getting-the-data-constructor-name-as-a-string-using-ghc-generics

class HasConstructor (f :: * -> *) where
  genericConstrName :: f x -> String

instance HasConstructor f => HasConstructor (D1 c f) where
  genericConstrName (M1 x) = genericConstrName x

instance (HasConstructor x, HasConstructor y) => HasConstructor (x :+: y) where
  genericConstrName (L1 l) = genericConstrName l
  genericConstrName (R1 r) = genericConstrName r

instance Constructor c => HasConstructor (C1 c f) where
  genericConstrName = conName


constrName :: (HasConstructor (Rep a), Generic a)=> a -> String
constrName = genericConstrName . from


-- Class for transforming the HXT data structures in the abstract
-- Tree representation used for performing BX

class
    (Show o, Read o, Generic o, HasConstructor (Rep o), Identifiable o) =>
    Abstractable o
    where

    absObj :: o -> AbsCityTree
    absObj n = NTree (getId n, (constrName n, show n)) []

    reiObj :: AbsCityTree -> o
    reiObj (NTree (_, (_, d)) _) = read d

class
    (Show o, Read o, Generic o, HasConstructor (Rep o)) =>
    AbstractLink o
    where

    absLink :: o -> AbsRelation
    absLink n = ("UNKNOWN_ID", (constrName n, []))

    reiLink :: AbsRelation -> o


class Identifiable o where
    getId :: o -> String
