{-# LANGUAGE NoMonomorphismRestriction #-}

-- ------------------------------------------------------------

{- |
   Module     : Lib

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : stable
   Portability: portable

   Main entry point of the library. It exposes the available interfaces.

-}

-- ------------------------------------------------------------

module Lib
    ( -- bger,        -- generates a bigraphER graph.
      display,        -- logs a bigraph in stdout.
      dump,           -- dumps the BiGraph in a file
      -- draw,        -- generates a .dot file with a bigraph.
      get,            -- performs BX get.
      load,           -- loads a model.
      store,          -- stores a model.
      -- policy,      -- sets the current policy.
      put,            -- performs BX put.

      addBuilding,    -- demo helper for adding a building
      removeBuilding, -- demo helper for removing a building
      addNear,        -- demo helper for adding a link
      removeNear,     -- demo helper for removing a link

      wip             -- placeholder function with a warning.
    ) where

import           Abstractions.Abstractable
import           Abstractions.Abstractions
import           BX.Arrows
import           CityGML.ADEs.TopoADE
import           CityGML.Parsers           (xpCityModel)
import           CityGML.Types             (CityModel)
import           Data.AbsCity
import           Data.Bigraphs
import           IO.Arrows
import           IO.Files
import           IO.Visualize
import           Libs.Operations
import           Text.XML.HXT.Core

-- Only needed for testing purposes when running GHCi from this file.
-- import           Libs.Operations

wip :: IO ()
wip = putStrLn "Library CLI not yet implemented."

-- .........................:::::::: HELPERS ::::::::........................ --

load :: FilePath -> FilePath -> IOSArrow XmlTree  AbsCity
load c t = (loadCity  c &&& loadTopo t)
            >>> (abstractCity *** abstractTopo)

dump :: IOSArrow XmlTree BiGraph -> FilePath -> IO ()
dump m p = do
                runX (m >>> encodeBigraph >>> dumpGraph p);
                return ()


store :: IOSArrow XmlTree AbsCity -> FilePath -> FilePath -> IO ()
store m p1 p2 = do
                    runX (  m      >>>
                            (reifyCity *** reifyTopo)  >>>
                            (
                                storeCity p1
                                ***
                                storeTopo p2
                            )
                         );
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
