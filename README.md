# WPS-CMake
[![Build status Appveyor](https://ci.appveyor.com/api/projects/status/8axylclvn10h32kk/branch/wps-cmake?svg=true)](https://ci.appveyor.com/project/WRF-CMake/wps/branch/wps-cmake) [![Build Status Travis CI](https://travis-ci.com/WRF-CMake/wps.svg?branch=wps-cmake)](https://travis-ci.com/WRF-CMake/wps) [![Build Status Azure Pipelines](https://dev.azure.com/WRF-CMake/wrf/_apis/build/status/WPS%20(full)?branchName=wps-cmake)](https://dev.azure.com/WRF-CMake/wrf/_build/latest?definitionId=6&branchName=wps-cmake) [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3407074.svg)](https://doi.org/10.5281/zenodo.3407074)


## Installation

Please see the [WRF-CMake repository](https://github.com/WRF-CMake/wrf#installation) for information on how to install WPS-CMake.


## How to cite

Permanent DOIs for versions of the WPS-CMake extension are avalable on Zenodo at https://zenodo.org/record/3407074.

For information on how to cite WRF-CMake, please see the [How to cite section](https://github.com/WRF-CMake/wrf#how-to-cite) in the WRF-CMake repository.


## Changes to be upstreamed

The following is a list of changes to be upsteamed:
- `metgrid/src/{read,write}_met_module.F`, `ungrib/src/{datint,output,rrpr,ungrib}.F`: Replace colons with underscores in filenames to be compatible with Windows
- `ungrib/src/cio.c`, `ungrib/src/ngl/w3/bacio.v1.3.c`: Fixed file opening on Windows which is text-mode by default and has been changed to binary mode
- `util/src/elev_angle.F`: Establish compatibility with modern compilers by moving subroutines into module
- `util/src/elev_angle.F`: Add support for compilers that define `iargc` as 'intrinsic' instead of 'external'
- `util/src/elev_angle.F`: Fixed ordering of argument declarations to avoid Cray compile errors


## Copyright and license

General WRF copyright and license applies for any files part of the original WPS distribution — see the [README](README) file for more details.

Additional files provided by WPS-CMake are licensed according to [LICENSE_CMAKE.txt](LICENSE_CMAKE.txt) if the relevant file contains the following header at the beginning of the file, otherwise the general WRF copyright and license applies.
```
Copyright 2018 M. Riechert and D. Meyer. Licensed under the MIT License.
```
