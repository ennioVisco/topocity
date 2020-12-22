# Merges the citygml files in /files, by stripping the first lines and the last one
# which usually correspond to the <CityModel> data

from storage import list_dir
import os

DIR_PATH = "../../out/vienna2/"
OUTPUT_FILE = "_merger.gml"



FILE_START_OFFSET = 2
FILE_END_OFFSET = 0

def main():
    with open(DIR_PATH + OUTPUT_FILE, "w") as m:
        m.writelines(header)

        for f in files():
            with open(DIR_PATH + f) as data:
                lines = data.readlines()
                lines.pop(0)
                #print(lines)
                lines[0] = lines[0].replace(r"<CityModel .*>", "",1)
                lines[0] = lines[0].replace(footer[0], "",1)
                m.writelines(lines)
            print("File " + f + " merged successfully.")

        m.writelines(footer)
    print("Closing file " + DIR_PATH + OUTPUT_FILE)

def cleaner():
    PATH = "../../in/vienna/"
    REGION_START_X = 98
    REGION_START_Y = 78
    REGION_END_X = 110
    REGION_END_Y = 84

    for f in files(PATH):
        x,y = coords(f)
        if ((x < REGION_START_X or x > REGION_END_X) or
            (y < REGION_START_Y or y > REGION_END_Y)):
            os.remove(PATH + f)
            print("File " + f + " removed in " + PATH)

def coords(s):
    x = int(s[0:3])
    y = int(s[3:6])
    #print("Coordinates of file " + s + " are (" + str(x) + "," + str(y) + ")")
    return (x, y)

def files(p = DIR_PATH):
    fs = list_dir(p);
    try:
        fs.remove(OUTPUT_FILE);
    except:
        print("No output file removed.")

    return fs


# Topo
"""
header = [
            "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n",
            "<topology:relations>"
         ]
"""

#Model

header = [
            '<?xml version="1.0" encoding="ISO-8859-1"?>\n',
            '<CityModel xmlns:xAL="urn:oasis:names:tc:ciq:xsdschema:xAL:2.0" xmlns:gml="http://www.opengis.net/gml" xmlns:wtr="http://www.opengis.net/citygml/waterbody/2.0" xmlns:app="http://www.opengis.net/citygml/appearance/2.0" xmlns:tex="http://www.opengis.net/citygml/texturedsurface/2.0" xmlns="http://www.opengis.net/citygml/2.0" xmlns:veg="http://www.opengis.net/citygml/vegetation/2.0" xmlns:dem="http://www.opengis.net/citygml/relief/2.0" xmlns:tran="http://www.opengis.net/citygml/transportation/2.0" xmlns:bldg="http://www.opengis.net/citygml/building/2.0" xmlns:grp="http://www.opengis.net/citygml/cityobjectgroup/2.0" xmlns:tun="http://www.opengis.net/citygml/tunnel/2.0" xmlns:frn="http://www.opengis.net/citygml/cityfurniture/2.0" xmlns:brid="http://www.opengis.net/citygml/bridge/2.0" xmlns:gen="http://www.opengis.net/citygml/generics/2.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:luse="http://www.opengis.net/citygml/landuse/2.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengis.net/citygml/waterbody/2.0 http://schemas.opengis.net/citygml/waterbody/2.0/waterBody.xsd http://www.opengis.net/citygml/appearance/2.0 http://schemas.opengis.net/citygml/appearance/2.0/appearance.xsd http://www.opengis.net/citygml/texturedsurface/2.0 http://schemas.opengis.net/citygml/texturedsurface/2.0/texturedSurface.xsd http://www.opengis.net/citygml/vegetation/2.0 http://schemas.opengis.net/citygml/vegetation/2.0/vegetation.xsd http://www.opengis.net/citygml/relief/2.0 http://schemas.opengis.net/citygml/relief/2.0/relief.xsd http://www.opengis.net/citygml/transportation/2.0 http://schemas.opengis.net/citygml/transportation/2.0/transportation.xsd http://www.opengis.net/citygml/building/2.0 http://schemas.opengis.net/citygml/building/2.0/building.xsd http://www.opengis.net/citygml/cityobjectgroup/2.0 http://schemas.opengis.net/citygml/cityobjectgroup/2.0/cityObjectGroup.xsd http://www.opengis.net/citygml/tunnel/2.0 http://schemas.opengis.net/citygml/tunnel/2.0/tunnel.xsd http://www.opengis.net/citygml/cityfurniture/2.0 http://schemas.opengis.net/citygml/cityfurniture/2.0/cityFurniture.xsd http://www.opengis.net/citygml/bridge/2.0 http://schemas.opengis.net/citygml/bridge/2.0/bridge.xsd http://www.opengis.net/citygml/generics/2.0 http://schemas.opengis.net/citygml/generics/2.0/generics.xsd http://www.opengis.net/citygml/landuse/2.0 http://schemas.opengis.net/citygml/landuse/2.0/landUse.xsd"><gml:boundedBy><gml:Envelope srsName="urn:ogc:def:crs,crs:EPSG::31256" srsDimension="3"><gml:lowerCorner>-5008.13 337986.85 79.2</gml:lowerCorner><gml:upperCorner>-4489.96 338556.49 130.92</gml:upperCorner></gml:Envelope></gml:boundedBy>'
]


# Topo
"""
footer = [ "</topology:relations>" ]
"""

# Model

footer = [ "</CityModel>" ]


if __name__ == '__main__':
    main()
    # Use this for restricting to a smaller area
    #cleaner()
