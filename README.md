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
- Before using `functionName` it's necessary to solve the Poisson Equation in the generated mesh. This can be done using [FEniCS](https://fenicsproject.org), an open source computing platform with high-level Python and C++ interfaces. In examples it was used FEniCS with the Python interface, running in a Windows 10 computer with [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10).



## Credits
- This code was based on the source code and data for the QSM 2016 Reconstruction Challenge, released by Berkin Bilgic at http://martinos.org/~berkin/software.html.
- Matlab functions for meshing and saving data are based in Julio Sotelo's codes. *(add website)*
- Python code to solve problem in FEniCS are based in Hernán Mellado's. *(add website)*
- Carlos Milovich
- Cristián Tejos

## License
This project is licensed under... *(complete this ...the MIT License, see the LICENSE.md file for details)*