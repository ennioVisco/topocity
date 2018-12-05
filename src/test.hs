
import           AbsCity
import           BX.PlaceGraph
import           Data.Maybe
import           Data.Tree.NTree.TypeDefs
import           Generics.BiGUL.Interpreter
import           Text.XML.HXT.Core

{-}
main :: IO ()
main = do
    runX
        (
            setTraceLevel 1
            >>>
            loadCity  src
            >>>

                -- process the model
                (
                abstractCity
                >>>
                    -- testing PutGet and GetPut properties
                    checkGetPut >>> traceMsg 1 "GetPut property tested!" >>>
                    checkPutGet >>> traceMsg 1 "PutGet property tested!" >>>

                    -- testing generic change
                    returnA  -- identity function (i.e. passthrough)
                    &&&
                    ( getCity
                      >>>
                      removeBuilding "bc8a0f2b5-031b-11e6-b420-2bdcc4ab5d7f"
                    )
                    >>>
                    putCity
                    -- end of testing

                -- logTree dlog1 >>>

                >>>
                -- logTree dlog2 >>>
                reifyCity
                >>>
                storeCity  pb
                )
                &&&
                -- end of processing

            -- >>>
            storeCity  dest
        )
    return ()
-}

src = "file:../in/in.gml"
topo = "file:../in/topo.gml"
dest = "../out/out.gml"
pb = "../out/pb.gml"
dlog1 = "../out/log1.txt"
dlog2 = "../out/log2.txt"

-- .........................:::::::: TESTING ::::::::........................ --

checkGetPut :: IOSArrow AbsCityTree AbsCityTree
checkGetPut = arrIO (\ s ->
                        do
                            let y = fromJust $ put syncTree s
                                        (fromJust $ get syncTree s)
                            if s == y
                                then    return s
                            else
                                error   "GetPut check failed!"
                    )


checkPutGet :: IOSArrow AbsCityTree AbsCityTree
checkPutGet = arrIO (\ s ->
        do
            let y = fromJust $ get syncTree
                        (fromJust $ put syncTree s bg1)
            if bg1 == y
                then    return s
            else
                error   "PutGet check failed!"
            )

bg1 =
    NTree ("my 3dfied map","CityModel")
        [ NTree ("b31c54e7f-00ba-11e6-b420-2bdcc4ab5d7f","Building") []
        , NTree ("bade1427a-031b-11e6-b420-2bdcc4ab5d7f","Building") []
        , NTree ("b11239388-00ba-11e6-b420-2bdcc4ab5d7f","Building") []
        , NTree ("b11247e0d-00ba-11e6-b420-2bdcc4ab5d7f","Building") []
        , NTree ("bc88de017-031b-11e6-b420-2bdcc4ab5d7f","Building") []
        , NTree ("bc890775b-031b-11e6-b420-2bdcc4ab5d7f","Building") []
        , NTree ("bc8942121-031b-11e6-b420-2bdcc4ab5d7f","Building") []
        , NTree ("bc895ce59-031b-11e6-b420-2bdcc4ab5d7f","Building") []
        , NTree ("bc897a3bc-031b-11e6-b420-2bdcc4ab5d7f","Building") []
        ]
