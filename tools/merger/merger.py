# Merges the citygml files in /files, by stripping the first lines and the last one
# which usually correspond to the <CityModel> data

from storage import list_dir

DIR_PATH = "../../out/vienna/"
OUTPUT_FILE = "_merger.gml"



FILE_START_OFFSET = 2
FILE_END_OFFSET = -1

def main():
    with open(DIR_PATH + OUTPUT_FILE, "w") as m:
        m.writelines(header)

        for f in files():
            with open(DIR_PATH + f) as data:
                lines = data.readlines()
                m.writelines(lines[FILE_START_OFFSET: FILE_END_OFFSET])
            print("File " + f + " merged successfully.")

        m.writelines(footer)
    print("Closing file " + DIR_PATH + OUTPUT_FILE)



def files():
    fs = list_dir(DIR_PATH);
    fs.remove(OUTPUT_FILE);

    return fs



header = [
            "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n",
            "<topology:relations>\n",
#            "<core:CityModel xmlns:smil20=\"http://www.w3.org/2001/SMIL20/\" xmlns:grp=\"http://www.opengis.net/citygml/cityobjectgroup/1.0\" xmlns:smil20lang=\"http://www.w3.org/2001/SMIL20/Language\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" xmlns:base=\"http://www.citygml.org/citygml/profiles/base/1.0\" xmlns:luse=\"http://www.opengis.net/citygml/landuse/1.0\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:frn=\"http://www.opengis.net/citygml/cityfurniture/1.0\" xmlns:dem=\"http://www.opengis.net/citygml/relief/1.0\" xmlns:tran=\"http://www.opengis.net/citygml/transportation/1.0\" xmlns:wtr=\"http://www.opengis.net/citygml/waterbody/1.0\" xmlns:tex=\"http://www.opengis.net/citygml/texturedsurface/1.0\" xmlns:core=\"http://www.opengis.net/citygml/1.0\" xmlns:xAL=\"urn:oasis:names:tc:ciq:xsdschema:xAL:2.0\" xmlns:bldg=\"http://www.opengis.net/citygml/building/1.0\" xmlns:sch=\"http://www.ascc.net/xml/schematron\" xmlns:app=\"http://www.opengis.net/citygml/appearance/1.0\" xmlns:veg=\"http://www.opengis.net/citygml/vegetation/1.0\" xmlns:gml=\"http://www.opengis.net/gml\" xmlns:gen=\"http://www.opengis.net/citygml/generics/1.0\">\n",
#            "<gml:boundedBy>\n",
#            "<gml:Envelope srsName=\"urn:ogc:def:crs,crs:EPSG::31256\" srsDimension=\"3\">\n",
#            "<gml:lowerCorner>2476.842 340940.844 11.396</gml:lowerCorner>\n",
#            "<gml:upperCorner>3019.05 341525.409 73.94</gml:upperCorner>\n",
#            "</gml:Envelope>\n",
#            "</gml:boundedBy>\n"
         ]

footer = [ "</topology:relations>" ]

if __name__ == '__main__':
    main()
