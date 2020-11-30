{-# LANGUAGE BangPatterns #-}

module Main where

import           Cli
import           Control.Arrow.ArrowNF
import           Data.AbsCity
import           Data.Bigraphs
import           Data.Version          (showVersion)
import           IO.Files              (storeXML)
import           Lib
import           Paths_topocity        (version)
import           Settings
import           System.Directory
import           System.Environment
import           Text.XML.HXT.Core     as XML

-- instance ArrowNF IOSArrow

root :: IO ()
root = do
    sysLog "Insert the filename you want to load..."
    fs <- prompt
    -- For now, we only allow GET transformations when compiled
    askGet (files fs)

demo :: (FilePath, FilePath) -> IO ()
demo fs = do
    -- load
    {-
    let c = "file:" ++ "./" ++ inDir ++ fst fs -- CityGML source
    let a = "file:" ++ "./" ++ inDir ++ snd fs -- CityGML ADE
    sysLog $ "Loading CityGML model at: " ++ c
    sysLog $ "Loading CityGML ADE model at: " ++ a
    let model = load2 c a
    sysLog "Model loaded correctly..."
    -}

    -- get
    v <- doGet fs

    -- store
    d <- getCurrentDirectory
    let o = d ++ outDir
    let o1 = o ++ "_city.gml"
    let o2 = o ++ "_topo.gml"
    p <- canonicalizePath o
    sysLog $ "Storing the result in '" ++ p ++ "'..."
    --store2 model (o ++ fst fs) (o ++ snd fs)
    dump2 v (o ++ outFile)
    sysLog "Bigraph stored correctly."
    return ()

askGet :: (FilePath, FilePath) -> IO ()
askGet fs = do
    sysLog "Do you want to print the GET transformation? (y/N)"
    p <- prompt
    !v <- doGet fs
    sysLog "GET transformation completed correctly."
    printHandler p v
    storeHandler (fst fs) v -- filename used for naming the output

doGet :: (FilePath, FilePath) -> IO (IOSArrow XmlTree BiGraph)
doGet fs = do
    s <- loadHandler fs
    let v = rnfA $ get s
    return v

loadHandler :: (FilePath, FilePath) -> IO (IOSArrow XmlTree AbsCity)
loadHandler (f1, f2) = do
    -- for some reasons, HXT doesn't accept full paths?!
    let c = "file:" ++ "./" ++ inDir ++ f1 -- CityGML source
    let a = "file:" ++ "./" ++ inDir ++ f2 -- CityGML ADE
    sysLog $ "Loading CityGML model at: " ++ c
    sysLog $ "Loading CityGML ADE model at: " ++ a
    let model = load2 c a
    sysLog "Model loaded correctly..."
    let abmodel = abstract2 model
    sysLog "Model abstracted correctly..."
    return abmodel

storeHandler :: FilePath -> IOSArrow XmlTree BiGraph -> IO ()
storeHandler c v = do
    d <- getCurrentDirectory
    let o = d ++ outDir ++ outFile
    p <- canonicalizePath o
    sysLog $ "Storing the GET result in '" ++ p ++ "'..."
    -- dump v o
    bger v p
    sysLog "Bigraph stored correctly."

printHandler :: String -> IOSArrow XmlTree BiGraph -> IO ()
printHandler "y"   v = do sysLog "Ok, I'll print it now."
                          display v
printHandler "yes" v = printHandler "y" v
printHandler _     _ = sysLog "Ok, I won't print it."

exit :: IO ()
exit = sysLog "See you the next time. Bye!"

header :: IO ()
header = do
    sysLog "Topocity - a prototype framework for BX between CityGML and CPSps"
    sysLog $ "v." ++ showVersion version ++ " (alpha)"
    putStrLn ""

main :: IO ()
main = do
          args <- getArgs
          case args of
            []     -> do
                          header
                          sysLog "User Input Mode."
                          Main.root
            [m]    -> error "Either supply two files or no one."
            [m, r] -> do
                          header
                          sysLog "Arguments Input Mode."
                          askGet (m, r)
            [m, r, "d"] -> do
                          header
                          sysLog "Demo Mode."
                          -- v <- doGet (m, r)
                          demo (m, r)
                          --storeHandler m v -- filename used for naming the output
            _      -> error "Too many arguments."
