module Libs.Operations where

import           BX.Shared
import           Data.Bigraphs
import           Data.Tree.NTree.TypeDefs
import           IO.Arrows
import           Libs.Basics
import           Libs.NTreeExtras
import           Text.XML.HXT.Core

-- ........................:::::::: MODIFIERS ::::::::....................... --

addBuilding :: UID -> IOSArrow XmlTree BiGraph -> IOSArrow XmlTree BiGraph
addBuilding i b =   b >>>
                        (fstA >>>
                            arrIO (\t -> return $ addChild t n)
                        ) &&& sndA
                where
                    n = NTree (i, "Building") []

removeBuilding :: UID -> IOSArrow XmlTree BiGraph -> IOSArrow XmlTree BiGraph
removeBuilding i b =    b >>>
                            ( fstA >>>
                                arrIO (\t -> return $ removeChild t n)
                            ) &&& sndA
                        where
                            n = NTree (i, "Building") []

addNear :: (UID, UID, UID) -> IOSArrow [BiGraphEdge] [BiGraphEdge]
addNear (x, y, z) = arrIO (\rs -> return $ r:rs)
                    where r = (x, ("Near", [(y, "Building"),(z, "Building")]))

removeNear :: UID -> IOSArrow [BiGraphEdge] [BiGraphEdge]
removeNear i =  arrIO (return . filter f)
                where f r = i /= key r
