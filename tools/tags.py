# Returns a list of tags used in an xml file

import xml.etree.ElementTree as ET

PATH = '../../../Downloads/_TESI/Delft.gml/Delft_3dfier.gml'

# load and parse the file
xmlTree = ET.parse(PATH)

elemList = []

for elem in xmlTree.iter():
  elemList.append(elem.tag) # indent this by tab, not two spaces as I did here

# now I remove duplicities - by convertion to set and back to list
elemList = list(set(elemList))

# Just printing out the result
print(elemList)
