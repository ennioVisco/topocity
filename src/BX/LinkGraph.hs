{-# LANGUAGE FlexibleContexts    #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TemplateHaskell     #-}
{-# LANGUAGE TypeFamilies        #-}

-- ------------------------------------------------------------

{- |
   Module     : BX.LinkGraph

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : stable
   Portability: portable

   Module responsible for the BX on the Link Graph part of the Bigraph.

-}

-- ------------------------------------------------------------

module BX.LinkGraph (syncGraph,syncIO) where

import           Data.Tree.NTree.TypeDefs
import           Generics.BiGUL
import           Generics.BiGUL.Interpreter
import           Generics.BiGUL.Lib
import           Generics.BiGUL.TH

import           GHC.Generics

import           BX.BiGUL.KeyAlign
import           BX.Shared
import           Data.AbsCity
import           Data.Bigraphs
import           Libs.Basics

-- TODO: this should be replaced by a generc policy plugged in by the caller.
import           Policies.Default

-- Make the internal structure of AbsTopology and LinkGraph transformable
deriveBiGULGeneric ''NTree

-- ......................:::::: BX ::::::...................... --

--foreign import c:t syncIOcall "my_func" myFunc :: Int -> IO Double
pp :: IO (AbsTopology -> LinkGraph -> AbsTopology)
pp = return refresh

syncIO :: IO (BiGUL AbsTopology AbsHypergraph)
syncIO = pp >>= syncIOB


syncIOB :: (AbsTopology -> LinkGraph -> AbsTopology) -> IO (BiGUL AbsTopology AbsHypergraph)
syncIOB p = return (sync p)

syncGraph :: BiGUL AbsTopology AbsHypergraph
syncGraph = sync refresh

sync :: (AbsTopology -> LinkGraph -> AbsTopology) -> BiGUL AbsTopology AbsHypergraph
sync p = Case
    -- If the topology graphs are different, update source by using policy p
    [ $(adaptive [|\(NTree (_, ls) _) (NTree (_, ls') _)
                    -> not (ls `equivLink` ls')         |])
        ==> \ s (NTree (_, vls) _) -> p s vls

    -- else, replace the data and map the algorithm to children
    , $(normal [|\(NTree (_, ls) _) (NTree (_, ls') _)
                    -> ls `equivLink` ls' |]
               [| noCond |])
        ==> $(update    [p| NTree ( (i, (t, _)) , ls) c |]
                        [p| NTree ( (i,  t    ) , ls) c |]
                        [d| i  = Replace; t = Replace;
                            ls = align2;  c = (align p) |]
             )
    ]


align  :: (AbsTopology -> LinkGraph -> AbsTopology) -> BiGUL [AbsTopology] [AbsHypergraph]
align  p = keyAlign hKey hKey (sync p) dummyLink

align2 :: BiGUL [AbsRelation] [BiGraphEdge]
align2 = keyAlign key key reshape project

reshape :: BiGUL AbsRelation BiGraphEdge
reshape =   Replace `Prod` (Replace `Prod` align3)

align3 :: BiGUL [AbsCityNode] [BiGraphNode]
align3 = keyAlign key key syncNode dummyNode2

syncNode :: BiGUL AbsCityNode BiGraphNode
syncNode = $(update [p| (i, (t, _))               |]
                    [p| (i, t)                    |]
                    [d| i = Replace; t = Replace; |]
            )
