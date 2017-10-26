import os
import glob

def gcp ():
    sourcedir = 'D:\PhD\Data\Landsat4_5\Scence222_62' # where the GCP files are
    destindir = 'D:\PhD\Data\Landsat4_5\Scence222_62\GCP' # where GCP files should go
    os.chdir(sourcedir)
    backslash = '\\'
    for files in glob.glob("*GCP.txt"):
          dfile = files
          ksource = sourcedir+backslash+dfile
          kdestin = destindir+backslash+dfile
          source = open(ksource)
          dest = open(kdestin , 'w')
          count = 0
          test = ""
          con = 0
          for line in source:
              dline = str (line)
              test = dline [0:8]
              count = count + 1
              
              if test == str ("Point_ID"):
                 con = count
              if con > 0:
                 print line
                 dest.write (line) #+'\n')
            #dest.write('\n')
    dest.close()
    source.close()
