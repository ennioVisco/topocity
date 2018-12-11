-- ------------------------------------------------------------

{- |
   Module     : Module name

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : stable
   Portability: portable

   Wrapper for all the parsers (i.e. 'XMLPickler's) of the
   CityGML package.

-}

-- ------------------------------------------------------------

module CityGML.Parsers
    (
    module Core,
    module Building,
    module GML
    )
where

import           CityGML.Building.Parsers as Building
import           CityGML.Core.Parsers     as Core
import           CityGML.GML.Parsers as GML
import           CityGML.Namespaces
import           CityGML.Types

import           Text.XML.HXT.Core


-- | Pickle a coordinates Triple
{-xpCoords :: PU (Float, Float, Float)
xpCoords = xpWrapEither (readMaybe, show) xpText
    where
      readMaybe xs@(_:_) | _csplit xs == (Right _) = Right (fst xs)
       readMaybe xs@(_:_)
          | all isDigit xs = Right . _csplit
      readMaybe ('-' : xs) = fmap (0 -) . readMaybe $ xs
      readMaybe ('+' : xs) =              readMaybe $ xs
      readMaybe        xs  = Left $ "xpCoords: reading a Triple of Coordinates from string " ++ show xs ++ " failed"


_csplit :: String -> Either (String, String, String)
_csplit s = coords (splitOn " " s)
            where
                coords [x,y,z] = Right (x,y,z)
                coords _       = Left "Invalid coordinates."
-}
