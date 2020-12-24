module LinkGraph where   
import         Data.Tree.NTree.TypeDefs

-- TESTING
cgml =  (
        NTree (1, ("City","City1"))
        [
            NTree (2, ("Building", "Building2"))
            [
                NTree (5, ("Door","Door5")) [],
                NTree (6, ("Window","Window6")) []
            ],
            NTree (3, ("Building", "Building3")) [],
            NTree (4, ("Building", "Building4")) []
        ]
        , link)

link =
    [
        (1, "Touch", [(2, "Building"),(3, "Building")]),
        (2, "Touch", [(3, "Building"),(5, "Building")]),
        (3, "Touch", [(4, "Building"),(5, "Building")]),
        (4, "Touch", [(1, "Building"),(5, "Building")])
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

bg4 =   (NTree (1, "City")
        [
            NTree (3, "Building")
            [
                NTree (7, "Door") [],
                NTree (8, "Window") []
            ],
            NTree (5, "Building") []
        ], link4)

link4 =
    [
        (2, "Touch", [(3, "Building"),(5, "Building")]),
        (3, "Touch", [(1, "Building"),(5, "Building")])
    ]
