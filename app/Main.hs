{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Lib

-- main :: IO ()
-- main = wip

import           Data.Maybe
import           Data.Text
import           Data.Version   (showVersion)
import           Paths_topocity (version)
import           Turtle

mainSubroutine :: IO ()
mainSubroutine = echo $ unsafeTextToLine $ pack $ "Topocity alpha v." ++ (showVersion version)

parseMain :: Parser (IO ())
parseMain = pure mainSubroutine

parser :: Parser (IO ())
parser = parseMain

main :: IO ()
main = do
    cmd <- options "topocity: a prototype framework for BX between CityGML and CPSps" parser
    cmd

{-}
printText :: (Maybe Int, Text) -> IO()
printText (Nothing, text)  = echo text
printText ((Just i), text) = replicateM_ i (echo text)

printArgs :: Parser (Maybe Int, Text)
printArgs = (,) <$> optional (optInt "times" 'n' "Number of times")
                <*> (argText "text" "Text to print")
-}
