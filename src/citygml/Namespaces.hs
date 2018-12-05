module CityGML.Namespaces where


modules = [
        ("xsi"   , "http://www.w3.org/2001/XMLSchema-instance"          ),
        ("xAL"   , "urn:oasis:names:tc:ciq:xsdschema:xAL:2.0"           ),
        ("xlink" , "http://www.w3.org/1999/xlink"                       ),
        ("gml"   , "http://www.opengis.net/gml"                         ),
        ("bldg"  , "http://www.opengis.net/citygml/building/2.0"        ),
        ("wtr"   , "http://www.opengis.net/citygml/waterbody/2.0"       ),
        ("veg"   , "http://www.opengis.net/citygml/vegetation/2.0"      ),
        ("dem"   , "http://www.opengis.net/citygml/relief/2.0"          ),
        ("tran"  , "http://www.opengis.net/citygml/transportation/2.0"  ),
        ("luse"  , "http://www.opengis.net/citygml/landuse/2.0"         ),
        ("gen"   , "http://www.opengis.net/citygml/generics/2.0"        ),
        ("brg"   , "http://www.opengis.net/citygml/bridge/2.0"          ),
        ("app"   , "http://www.opengis.net/citygml/appearance/2.0"      )
        ]

customNs = [
        ("", "xmlns"       , "http://www.opengis.net/citygml/2.0"),
        ("xsi", "schemaLocation"    , "http://www.opengis.net/citygml/2.0")
        ]

modulesNs :: [(String, String)] -> [(String, String)]
modulesNs []         = []
modulesNs ((a,b):xs) = ("xmlns:" ++ a, b) : modulesNs xs

specialNs :: [(String, String, String)] -> [(String, String)]
specialNs []            = []
specialNs (("",b,c):xs) = (b,c) : specialNs xs
specialNs ((a,b,c):xs)  = (a ++ ":" ++ b, c) : specialNs xs

namespaces :: [(String, String)]
namespaces = specialNs customNs ++ modulesNs modules
