
-- ------------------------------------------------------------

{- |
   Module     : BX.Arrows

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : stable
   Portability: portable

   Lifters for transforming bx operators in IO arrows.

-}

-- ------------------------------------------------------------

module BX.Arrows where

import           BX.LinkGraph
import           BX.PlaceGraph
import           Data.AbsCity
import           Data.Bigraphs
import           Data.Maybe
import           IO.Arrows
import           Libs.NTreeExtras
import           Text.XML.HXT.Core


import           Generics.BiGUL
import           Generics.BiGUL.Interpreter
import           Generics.BiGUL.Lib
import           Generics.BiGUL.TH

-- ...........................:::::::: BX ::::::::........................... --

getSync :: IOSArrow AbsCity BiGraph
getSync = lifter mergeCityTopo >>> getTopo >>> arrIO (return . separatePair)

putSync :: IOSArrow (AbsCity, BiGraph) AbsCity
putSync =
    (
        (
            ((fstA >>> fstA) &&& (sndA >>> fstA)) -- (AbsCityTree, PlaceGraph)
            >>>
            putCity
        )
        &&&
        (
            fstA >>> sndA
        )
        >>>
        -- (AbsCityTree, [AbsEdge])
        lifter mergeCityTopo
    ) -- AbsTopology
    &&&
    (
        sndA >>> lifter mergeBiGraphs
    )
    >>>
    putTopo
    >>>
    splitter

getTopo :: IOSArrow AbsTopology AbsHypergraph
getTopo = arrIO (return . fromJust . get syncGraph)

putTopo :: IOSArrow (AbsTopology, AbsHypergraph) AbsTopology
putTopo = arrIO (\ (s, v) -> return $ fromJust $ put syncGraph s v)

getCity :: IOSArrow AbsCityTree PlaceGraph
getCity = arrIO (return . fromJust . get syncTree)

putCity :: IOSArrow (AbsCityTree, PlaceGraph) AbsCityTree
putCity = arrIO (\ (s, v) -> return $ fromJust $ put syncTree s v)
