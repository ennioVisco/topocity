{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE RecordWildCards  #-}

module Main where

import           Lib

-- main :: IO ()
-- main = wi


import           Control.Monad.IO.Class       (liftIO)
import           Control.Monad.State.Strict   (StateT, evalStateT, gets, modify)
import           Data.Default                 (def)
import           System.Console.StructuredCLI
import           Text.Read                    (readMaybe)

data AppState = AppState { bars :: FilePath,
                           bazs :: Int }

type StateM = StateT AppState IO

root :: CommandsT StateM ()
root = do
  basic
  foo
  loadFile
  bar

basic :: CommandsT StateM ()
basic = do
  command "top" "return to the top of the tree" top
  command "exit" "go back one level up" exit

foo :: CommandsT StateM ()
foo =
    command "foo" "pity the foo" (return NewLevel) >+ do
      basic
      bar
      baz

bar :: CommandsT StateM ()
bar = param "load" "<filePath>" parseBars setBars >+ do
        basic
        frob
            where setBars path = do
                    bars <- gets bars
                    modify $ \s -> s { bars = bars ++ path }
                    return NewLevel

baz :: CommandsT StateM ()
baz = command' "baz" "do the baz thing" checkBazs $ do
        n <- modify incBaz >> gets bazs
        liftIO . putStrLn $ "You have bazzed " ++ show n ++ " times"
        return NoAction
            where incBaz s@AppState{..} = s { bazs = bazs + 1 }
                  checkBazs = do
                    bazCount <- gets bazs
                    return $ bazCount < 3 -- after 3 bazs, disable baz command

frob :: CommandsT StateM ()
frob = command "frob" "frob this level" $ do
         n <- gets bars
         liftIO . putStrLn $ "frobbing " ++ show n ++ " bars"
         return NoAction

loadFile :: CommandsT StateM ()
loadFile = custom "loadFile" "loads a CityGML file" (parseOneOf options "relative path to the file") always $
         const (return NoAction)
           where options = ["fee", "fa", "fo", "fum"]
                 always  = return True

parseBars :: Validator StateM FilePath
parseBars = return . readMaybe

main :: IO ()
main = do
  let state0 = AppState "" 0
  evalStateT run state0
      where run = do
              result <- runCLI "topocity" settings root
              either (error.show) return result
            settings = def { getBanner = "topocity",
                             getHistory = Just ".topocity.history" }
