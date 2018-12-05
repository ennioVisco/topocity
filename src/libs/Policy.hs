{-# LANGUAGE MultiParamTypeClasses #-}

module Policy where

import           AbsCity
import           Basics
import           Bigraphs

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
