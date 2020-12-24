
-- ------------------------------------------------------------

{- |
   Module     : IO.Visualize

   Maintainer : Ennio Visconti (ennio.visconti\@mail.polimi.it)
   Stability  : stable
   Portability: portable

   Some wrappers for dealing with visual outputs

-}

-- ------------------------------------------------------------

module IO.Visualize where

import           Data.Bigraphs
import           Data.Text                as T (Text, pack)
import           Data.Text.IO             as I (putStr)
import           Data.Text.Lazy           as L (Text, toStrict)
import           Data.Tree.NTree.TypeDefs
import           Utilities.Arrows
import           IO.Bigrapher.Encoder
import           IO.Bigrapher.Visualizer
import           IO.Files
import           Utilities.NTreeExtras
import           System.Process
import           Text.XML.HXT.Core

-- | WARNING: outDir should be moved to app package and managed by user input!
outDir = "/out/"

-- | 'display' simply outputs the raw Tree and List underlying a bigraph.
display :: (Show a, Show b) => IOSArrow XmlTree (NTree a, [b]) -> IO ()
display d = do
                place <- runX $ d >>> fstA >>> arrIO (return . printTree)
                links <- runX $ d >>> sndA >>> arrIO return
                I.putStr $ pack $ showString (head place) [];
                print links;
                return ()

-- | 'encode' is a wrapper for the experimental feature of translating a BiGraph
-- | into bigraphER's syntax.
encode :: Bool -> IOSArrow XmlTree BiGraph -> IO ()
encode p d = do
            bg <- runX $ d >>> arrIO return
            I.putStr $ encodeBG p (head bg);
            return ()

-- .....................:::::::: EXPERIMENTAL ::::::::...................... --

draw :: IOSArrow XmlTree BiGraph -> FilePath -> FilePath -> IO ()
draw g p1 p2 = do
                    let f1 = outDir ++ p1
                        f2 = outDir ++ p2
                    runX (  g >>>
                            drawBigraph >>>
                            (fstA >>> storeToFile (f1 ++ ".dot"))
                                &&&
                            (sndA >>> storeToFile (f2 ++ ".dot"))
                         );

                    createProcess (proc "dot"
                        ["-Tpng", f1 ++ ".dot", "-o", f1 ++ ".png" ]);
                    createProcess (proc "dot"
                        ["-Tpng", f2 ++ ".dot", "-o", f2 ++ ".png" ]);
                    return ()

bger :: Bool -> IOSArrow XmlTree BiGraph -> FilePath -> IO ()
bger p g p1 = do
                runX (  g >>>
                        encodeBigraph p >>>
                        storeToFile p1 -- ++ ".big")
                     );
                -- call BigraphER:
                {-createProcess (proc "dot"
                    ["-Tpng", f1 ++ ".dot", "-o", f1 ++ ".png" ]);
                -}
                return ()


rawBigraph :: IOSArrow BiGraph T.Text
rawBigraph = arrIO (\(x,y) -> return $ pack $ printTree x ++ sList y)
             where
               sList xs = unlines $ map show xs

encodeBigraph :: Bool -> IOSArrow BiGraph T.Text
encodeBigraph p = arrIO $ return . encodeBG p

drawBigraphL :: IOSArrow BiGraph (L.Text, L.Text)
drawBigraphL = arrIO $ return . showBigraph . bi2graph

drawBigraph :: IOSArrow BiGraph (T.Text, T.Text)
drawBigraph = drawBigraphL >>> (strictify *** strictify)

strictify :: IOSArrow L.Text T.Text
strictify = arrIO (return . toStrict)
