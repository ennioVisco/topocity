import requests


URL_BASE = "https://www.wien.gv.at/ma41datenviewer/downloads/ma41/geodaten/lod2_gml/"
FILE_EXT = "_lod2_gml.zip"
RESULTS_DIR = "files/"

MIN_X = 78
MIN_Y = 62
MAX_X = 136
MAX_Y = 107

def main():
    x = MIN_X
    y = MIN_Y
    for x in range(MIN_X, MAX_X):
        for y in range(MIN_Y, MAX_Y):
            download_file(to_str(x), to_str(y))

def to_str(n: int) -> str:
    if n < 100:
        return "0" + str(n)
    else:
        return str(n)


def download_file(x: str, y: str):
    url = URL_BASE + x + y + FILE_EXT
    file = RESULTS_DIR + x + y + FILE_EXT

    print("Downloading " + url + "...", end=' ')
    r = requests.get(url, allow_redirects = True)
    print("Done!")

    open(file, 'wb').write(r.content)
    print("Stored at " + file)

if __name__ == '__main__':
    main()
