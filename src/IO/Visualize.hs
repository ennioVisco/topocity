

-- ------------------------------------------------------------

{- |
   Module     : IO.Visualize

   Maintainer : Ennio Visconti (ennio.visconti\@mail.polimi.it)
   Stability  : stable
   Portability: portable

   Some functions for dealing with visual outputs

-}

-- ------------------------------------------------------------



module IO.Visualize where

import           Data.Bigraphs
import           Data.Tree.NTree.TypeDefs
import           IO.Arrows
import           IO.BGEncoder
import           Libs.NTreeExtras
import           Text.XML.HXT.Core


display :: (Show a, Show b) => IOSArrow XmlTree (NTree a, [b]) -> IO ()
display d = do
                place <- runX $ d >>> fstA >>> arrIO (return . printTree)
                links <- runX $ d >>> sndA >>> arrIO return
                putStr $ showString (head place) [];
                print links;
                return ()

encode :: IOSArrow XmlTree BiGraph -> IO ()
encode d = do
            bg <- runX $ d >>> arrIO return
            putStr $ encodeBG (head bg);
            return ()
