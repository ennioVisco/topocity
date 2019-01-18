{-# LANGUAGE NoMonomorphismRestriction #-}

module Lib
    ( store,
      load,
      display,
      get,
      put,
      wip
    ) where

import           Abstractions

import           BX.Arrows
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

import           IO.Arrows
import           IO.BGEncoder
import           IO.BGVisualizer
import           IO.Files
import           IO.Visualize

import           Libs.Abstractable
import           Libs.Basics
import           Libs.NTreeExtras
import           Libs.Operations

import           System.Process
import           Text.XML.HXT.Core


wip :: IO ()
wip = putStrLn "Library CLI not yet implemented."


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

bger :: IOSArrow XmlTree BiGraph -> FilePath -> IO ()
bger g p1 = do
                let f1 = outDir ++ p1
                runX (  g >>>
                        encodeBigraph >>>
                        storeGraph (f1 ++ ".big")
                     );

                {-createProcess (proc "dot"
                    ["-Tpng", f1 ++ ".dot", "-o", f1 ++ ".png" ]);
                -}
                return ()

-- ...........................:::::::: BX ::::::::........................... --

get :: IOSArrow XmlTree AbsCity -> IOSArrow XmlTree BiGraph
get s = s >>> getSync

put ::  IOSArrow XmlTree AbsCity -> IOSArrow XmlTree BiGraph
        -> IOSArrow XmlTree AbsCity
put s v = (s &&& v) >>> putSync

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

encodeBigraph :: IOSArrow BiGraph String
encodeBigraph = arrIO (\x -> return $ encodeBG x)
