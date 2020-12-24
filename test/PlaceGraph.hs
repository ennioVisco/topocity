module PlaceGraph where
import         Data.Tree.NTree.TypeDefs
import BX.PlaceGraph (printPut, printGet, syncTree)

    
pp = printPut syncTree
gg = printGet syncTree


-- TESTING
cgml :: NTree (Integer, ([Char], [Char]))
cgml =  NTree (1, ("City","City1"))
        [
            NTree (2, ("Building", "Building2"))
            [
                NTree (5, ("Door","Door5")) [],
                NTree (6, ("Window","Window6")) []
            ],
            NTree (3, ("Building", "Building3")) [],
            NTree (4, ("Building", "Building4")) []
        ]

bg1 =   NTree (1, "City")
        [
            NTree (2, "Building")
            [
                NTree (5, "Door") []
            ],
            NTree (3, "Building") [],
            NTree (4, "Building") []
        ]

bg2 =   NTree (1, "City")
        [
            NTree (2, "Building")
            [
                NTree (5, "Door") [],
                NTree (6, "Window") []
            ],
            NTree (4, "Building") []
        ]

bg3 =   NTree (1, "City")
        [
            NTree (2, "Building")
            [
                NTree (5, "Door") [],
                NTree (6, "Window") []
            ],
            NTree (7, "Building") []
        ]

bg4 =   NTree (1, "City")
        [
            NTree (3, "Building")
            [
                NTree (7, "Door") [],
                NTree (8, "Window") []
            ],
            NTree (5, "Building") []
        ]
