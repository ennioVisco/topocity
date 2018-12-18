{-# LANGUAGE NoMonomorphismRestriction #-}

module Lib
    ( someFunc -- stub for external access point
    ) where

import           Abstractions

import           BX.LinkGraph
import           BX.PlaceGraph
import           BX.Shared

import           CityGML.ADEs.TopoADE
import           CityGML.Parsers
import           CityGML.Types

import           Data.AbsCity
import           Data.Bigraphs
import           Data.Maybe
import           Data.Tree.NTree.TypeDefs

import           Generics.BiGUL
import           Generics.BiGUL.Interpreter
import           Generics.BiGUL.Lib
import           Generics.BiGUL.TH

import           IO.Arrows
import           IO.BGVisualizer
import           IO.Files
import           IO.Visualize

import           Libs.Abstractable
import           Libs.Basics
import           Libs.NTreeExtras
import           Libs.Operations

import           System.Process
import           Text.XML.HXT.Core


someFunc :: IO ()
someFunc = putStrLn "someFunc"


inDir = "file:../in/"
outDir = "../out/"

-- .........................:::::::: HELPERS ::::::::........................ --

load :: FilePath -> FilePath -> IOSArrow XmlTree  AbsCity
load c t = (loadCity  (inDir ++ c) &&& loadTopo (inDir ++ t))
            >>> (abstractCity *** abstractTopo)

store :: IOSArrow XmlTree AbsCity -> FilePath -> FilePath -> IO ()
store m p1 p2 = do
                    runX (  m      >>>
                            (reifyCity *** reifyTopo)  >>>
                            (
                                storeCity (outDir ++ p1)
                                ***
                                storeTopo (outDir ++ p2)
                            )
                         );
                    return ()

draw :: IOSArrow XmlTree BiGraph -> FilePath -> FilePath -> IO ()
draw g p1 p2 = do
                    let f1 = outDir ++ p1
                        f2 = outDir ++ p2
                    runX (  g >>>
                            drawBigraph >>>
                            (fstA >>> storeGraph (f1 ++ ".dot"))
                                &&&
                            (sndA >>> storeGraph (f2 ++ ".dot"))
                         );

                    createProcess (proc "dot"
                        ["-Tpng", f1 ++ ".dot", "-o", f1 ++ ".png" ]);
                    createProcess (proc "dot"
                        ["-Tpng", f2 ++ ".dot", "-o", f2 ++ ".png" ]);
                    return ()


splitter :: (Eq b) =>  IOSArrow (NTree (a, [b])) (NTree a, [b])
splitter = arrIO (return . separateCouple)

merger :: (a -> b) -> IOSArrow a b
merger f = arrIO (return . f)

-- ...........................:::::::: BX ::::::::........................... --

getSync :: IOSArrow AbsCity BiGraph
getSync = merger mergeCityTopo >>> getTopo >>> arrIO (return . separateCouple)

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
        merger mergeCityTopo
    ) -- AbsTopology
    &&&
    (
        sndA >>> merger mergeBiGraphs
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

-- ..................:::::::: ABSTRACTION HANDLERS ::::::::.................. --

abstractTopo :: IOSArrow [TopoRelation] [AbsRelation]
abstractTopo = arrIO (return . map absLink)

reifyTopo :: IOSArrow [AbsRelation] [TopoRelation]
reifyTopo = arrIO (return . map reiLink)

abstractCity  :: IOSArrow CityModel AbsCityTree
abstractCity  = arrIO (return . absObj)

reifyCity  :: IOSArrow AbsCityTree CityModel
reifyCity  = arrIO (return . reiObj)

-- ...........................:::::::: IO ::::::::........................... --

loadTopo   :: FilePath -> IOSArrow XmlTree [TopoRelation]
loadTopo  f = loadXML xpRelSet f >>> arrIO (\(Rels rs) -> return rs)

storeTopo  :: FilePath -> IOSArrow [TopoRelation] XmlTree
storeTopo f = arrIO (return . Rels) >>> storeXML xpRelSet f

loadCity   :: FilePath -> IOSArrow XmlTree CityModel
loadCity    =   loadXML xpCityModel

storeCity  :: FilePath -> IOSArrow CityModel XmlTree
storeCity   =   storeXML xpCityModel

drawBigraph :: IOSArrow BiGraph (String, String)
drawBigraph = arrIO (\x -> return $ showBigraph $ bi2graph x)
