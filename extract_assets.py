import yaml
import os
import subprocess

def DoExtract(args):
    print("7z " + args)
    os.system("7z " + args)

print("Opening common_files.yaml")
with open("common_files.yaml", "r") as file:
    common_files = yaml.safe_load(file)

print(common_files)

common_dir = common_files["options"]["common_dir"]

## Fix paths that use root
for data in common_files["common_uncommon"]:
    data[0] = data[0].replace("__root__", "")

for data in common_files["uncommon"]:
    data[1] = data[1].replace("__root__", "")

for data in common_files["common"]:
    data[0] = data[0].replace("__root__", "")

print("Making dirs")
for dir in common_files["options"]["uncommon_dirs"]:
    if not os.path.exists(dir):
        print(dir)
        os.mkdir(dir)

if not os.path.exists(common_dir):
    os.mkdir(common_dir)


## Ignore uncommon files
disk = common_files["options"]["disks"][0]
ignorelist = ""

for data in common_files["common_uncommon"]:
    path = data[0]

    if path != "":
        path = path + "/"

    if data[1] == "file":
        ignorelist += " -x!" + path + data[2]
    elif data[1] == "dir":
        ignorelist += " -xr!" + path + "*"

for data in common_files["uncommon"]:
    path = data[1]

    if path != "":
        path = path + "/"

    if data[2] == "file":
        ignorelist += " -x!" + path + data[3]
    elif data[2] == "dir":
        ignorelist += " -xr!" + path + "*"

for data in common_files["common"]:
    path = data[0]

    if path != "":
        path = path + "/"

    if data[3] == "file":
        ignorelist += " -x!" + path + data[1]
    elif data[3] == "dir":
        ignorelist += " -xr!" + path + "*"

## Extract common files
print("Extracting common files")
DoExtract("x -y " + disk + " -o" + common_dir + " " + ignorelist)

for data in common_files["common"]:
    path = data[0]

    if path != "":
        path = path + "/"

    if data[3] == "file":
        DoExtract("e " + disk + " -o" + common_dir + "/" + path + " " + path + data[1])
    elif data[3] == "dir":
        DoExtract("e " + disk + " -o" + common_dir + "/" + path + " " + path + data[1] + "/* -r")

    os.rename(common_dir + "/" + path + "/" + data[1], common_dir + "/" + path + "/" + data[2])

## Extract common uncommon files
print("Extracting common uncommon files")
index = 0
for disk in common_files["options"]["disks"]:
    for data in common_files["common_uncommon"]:
        path = data[0]
        imgpath = path
        if path != "":
            imgpath += "/"

        path = "/" + path

        if not os.path.exists(common_files["options"]["uncommon_dirs"][index] + path):
            os.mkdir(common_files["options"]["uncommon_dirs"][index] + path)

        if data[1] == "file":
            DoExtract("e " + disk + " -o" + common_files["options"]["uncommon_dirs"][index] + path + " " + imgpath + data[2])
        elif data[1] == "dir":
            DoExtract("e " + disk + " -o" + common_files["options"]["uncommon_dirs"][index] + path + " " + imgpath + "* -r")

    index = index + 1

## Extract unique files
print("Extracting unique files")
for data in common_files["uncommon"]:
    index = data[0]
    disk = common_files["options"]["disks"][index]
    path = data[1]
    imgpath = path
    if path != "/":
        imgpath += "/"

    path = "/" + path

    if not os.path.exists(common_files["options"]["uncommon_dirs"][index] + path):
        os.mkdir(common_files["options"]["uncommon_dirs"][index] + path)

    if data[2] == "file":
        DoExtract("e " + disk + " -o" + common_files["options"]["uncommon_dirs"][index] + path + " " + imgpath + data[3])
    elif data[2] == "dir":
        DoExtract("e " + disk + " -o" + common_files["options"]["uncommon_dirs"][index] + path + " " + imgpath + "* -r")

