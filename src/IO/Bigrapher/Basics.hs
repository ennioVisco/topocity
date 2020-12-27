
-- ------------------------------------------------------------

{- |
   Module     : IO.Bigrapher.Basics

   Maintainer : Ennio Visconti (ennio.visconti\@mail.polimi.it)
   Stability  : experimental
   Portability: portable

   Experimental library for supporting bigrapher printing

-}

-- ------------------------------------------------------------

module IO.Bigrapher.Basics where
import           Data.Bigraphs
import           Data.Foldable            (foldr)
import           Data.List                (groupBy, maximumBy, sort)
import           Data.Text                (Text, pack)
import           Data.Tree.NTree.TypeDefs ()
import           Utilities.Basics         (Type)
import           Utilities.NTreeExtras    (toList)
import           Utilities.TextExtras

sanitize :: String -> String
sanitize []         = ""
sanitize "-"        = "_"
sanitize ":"        = "_"
sanitize [x]        = [x]
sanitize ('-' : xs) = '_' : sanitize xs
sanitize (':' : xs) = '_' : sanitize xs
sanitize (x : xs)   = x : sanitize xs

node :: BiGraphNode -> Text
node (i, t) = sanitize t |+| "{" <+| sanitize i

link :: BiGraphEdge -> Text
link (i, (t, _)) = sanitize i |+| "_" <+| sanitize t


-- ........................:::::::: Controls ::::::::........................ --

-- | To extract controls:
-- | 1. Extract a list of (type, #ports)
-- |    Note: the node UID is added as a port
-- | 2. Group them by type
-- | 3. Select the (type, #ports) with max. #ports
-- | 4. Print appropriately
ctrls :: AbsHypergraph -> Text
ctrls ns =  printCtrls $ mergeCtrls $ groupByType $ map toCtrl $ toList ns

toCtrl :: (BiGraphNode, [BiGraphEdge]) -> (Type, Int)
toCtrl ((_, t), es) = (t, length es + 1)

groupByType :: [(Type, Int)] -> [[(Type, Int)]]
groupByType [] = []
groupByType xs = groupBy (\(t1, _) (t2, _) -> t1 == t2) $ sort xs

maxPorts :: [(Type, Int)] -> (Type, Int)
maxPorts []  = error "Unsupported Empty List"
maxPorts [x] = x
maxPorts xs  = maximumBy (\(_, n) (_, m) -> compare n m) xs

mergeCtrls :: [[(Type, Int)]] -> [(Type, Int)]
mergeCtrls = map maxPorts

printCtrls :: [(Type, Int)] -> Text
printCtrls  = let toLine (t, n) = line
                            ("ctrl " ++ sanitize t ++ " = " ++ show n ++ ";")
              in foldr ((<+>).toLine) (pack "")

--ord :: a -> a -> Ordering 
--ord 

