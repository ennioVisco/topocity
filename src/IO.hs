module IO where

import           Data.Tree.NTree.TypeDefs
import           NTreeExtras
import           Text.XML.HXT.Core

-- .......................:::::::: XML Loader ::::::::....................... --

loadXML :: PU a -> FilePath -> IOSArrow XmlTree a
loadXML  p  =   xunpickleDocument p
                    [ withValidate no           -- don't validate source
                    , withRemoveWS yes          -- remove extra whitespaces
                    , withPreserveComment no    -- remove comments
                    ]                           -- file path passed implicitly

storeXML :: PU a -> FilePath -> IOSArrow a XmlTree
storeXML p  =    xpickleDocument p
                    [ withIndent yes            -- indent XML
                    ]                           -- file path passed implicitly

-- ........................:::::::: IO Arrows ::::::::....................... --

fstA :: IOSArrow (a, b) a
fstA = arrIO (\(a, _) -> return a)

sndA :: IOSArrow (a, b) b
sndA = arrIO (\(_, b) -> return b)

runXY :: IOSArrow XmlTree a -> IOSArrow XmlTree b -> IO ([a], [b])
runXY f g   =   let (ma, mb) = (runX *** runX) (f, g)
                    in do
                        a <- ma
                        b <- mb
                        return (a, b)

display :: (Show a, Show b) => IOSArrow XmlTree (NTree a, [b]) -> IO ()
display d = do
                place <- runX $ d >>> fstA >>> arrIO (return . printTree)
                links <- runX $ d >>> sndA >>> arrIO return
                putStr $ showString (head place) [];
                print links;
                return ()

-- ....................:::::::: DEBUGGING HELPERS ::::::::................... --

logTree :: (Show a) => FilePath -> IOSArrow (NTree a) (NTree a)
logTree p = arrIO ( \ x -> do { writeFile p (show x); return x} )
