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
      -- DEBUGGING
      load2,
      dump2,
      abstract2,
      store2
    ) where

import           Abstractions.Abstractable
import           Abstractions.Abstractions
import           BX.Arrows
import           CityGML.ADEs.TopoADE
import           CityGML.Parsers           (xpCityModel)
import           CityGML.Types             (CityModel)
import           Data.AbsCity
import           Data.Bigraphs
import           Data.Binary               (Binary, encodeFile)
import           Data.Text                 (Text, pack)
import           IO.Arrows
import           IO.Files
import           IO.Visualize
import           Libs.Operations
import           Text.XML.HXT.Core

-- Only needed for testing purposes when running GHCi from this file.
-- import           Libs.Operations

-- .........................:::::::: HELPERS ::::::::........................ --

load :: FilePath -> FilePath -> IOSArrow XmlTree AbsCity
load c t = (loadCity c &&& loadTopo t)
            >>> (abstractCity *** abstractTopo)

load2 :: FilePath -> FilePath -> IOSArrow XmlTree (CityModel, [TopoRelation])
load2 c t = loadCity c &&& loadTopo t

abstract2 :: IOSArrow XmlTree (CityModel, [TopoRelation]) -> IOSArrow XmlTree AbsCity
abstract2 m =  m >>> abstractCity *** abstractTopo

dump :: IOSArrow XmlTree BiGraph -> FilePath -> IO ()
dump m p =  do
                runX (m >>>  rawBigraph >>>  storeToFile p);
                return ()

toText :: (Show a) => IOSArrow a Text
toText = lifter (pack . show)

dump2 :: (Binary a) => IOSArrow XmlTree a -> FilePath -> IO ()
dump2 m p = do
                runX (m >>> arrIO (encodeFile p));
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

store2 :: IOSArrow XmlTree (CityModel, [TopoRelation]) -> FilePath -> FilePath -> IO ()
store2 m p1 p2 = do
                    runX (  m      >>>
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
abstractTopo = {-# SCC "TC_abstractTopo" #-}  arrIO (return . map absLink)

reifyTopo :: IOSArrow [AbsRelation] [TopoRelation]
reifyTopo = arrIO (return . map reiLink)

abstractCity  :: IOSArrow CityModel AbsCityTree
abstractCity  =  arrIO ({-# SCC "TC_abstractCity" #-} return . absObj)

reifyCity  :: IOSArrow AbsCityTree CityModel
reifyCity  = arrIO (return . reiObj)

-- ...........................:::::::: IO ::::::::........................... --

loadTopo   :: FilePath -> IOSArrow XmlTree [TopoRelation]
loadTopo  f = {-# SCC "TC_loadTopo" #-}  loadXML xpRelSet f >>> arrIO (\(Rels rs) -> return rs)

storeTopo  :: FilePath -> IOSArrow [TopoRelation] XmlTree
storeTopo f = arrIO (return . Rels) >>> storeXML xpRelSet f

loadCity   :: FilePath -> IOSArrow XmlTree CityModel
loadCity    =   {-# SCC "TC_loadCity" #-}  loadXML xpCityModel

storeCity  :: FilePath -> IOSArrow CityModel XmlTree
storeCity   =   storeXML xpCityModel
