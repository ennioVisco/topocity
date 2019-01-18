
-- ------------------------------------------------------------

{- |
   Module     : IO.Arrows

   Maintainer : Ennio Visconti (ennio.visconti\@mail.polimi.it)
   Stability  : stable
   Portability: portable

   Some useful arrows for combining IO-based computations

-}

-- ------------------------------------------------------------

module IO.Arrows
    ( fstA
    , sndA
    , runXY
    , merger
    , splitter
    ) where

import           Data.Tree.NTree.TypeDefs
import           Libs.NTreeExtras
import           Text.XML.HXT.Core

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

splitter :: (Eq b) =>  IOSArrow (NTree (a, [b])) (NTree a, [b])
splitter = arrIO (return . separateCouple)

merger :: (a -> b) -> IOSArrow a b
merger f = arrIO (return . f)
