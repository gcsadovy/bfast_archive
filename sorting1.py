import os, sys

arcpy.env.overwriteOutput = True

startdir = "I:\REFLECTANCE"
berdir = "I:\REFLECTANCE\BERAU"
kccpdir = "I:\REFLECTANCE\KCCP"
katdir = "I:\REFELCTANCE\KATINGAN"

sites = ("BERAU", "KATINGAN", "KCCP")
#for site in sites:
    #os.mkdir(startdir+"/"+site)

ber = [115058, 115059, 116058, 116059, 117058, 117059]
kccp = [121061, 122061]
kat = [118061, 118062, 119061, 119062]

for file in os.listdir(startdir):
    desig1 = str(file)
    print desig1[:-4]
    print "done"