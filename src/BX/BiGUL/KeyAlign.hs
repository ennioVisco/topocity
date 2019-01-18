
-- ------------------------------------------------------------

{- |
   Module     : BX.BiGUL.KeyAlign

   Maintainer : Ennio Visconti (ennio.visconti@mail.polimi.it)
   Stability  : stable
   Portability: portable

   Module extracted by BiGUL official examples on <https://bitbucket.org/prl_tokyo/bigul BiGUL - PRL Tokyo>

-}

-- ------------------------------------------------------------


{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TemplateHaskell  #-}
{-# LANGUAGE TypeFamilies     #-}
{-# LANGUAGE  ScopedTypeVariables  #-}

module BX.BiGUL.KeyAlign where

import           Data.Maybe
import           Generics.BiGUL
import           Generics.BiGUL.Interpreter
import           Generics.BiGUL.Lib
import           Generics.BiGUL.TH

keyAlign :: forall s v k . (Show s, Show v, Eq k)
         => (s -> k) -> (v -> k) -> BiGUL s v -> (v -> s) -> BiGUL [s] [v]
keyAlign ks kv b c = Case
  [ $(normalSV [p| [] |] [p| [] |] [p| [] |])
    ==> $(update [p| [] |] [p| [] |] [d|  |])
  , $(normal [| \(s:ss) (v:vs) -> ks s == kv v |] [p| _:_ |])
    ==> $(update [p| x:xs |] [p| x:xs |] [d| x = b; xs = keyAlign ks kv b c |])
  , $(adaptiveSV [p| _:_ |] [p| [] |])
    ==> \_ _ -> []
  , $(adaptive [| \ss (v:vs) -> kv v `elem` map ks ss |])
    ==> \ss (v:_) -> uncurry (:) (extract (kv v) ss)
  , $(adaptiveSV [p| _ |] [p| _:_ |])
    ==> \ss (v:_) -> c v : ss
  ]
  where
    extract :: k -> [s] -> (s, [s])
    extract k (x:xs) | ks x == k  = (x, xs)
                     | otherwise  = let (y, ys) = extract k xs
                                    in  (y, x:ys)
