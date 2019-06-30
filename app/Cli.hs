module Cli where

import           System.IO

getUserInput :: IO String
getUserInput = do
    putStr $ cyan ++ "Topocity> " ++ white
    x <- getLine
    putStrLn ""
    return x

prompt :: IO String
prompt = do
    putStr $ cyan ++ "Topocity> " ++ white
    hFlush stdout
    getLine


files :: String -> (FilePath, FilePath)
files fs = (head $ words fs, head $ tail $ words fs)

sysLog :: String -> IO ()
sysLog s = putStrLn $ yellow ++ s ++ white

cyan :: String
cyan = "\x1b[36m"

yellow :: String
yellow = "\x1b[33m"

white :: String
white = "\x1b[0m"
