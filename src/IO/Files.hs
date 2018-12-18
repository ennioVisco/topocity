
-- ------------------------------------------------------------

{- |
   Module     : IO.Files

   Maintainer : Ennio Visconti (ennio.visconti\@mail.polimi.it)
   Stability  : stable
   Portability: portable

   Some basic functions for loading and storing files

-}

-- ------------------------------------------------------------

module IO.Files where

import           Data.Tree.NTree.TypeDefs
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


-- ....................:::::::: DEBUGGING HELPERS ::::::::................... --

logTree :: (Show a) => FilePath -> IOSArrow (NTree a) (NTree a)
logTree p = arrIO ( \ x -> do { writeFile p (show x); return x} )

storeGraph :: FilePath -> IOSArrow String String
storeGraph p = arrIO ( \ x -> do { writeFile p x; return x})
