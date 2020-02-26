# QSM-BackgroundRemoval-LVB-FEM

A Matlab toolbox for Background field removal in Quatitative Susceptibility Mapping, by solving Laplacian Boundary Value problem, using Finite Elements.


## Motivation
*A short description of the motivation behind the creation and maintenance of the project. This should explain **why** the project exists.*
## Features
*What makes your project stand out?*

## Code Example
*Show what the library does as concisely as possible, developers should be able to figure out how your project solves their problem by looking at the code example. Make sure the API you are showing off is obvious, and that your code is short and concise.*

## Getting started

### Prerequisites
- Meshing functions rely on [iso2mesh](http://iso2mesh.sourceforge.net/cgi-bin/index.cgi); be sure it is on your Matlab's path.
- Before using `functionName` it's necessary to solve the Poisson Equation in the generated mesh. This can be done using [FEniCS](https://fenicsproject.org), an open source computing platform with high-level Python interface. 
- To use the Python interface are needed the libraries [meshio](https://pypi.org/project/meshio/), [lxml](https://lxml.de). These can be installed running the following lines in a Linux terminal (or running the file `script.sh`).

```
#!/bin/sh
pip3 install meshio lxml --user
pip3 uninstall h5py --user
sudo apt install libhdf5-dev python3-h5py
```

### Examples

In folder [examples](examples/) can be found files to run an example. To try this it was used Matlab2018a and FEniCS *version*, running in a Windows 10 computer with [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

1. Run the script `example_meshing.m` in Matlab. It assumes that [examples](examples/) is your current directory. This script relies strongly on *iso2mesh*, so be sure of modifying the line `addpath('../../iso2mesh/')` before running, to ensure it coincides with your own path to the library. `example_meshing.m` generates a new folder `p5_g1-0_c0-0_e1-0_k0-4_v30-0/` inside of [results](results/) (the name of the folder depends on the parameters used to generate the mesh). Inside this folder, a `mesh_data.vtu` with data of the created mesh and the *unwrapped phase* is stored. It also saves some pictures with mesh information and a file `log_mesh.txt` with information about the created mesh.
2. Run `example_solving.py`; this needs _FEniCS_. This will solve the Poisson's Equation using data from `mesh_data.vtu`. Before running, be sure that the file `folder_name.txt` contains a single line with the name of the folder inside of [results](results/) where `mesh_data.vtu` is stored. The results will be saved in the same folder. This script will read the data of the mesh and solve the Poisson's equation, using the *unwrapped phase* as boundary condition, to obtain the background field, with is stored in a `Solution000001.vtu` and can be visualized using Paraview.
3. Run the script `example_read_compare_solution.m` in Matlab. This will use `Solution000001.vtu` to obtain the *phase tissue*. Be sure of modifying the Load data section, to use the mask with the right level of peeling.

## Documentation
### data
*description of files*

- `Mask_bet.mat`: brain mask from *BET*
- `msk.mat`: is a brain mask, obtained by eroding the *BET* mask by 5 voxels (by setting `peel=5` in *LBV*)
- `phs_unwrap.mat`: phase from trans orient processed with *Laplacian unwrapping* and *BET* masking 
- `mask_p0`, `mask_p1`, `mask_p5`: obtained by running `example_get_mask_from_LBV.m` in `examples/` folder.

(in radians)

## Credits
- This code was based on the source code and data for the QSM 2016 Reconstruction Challenge, released by Berkin Bilgic at http://martinos.org/~berkin/software.html.
- Matlab functions for meshing and saving data are based in Julio Sotelo's codes. *(add website)*
- Python code to solve problem in FEniCS are based in Hernán Mella's. *(add website)*
- Carlos Milovich
- Cristián Tejos

## License
This project is licensed under... *(complete this ...the MIT License, see the LICENSE.md file for details)*