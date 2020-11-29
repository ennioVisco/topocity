{-# LANGUAGE MultiParamTypeClasses #-}

-- ------------------------------------------------------------

{- |
   Module     : Policy

   Maintainer : Ennio Visconti (ennio.visconti\@mail.polimi.it)
   Stability  : stable
   Portability: portable

   Policy interfaces. Currently only for documentation purposes,
   however at some point Policies will be instances of this class.

-}

-- ------------------------------------------------------------

module Policies.Policy where

import           Data.AbsCity
import           Data.Bigraphs
import           Libs.Basics

class Policy where

-- .......................:::::::: Place Graph ::::::::...................... --

    commit  :: AbsCityTree
            -> AbsCityTree
            -> AbsCityTree

    revert  :: AbsCityTree
            -> AbsCityTree
            -> AbsCityTree

    -- | The method used to initialize a new node
    create  :: Stubs        -- ^ The /Stubs pot/ where to get the new model
            -> AbsCityTree  -- ^ The /Source Parent Node/
            -> PlaceGraph   -- ^ The new /View Node/
            -> AbsCityTree  -- ^ The /Source Node/ generated


-- .......................:::::::: Link Graph ::::::::....................... --

    refresh :: AbsTopology
            -> LinkGraph
            -> AbsTopology
