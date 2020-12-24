
-- ------------------------------------------------------------

{- |
   Module     : Utilities.TextExtras

   Maintainer : Ennio Visconti (ennio.visconti\@mail.polimi.it)
   Stability  : stable
   Portability: portable

   helpers for Text printing

-}

-- ------------------------------------------------------------

module Utilities.TextExtras where

import           Data.Text                (Text, append, pack)


(|+|) :: String -> String -> Text
(|+|) x y = pack x `append` pack y

(|+>) :: String -> Text -> Text
(|+>) x y = pack x `append` y

(<+|) :: Text -> String -> Text
(<+|) x y = x `append` pack y

(<+>) :: Text -> Text -> Text
(<+>) x y = x `append` y

line :: String -> Text 
line s = pack $ s ++ "\n"

tab :: Int -> Text 
tab 0 = pack "\t"
tab n = pack "\t" <+> tab (n - 1)

-- | String concatenation by comma ( , ).
concomma :: Text -> Text -> Text
concomma x y = x <+| "," <+> y

-- | String concatenation by bar ( | ).
conbar ::  Text -> Text -> Text
conbar x y = x <+| " | " <+> y