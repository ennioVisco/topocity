from storage import *
from collections import Counter
import xml.etree.ElementTree as ET
from re import sub
from tempfile import mkstemp
from shutil import move
from os import fdopen, remove

PATH_PREFIX = '../../../../../Downloads/'
DIR_PATH = PATH_PREFIX + 'CityGML_BUILDINGS_LOD2_NOTEXTURES_678504x2/'

def main():
    file = DIR_PATH + 'nyc.gml'
    getTagsFromListOfFile()

# Returns the list of tags in the provided file
def getTagsFromListOfFile():
    files = list_dir(DIR_PATH)
    elemList = []
    name = ""

    for f in files:
        try:
            name = f
            elems = getElements(DIR_PATH + f)
            elemList = elemList + elems
            tags = count_tags(DIR_PATH + f)
            c = 0
            for tag, count in tags.items():
                c = c + count
            print(c)
        except MemoryError:
            print("Reached memory error at file: " + name)
        #finally:
            #elemList = elemList + getElements(DIR_PATH + files[0])
    elemList = clearNS(set(elemList))
    store("tags.txt", '\n'.join(elemList))



# load and parse the file
def getElements(p):
    xmlTree = ET.parse(p)

    elemList = []

    for elem in xmlTree.iter():
        elemList.append(elem.tag)

    # now I remove duplicities - by convertion to set and back to list
    elemList = list(set(elemList))

    # Just printing out the result
    return elemList

# Method for counting tags in a file
def count_tags(filename):
        my_tags = []
        for event, element in ET.iterparse(filename):
            my_tags.append(element.tag)
        my_keys = Counter(my_tags).keys()
        my_values = Counter(my_tags).values()
        my_dict = dict(zip(my_keys, my_values))
        return my_dict

# Method for replacing lines in a file
# Example usage:
# replace(file, r"<gml:posList .*<\/gml:posList>", "<gml:posList />")
def replace(file_path, find, repl):
    #Create temp file
    fh, abs_path = mkstemp()
    with fdopen(fh,'w') as new_file:
        with open(file_path) as old_file:
            for line in old_file:
                line = sub(find, repl, line)
                new_file.write(line)
    #Move new file
    move(abs_path, file_path)

#Method used to rewrite namespaces in a readable format
def clearNS(elems):
    for e in elems:
        for ns, url in namespaces.items():
            n = e.replace(url, ns)
            elems.remove(e)
            elems.add(n)
            e = n
    return elems

# Fixed set of namespaces
namespaces = {
    "tran:": "{http://www.opengis.net/citygml/transportation/2.0}",
    "core:": "{http://www.opengis.net/citygml/2.0}",
    "gml:": "{http://www.opengis.net/gml}",
    "gen:": "{http://www.opengis.net/citygml/generics/2.0}",
    "bldg:": "{http://www.opengis.net/citygml/building/2.0}",
    "xAL:": "{urn:oasis:names:tc:ciq:xsdschema:xAL:2.0}",
    "brid:": "{http://www.opengis.net/citygml/bridge/2.0}",
    "veg:": "{http://www.opengis.net/citygml/vegetation/2.0}",
    "dem:": "{http://www.opengis.net/citygml/relief/2.0}",
    "wtr:": "{http://www.opengis.net/citygml/waterbody/2.0}",
    "app:": "{http://www.opengis.net/citygml/appearance/2.0}"
}


if __name__ == '__main__':
    main()
