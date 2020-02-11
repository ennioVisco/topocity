
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

import           Data.Text
import           Data.Text.IO             as T
import           Data.Tree.NTree.TypeDefs
import           Text.XML.HXT.Core
import           Text.XML.HXT.Expat

-- .......................:::::::: XML Loader ::::::::....................... --

loadXML :: PU a -> FilePath -> IOSArrow XmlTree a
loadXML  p  =   xunpickleDocument p
                    [ withValidate no           -- don't validate source
                    , withExpat yes
--                    , withTrace 1               -- debug mode
                    , withRemoveWS yes          -- remove extra whitespaces
                    , withPreserveComment no    -- remove comments
                    ]                           -- file path passed implicitly

storeXML :: PU a -> FilePath -> IOSArrow a XmlTree
storeXML p  =    xpickleDocument p
                    [ withIndent yes            -- indent XML
                    ]                           -- file path passed implicitly


-- ....................:::::::: DEBUGGING HELPERS ::::::::................... --

-- | pass-through arrow that stores a Tree
dumpTree :: (Show a) => FilePath -> IOSArrow (NTree a) (NTree a)
dumpTree p = arrIO ( \ x -> do { Prelude.writeFile p (show x); return x} )

-- | pass-through arrow that stores a BiGraph
dumpGraph :: FilePath -> IOSArrow Text Text
dumpGraph p = arrIO ( \ x -> do { T.writeFile p x; return x})
