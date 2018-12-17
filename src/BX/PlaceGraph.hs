{-# LANGUAGE FlexibleContexts    #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TemplateHaskell     #-}
{-# LANGUAGE TypeFamilies        #-}

module BX.PlaceGraph (syncTree) where

import           BX.BiGUL.KeyAlign
import           BX.Shared
import           Data.AbsCity
import           Data.Bigraphs
import           Data.Maybe
import           Data.Tree.NTree.TypeDefs
import           Generics.BiGUL
import           Generics.BiGUL.Interpreter
import           Generics.BiGUL.Lib
import           Generics.BiGUL.TH
import           GHC.Generics
import           Libs.Basics
import           Libs.NTreeExtras
import           Policies.Default

-- Make the internal structure of AbsCityTree and PlaceGraph transformable
deriveBiGULGeneric ''NTree

-- ......................:::::: BX ::::::...................... --

syncTree :: BiGUL AbsCityTree PlaceGraph
syncTree = Case

    -- if
    [ $(adaptive [|\s v -> not (equiv s v)|])
        ==> \s (NTree _ vcs) -> syncChildren s vcs

    -- else
    , $(normal [| equiv |] [| noCond |])
        ==> $(update    [p| NTree (i, (t,  _)) cs                 |]
                        [p| NTree (i, t) cs                       |]
                        [d| i = Replace; t = Replace; cs = align  |]
             )
    ]


align :: BiGUL [AbsCityTree] [PlaceGraph]
align = keyAlign tKey tKey syncTree dummyNode

syncChildren :: AbsCityTree -> [PlaceGraph] -> AbsCityTree
syncChildren n@(NTree _ cs) vcs = alignChildren (_sc n cs vcs) vcs
    where
        _sc n scs vcs = foldl
                            (add scs)
                            (foldl
                                (del vcs)
                                n
                                scs
                            )
                            vcs

alignChildren :: AbsCityTree -> [PlaceGraph] -> AbsCityTree
alignChildren (NTree d cs) vcs = NTree d (alignLists (=@=) cs vcs)

add :: [AbsCityTree] -> AbsCityTree -> PlaceGraph -> AbsCityTree
add scs p vc = if tKey vc `elem` map tKey scs
                    then p
                    else
                        addChild (commit p n) n
                        where n = create p vc

del :: [PlaceGraph] -> AbsCityTree -> AbsCityTree -> AbsCityTree
del vcs p sc = if tKey sc `elem` map tKey vcs
                       then p
                       else
                           removeChild (revert p sc) sc


-- HELPERS
printPut :: BiGUL AbsCityTree PlaceGraph -> AbsCityTree -> PlaceGraph -> IO()
printPut bx s v = displayTree $ fromJust $ put bx s v

printGet :: BiGUL AbsCityTree PlaceGraph -> AbsCityTree -> IO()
printGet bx s = displayTree $ fromJust $ get bx s

pp = printPut syncTree
gg = printGet syncTree


-- TESTING
cgml =  NTree (1, ("City","City1"))
        [
            NTree (2, ("Building", "Building2"))
            [
                NTree (5, ("Door","Door5")) [],
                NTree (6, ("Window","Window6")) []
            ],
            NTree (3, ("Building", "Building3")) [],
            NTree (4, ("Building", "Building4")) []
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

bg4 =   NTree (1, "City")
        [
            NTree (3, "Building")
            [
                NTree (7, "Door") [],
                NTree (8, "Window") []
            ],
            NTree (5, "Building") []
        ]
