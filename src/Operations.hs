module Operations where

import           Basics
import           Bigraphs
import           BX.Shared
import           Data.Tree.NTree.TypeDefs
import           IO
import           NTreeExtras
import           Text.XML.HXT.Core

-- ........................:::::::: MODIFIERS ::::::::....................... --

addBuilding :: UID -> IOSArrow BiGraph BiGraph
addBuilding i = (fstA >>>
                    arrIO (\t -> return $ addChild t n)
                ) &&& sndA
                where
                    n = NTree (i, "Building") []

removeBuilding :: UID -> IOSArrow BiGraph BiGraph
removeBuilding i =  (fstA >>>
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
