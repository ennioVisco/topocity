
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
    , lifter
    , splitter
    ) where

import           Data.Tree.NTree.TypeDefs
import           Libs.NTreeExtras
import           Text.XML.HXT.Core

-- ........................:::::::: IO Arrows ::::::::....................... --

-- | Like 'fst' returns the first element of a pair but on IO state arrows.
fstA :: IOSArrow (a, b) a
fstA = arrIO (\(a, _) -> return a)

-- | Like 'snd' returns the first element of a pair but on IO state arrows.
sndA :: IOSArrow (a, b) b
sndA = arrIO (\(_, b) -> return b)

-- | Runs two different programs for an IO state arrow over a pair.
runXY :: IOSArrow XmlTree a -> IOSArrow XmlTree b -> IO ([a], [b])
runXY f g   =   let (ma, mb) = (runX *** runX) (f, g)
                    in do
                        a <- ma
                        b <- mb
                        return (a, b)

-- | Takes a tree of a pair of an element and a list and returns a pair of
-- | a tree of that element and a list
splitter :: (Eq b) =>  IOSArrow (NTree (a, [b])) (NTree a, [b])
splitter = arrIO (return . separatePair)

-- | Takes a function and lifts it to an IO state arrow
lifter :: (a -> b) -> IOSArrow a b
lifter f = arrIO (return . f)
