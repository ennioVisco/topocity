
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
import           Data.Text                as T
import           Data.Text.IO             as I
import           Data.Text.Lazy           as L
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
                I.putStr $ T.pack $ showString (Prelude.head place) [];
                print links;
                return ()

-- | 'encode' is a wrapper for the experimental feature of translating a BiGraph
-- | into bigraphER's syntax.
encode :: IOSArrow XmlTree BiGraph -> IO ()
encode d = do
            bg <- runX $ d >>> arrIO return
            I.putStr $ encodeBG (Prelude.head bg);
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


encodeBigraph :: IOSArrow BiGraph T.Text
encodeBigraph = arrIO (\x -> return $ encodeBG x)

drawBigraphL :: IOSArrow BiGraph (L.Text, L.Text)
drawBigraphL = arrIO (\x -> return $ showBigraph $ bi2graph x)

drawBigraph :: IOSArrow BiGraph (T.Text, T.Text)
drawBigraph = drawBigraphL >>> (strictify *** strictify)

strictify :: IOSArrow L.Text T.Text
strictify = arrIO (return . L.toStrict)
