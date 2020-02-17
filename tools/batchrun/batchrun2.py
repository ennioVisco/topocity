import subprocess
import sys
from storage import list_dir
from time import gmtime, strftime

DIR_PATH = "../../in/vienna/"

def main():
    # Logging init
    old_stdout = sys.stdout
    time = strftime("%Y_%m_%d__%H_%M_%S", gmtime())
    log_file = open("batchrun_" + time + ".log","w")

    files = list_dir(DIR_PATH)

    print(str(len(files)) + " model(s) found.")
    i = 0
    for f in files:
        i = i + 1
        runner(DIR_PATH + f, log_file, old_stdout)
        print("Executed model " + str(i) + " of " + str(len(files)) + ".")

    # Logging end
    log_file.close()

# java -jar citygml-tools.jar -i vienna/078085.gml -d 0 -c e

def runner(file, log, old_log):
    sys.stdout = log
    cmd = [ 'java', r'-jar', r'citygml-tools.jar',
            r'-i', file, r'-d', '-1', r'-c', 'e', r'-o', r'../../out/vienna/']
    process = subprocess.Popen(cmd,
                            shell=True, stderr=subprocess.DEVNULL,
                            stdout=subprocess.PIPE,
                            universal_newlines=True)

    while True:
        output = process.stdout.readline().strip()
        if output != "":
            print(output)
        return_code = process.poll()
        if return_code is not None:
            print('>>>>>>>>RETURN CODE:', return_code)
            # Process has finished, read rest of the output
            for output in process.stdout.readlines():
                print(output.strip())
            break

    sys.stdout = old_log

if __name__ == '__main__':
    main()
