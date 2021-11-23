# FFVII
[![Match Status](https://img.shields.io/badge/matched-0.00-brightgreen.svg)]()
[![Decomp Status](https://img.shields.io/badge/decompiled-0.00-yellow.svg)]()

An in-progress decompilation of the original US release of Final Fantasy VII on the PSX.

## Building (Linux)

### Install build dependencies
The build process has the following package requirements:
- git
- build-essential
- binutils-mips-linux-gnu
- python3
- bchunk
- 7z

Under a Debian based distribution, you can install these with the following commands:
```
sudo apt-get update
sudo apt-get install git build-essential binutils-mips-linux-gnu python3 bchunk p7zip-full
```

### Clone the repository
Clone `https://github.com/Drahsid/ffvii.git` in whatever diretory you wish. Make sure to initialize the submodules!
```
git clone https://github.com/Drahsid/ffvii.git --recursive
cd ffvii
git submodule init
```

### Install Python3 requirements
Run `pip3 install requirements.txt`

### Prepare your base images
In the directory `base` place the `.bin` and `.cue` files of each disk in this folder with these names:
|disk|bin/cue|filename|
|:-:|:-:|:-:|
|1|bin|ffvii1.bin|
|1|cue|ffvii1.cue|
|2|bin|ffvii2.bin|
|2|cue|ffvii2.cue|
|3|bin|ffvii3.bin|
|3|cue|ffvii3.cue|

### Extracting the contents of the disks
The first time that you run `make setup`, assets will be extracted from your disks into the `SCUS_941` directory acoording to `common_files.yaml`. This will take a few minutes!
You can use `make ubernuke` to clean the relevant directories if you need to re-extract your assets.

### Build the code
Just run `make` to build. If the build succeeds, a folder will be produced with the name `build`, inside this, you will find the output.

## Contributing
Contributions are welcome. If you would like to reserve a function, open a PR with the function or file name(s).

## Big TODOs
Currently, capstone has no logic to disassemble GTE instructions (which are COP2 instructions,) and thus, these are interpreted as data. This means that any code that uses these are effectively not possible to decompile back into C (for now).

The process of extracting assets from the disk files is a two-step process, and optimally would become a single-step process.

Additionally, there is currently not a method to magically re-assemble the disk.


