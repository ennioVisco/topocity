# Returns a list of tags used in an xml file

from storage import *
import xml.etree.ElementTree as ET

#PATH = '../../../../OneDrive/Documenti/Polimi/TESI/CityGML/citygml converter/it.polimi.citygml/it.polimi.citygml/gen-datasets/city10/MERGED-LOD3_3-Road-LOD0.gml'
DIR_PATH = '../../../../../Downloads/_TESI/DA_WISE_GML/DA_WISE_GMLs/'

def main():
    files = list_dir(DIR_PATH)
    elemList = []
    name = ""

    for f in files:
        try:
            name = f
            elems = getElements(DIR_PATH + f)
            elemList = elemList + elems
        except MemoryError:
            print("Reached memory error at file: " + name)
        #finally:
            #elemList = elemList + getElements(DIR_PATH + files[0])

    store("tags.txt", '\n'.join(set(elemList)))



# load and parse the file
def getElements(p):
    xmlTree = ET.parse(p)

    elemList = []

    for elem in xmlTree.iter():
      elemList.append(elem.tag) # indent this by tab, not two spaces as I did here

    # now I remove duplicities - by convertion to set and back to list
    elemList = list(set(elemList))

    # Just printing out the result
    return elemList

if __name__ == '__main__':
    main()
