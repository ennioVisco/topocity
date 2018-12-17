import           Data.Graph.Inductive.Example
import           Data.GraphViz
import           Data.GraphViz.Printing
import           Data.Text.Lazy


main = putStrLn $ unpack $ renderDot $ toDot $ graphToDot nonClusteredParams clr479
{-}
data BiNode = BiNode Int String

instance PrintDot BiNode where
  unqtDot (BiNode i s) = unqtDot i <> colon <+> unqtDot s

  -- We have a space in there, so we need quotes.
  toDot = doubleQuotes . unqtDot

instance ParseDot BiNode where
  parseUnqt = BiNode <$> parseUnqt
                     <*  character ':'
                     <*  whitespace1
                     <*> parseUnqt

  -- Has at least one space, so it will be quoted.
  parse = quotedParse parseUnqt
-}
