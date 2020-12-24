{-# LANGUAGE BangPatterns        #-}
{-# LANGUAGE FlexibleContexts    #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TemplateHaskell     #-}
{-# LANGUAGE TypeFamilies        #-}

-- ------------------------------------------------------------

{- |
   Module     : BX.PlaceGraph

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : stable
   Portability: portable

   Module responsible for the BX on the Place Graph part of the Bigraph.

-}

-- ------------------------------------------------------------

module BX.PlaceGraph (syncTree, printPut, printGet) where

import           BX.BiGUL.KeyAlign
import           BX.Shared
import           Data.AbsCity
import           Data.Bigraphs
import           Data.List
import           Data.Maybe
import           Data.Tree.NTree.TypeDefs
import           Generics.BiGUL
import           Generics.BiGUL.Interpreter
import           Generics.BiGUL.Lib
import           Generics.BiGUL.TH
import           GHC.Generics
import           Utilities.Basics
import           Utilities.NTreeExtras
import           Policies.Default

-- Make the internal structure of AbsCityTree and PlaceGraph transformable
deriveBiGULGeneric ''NTree

-- ......................:::::: BX ::::::...................... --

syncTree :: BiGUL AbsCityTree PlaceGraph
syncTree = {-# SCC "TC_syncTree" #-} Case

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
        _sc !n !scs !vcs = foldl'
                            (add scs)
                            (foldl'
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
