
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
import           Utilities.Basics         (Type, allTheSame)
import           Utilities.NTreeExtras    (toList)
import           Utilities.TextExtras
import           Data.Char                (toLower)
import           Data.Bool                (Bool)

sanitize :: String -> String
sanitize []         = ""
sanitize "-"        = "_"
sanitize ":"        = "_"
sanitize "@"        = "_"
sanitize [x]        = [x]
sanitize ('@' : xs) = '_' : sanitize xs
sanitize ('-' : xs) = '_' : sanitize xs
sanitize (':' : xs) = '_' : sanitize xs
sanitize (x : xs)   = x : sanitize xs

lowercase :: String -> String
lowercase (x:xs) = toLower x : xs
lowercase xs = xs

cleaner :: String -> String
cleaner = lowercase.sanitize 

node :: BiGraphNode -> Text
node (i, t) = sanitize t |+| "{" <+| cleaner i

lineLnk :: BiGraphEdge -> Text
lineLnk (i, (t, _)) = cleaner i |+| "_" <+| cleaner t


-- ........................:::::::: Controls ::::::::........................ --

-- | To extract controls:
-- | 1. Extract a list of (type, #ports)
-- |    Note: the node UID is added as a port
-- | 2. Group them by type
-- | 3. Select the (type, #ports) with max. #ports
-- | 4. Print appropriately
ctrls :: [Type] -> [[(Type, Int)]] -> Text
ctrls vs ns =  printCtrls vs (mergeCtrls ns)

nsLs :: AbsHypergraph -> [[(Type, Int)]]
nsLs ns = groupByType $ map toCtrl $ toList ns 

-- | Selects the nodes from the hypernode with edges
toCtrl :: (BiGraphNode, [BiGraphEdge]) -> (Type, Int)
toCtrl ((_, t), es) = (t, length es + 1)

-- | Groups all the nodes by type, i.e. [[(t1, #p1), (t1, #p2), ...], ...] 
groupByType :: [(Type, Int)] -> [[(Type, Int)]]
groupByType [] = []
groupByType xs = groupBy (\(t1, _) (t2, _) -> t1 == t2) $ sort xs

-- | Generates a list of ctrls ids that vary in arity
varyingCtrls :: [[(Type, Int)]] -> [Type]
varyingCtrls xs = map (fst.head) $ filter (not.allTheSame) xs

isVarying :: BiGraphNode -> [Type] -> Bool
isVarying (_, t) ts = t `elem` ts

-- | Selects the instance of a type with maximum number of ports
maxPorts :: [(Type, Int)] -> (Type, Int)
maxPorts []  = error "Unsupported Empty List"
maxPorts [x] = x
maxPorts xs  = maximumBy (\(_, n) (_, m) -> compare n m) xs

-- | Selects the max. number of ports for each control
mergeCtrls :: [[(Type, Int)]] -> [(Type, Int)]
mergeCtrls = map maxPorts

-- | Printer for "ctrl x = ..."  rows
-- | It uses a list vs of [Type] to check whether the current node 
-- | has a dynamic or static number of links.  
printCtrls :: [Type] -> [(Type, Int)] -> Text
printCtrls _ [] = lineCtr True ("L", 0)    -- Hack for varying arity controls
printCtrls vs (x@(t, _):xs) 
   | t `elem` vs = lineCtr True  x <+> printCtrls vs xs 
   | otherwise   = lineCtr False x <+> printCtrls vs xs 

-- | Generates a line related to a control 
-- | the first parameter indicates
-- | True := varying-arity control
-- | False := constant-arity control
lineCtr :: Bool -> (Type, Int) -> Text
lineCtr False (t, i) = line ("ctrl " ++ sanitize t ++ " = " ++ show i ++ ";")
lineCtr True  (t, _) = line ("ctrl " ++ sanitize t ++ " = 1;")



