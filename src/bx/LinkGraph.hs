{-# LANGUAGE FlexibleContexts    #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TemplateHaskell     #-}
{-# LANGUAGE TypeFamilies        #-}

module BX.LinkGraph (syncGraph) where

import           Data.Tree.NTree.TypeDefs
import           Generics.BiGUL
import           Generics.BiGUL.Interpreter
import           Generics.BiGUL.Lib
import           Generics.BiGUL.TH

import           GHC.Generics

import           AbsCity
import           Basics
import           Bigraphs
import           BX.BiGUL.KeyAlign
import           BX.Shared
import           Policies.Default

-- Make the internal structure of AbsTopology and LinkGraph transformable
deriveBiGULGeneric ''NTree

-- ......................:::::: BX ::::::...................... --


syncGraph :: BiGUL AbsTopology AbsHypergraph
syncGraph = sync refresh

sync :: (AbsTopology -> LinkGraph -> AbsTopology) -> BiGUL AbsTopology AbsHypergraph
sync p = Case
    -- If the topology graphs are different, update source by using policy p
    [ $(adaptive [|\(NTree (_, ls) _) (NTree (_, ls') _)
                    -> not (ls `equivLink` ls')           |])
        ==> \ s (NTree (_, vls) _) -> p s vls

    -- else, replace the data and map the algorithm to children
    , $(normal [|\(NTree (_, ls) _) (NTree (_, ls') _)
                    -> ls `equivLink` ls' |]
               [| noCond |])
        ==> $(update    [p| NTree ( (i, (t, _)) , ls) c   |]
                        [p| NTree ( (i,  t    ) , ls) c   |]
                        [d| i  = Replace; t = Replace;
                            ls = align2;  c = (align p)   |]
             )
    ]


align  :: (AbsTopology -> LinkGraph -> AbsTopology) -> BiGUL [AbsTopology] [AbsHypergraph]
align  p = keyAlign key2 key2 (sync p) dummyLink

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

-- TESTING
cgml =  (
        NTree (1, ("City","City1"))
        [
            NTree (2, ("Building", "Building2"))
            [
                NTree (5, ("Door","Door5")) [],
                NTree (6, ("Window","Window6")) []
            ],
            NTree (3, ("Building", "Building3")) [],
            NTree (4, ("Building", "Building4")) []
        ]
        , link)

link =
    [
        (1, "Touch", [(2, "Building"),(3, "Building")]),
        (2, "Touch", [(3, "Building"),(5, "Building")]),
        (3, "Touch", [(4, "Building"),(5, "Building")]),
        (4, "Touch", [(1, "Building"),(5, "Building")])
    ]

bg1 =   NTree (1, "City")
        [
            NTree (2, "Building")
            [
                NTree (5, "Door") []
            ],
            NTree (3, "Building") [],
            NTree (4, "Building") []
        ]

bg2 =   NTree (1, "City")
        [
            NTree (2, "Building")
            [
                NTree (5, "Door") [],
                NTree (6, "Window") []
            ],
            NTree (4, "Building") []
        ]

bg3 =   NTree (1, "City")
        [
            NTree (2, "Building")
            [
                NTree (5, "Door") [],
                NTree (6, "Window") []
            ],
            NTree (7, "Building") []
        ]

bg4 =   (NTree (1, "City")
        [
            NTree (3, "Building")
            [
                NTree (7, "Door") [],
                NTree (8, "Window") []
            ],
            NTree (5, "Building") []
        ], link4)

link4 =
    [
        (2, "Touch", [(3, "Building"),(5, "Building")]),
        (3, "Touch", [(1, "Building"),(5, "Building")])
    ]
