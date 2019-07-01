module Main where

import           Cli
import           Data.Version     (showVersion)
import           Lib
import           Paths_topocity   (version)
import           Settings
import           System.Directory

outFile = "out-get.txt"

root :: IO ()
root = do
    sysLog "Insert the filename you want to load..."
    fs <- prompt
    p1 <- canonicalizePath $ fst $ files fs
    p2 <- canonicalizePath $ snd $ files fs
    sysLog $ "'" ++ p1 ++ "' and '"
                 ++ p2 ++ "' correctly loaded."
    getHandler (files fs)

getHandler :: (FilePath, FilePath) -> IO ()
getHandler fs = do
    sysLog "Do you want to print the GET transformation? (y/N)"
    p <- prompt
    printHandler fs p
    storeHandler fs

storeHandler :: (FilePath, FilePath) -> IO ()
storeHandler (c, a) = do
    p <- canonicalizePath (outDir ++ outFile)
    sysLog $ "Storing the GET result in '" ++ p ++ "'..."
    dump (get $ load c a) (outDir ++ outFile)
    sysLog "Bigraph stored correctly."
    -- root

printHandler :: (FilePath, FilePath) -> String -> IO ()
printHandler (c, a) "y" = do
    sysLog "Ok, I'll print it now."
    display (get $ load c a)
printHandler x "yes" = printHandler x "y"
printHandler _ _ = sysLog "Ok, I won't print it."

exit :: IO ()
exit = sysLog "See you the next time. Bye!"

header :: IO ()
header = do
    sysLog "Topocity - a prototype framework for BX between CityGML and CPSps"
    sysLog $ "v." ++ showVersion version ++ " (alpha)"
    putStrLn ""

main :: IO ()
main = do
    header
    root
