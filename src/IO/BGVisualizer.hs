
import           Data.GraphViz
import           Data.GraphViz.Parsing
import           Data.GraphViz.Printing
-- import           Data.Text.Lazy
import           Data.Tree.NTree.TypeDefs

import           Data.Graph

import           Data.Bigraphs
import           Data.Text.Lazy           (unpack)
import           Libs.NTreeExtras

data BiNode = BiNode String String
    deriving (Show, Eq)

instance PrintDot BiNode where
    unqtDot (BiNode i t) = unqtDot i <> colon <+> unqtDot t

    -- We have a space in there, so we need quotes.
    toDot = doubleQuotes . unqtDot

instance ParseDot BiNode where
    parseUnqt = BiNode  <$> parseUnqt
                        <*  character ':'
                        <*  whitespace1
                        <*> parseUnqt
    -- Has at least one space, so it will be quoted.
    parse = quotedParse parseUnqt

doubleQuotes p = char '"' <> p <> char '"'



convertNode :: BiGraphNode -> BiNode
convertNode (i, t) = BiNode i t

convertTree :: NTree BiGraphNode -> NTree BiNode
convertTree (NTree (i, t) cs) = NTree (BiNode i t) (fmap convertTree cs)

tree2Graph :: NTree BiNode -> Graph
tree2Graph t@(NTree n cs) = fst $ graphFromEdges' (nlist t)
    where
    nlist t@(NTree d []) =  [(d, key d, [])]
    nlist t@(NTree d cs) =  (d, key d, map (getData . fmap key) cs)
                            : concatMap nlist cs


key :: BiNode -> String
key (BiNode i _) = i
