
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
import           Data.Tree.NTree.TypeDefs
import           IO.Arrows
import           IO.BGEncoder
import           IO.BGVisualizer
import           IO.Files
import           Libs.NTreeExtras
import           System.Process
import           Text.XML.HXT.Core

-- | WARNING: outDir should be moved to app package and managed by user input!
outDir = "/out/"

-- | 'display' simply outputs the raw Tree and List underlying a bigraph.
display :: (Show a, Show b) => IOSArrow XmlTree (NTree a, [b]) -> IO ()
display d = do
                place <- runX $ d >>> fstA >>> arrIO (return . printTree)
                links <- runX $ d >>> sndA >>> arrIO return
                putStr $ showString (head place) [];
                print links;
                return ()

-- | 'encode' is a wrapper for the experimental feature of translating a BiGraph
-- | into bigraphER's syntax.
encode :: IOSArrow XmlTree BiGraph -> IO ()
encode d = do
            bg <- runX $ d >>> arrIO return
            putStr $ encodeBG (head bg);
            return ()

-- .....................:::::::: EXPERIMENTAL ::::::::...................... --

draw :: IOSArrow XmlTree BiGraph -> FilePath -> FilePath -> IO ()
draw g p1 p2 = do
                    let f1 = outDir ++ p1
                        f2 = outDir ++ p2
                    runX (  g >>>
                            drawBigraph >>>
                            (fstA >>> dumpGraph (f1 ++ ".dot"))
                                &&&
                            (sndA >>> dumpGraph (f2 ++ ".dot"))
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
                        dumpGraph (f1 ++ ".big")
                     );

                -- call BigraphER:
                {-createProcess (proc "dot"
                    ["-Tpng", f1 ++ ".dot", "-o", f1 ++ ".png" ]);
                -}
                return ()


encodeBigraph :: IOSArrow BiGraph String
encodeBigraph = arrIO (\x -> return $ encodeBG x)

drawBigraph :: IOSArrow BiGraph (String, String)
drawBigraph = arrIO (\x -> return $ showBigraph $ bi2graph x)
