"""
This script reads example data and saves solution

Author: Tabita Catalan
"""

import sys
sys.path.append('../') # to read files from the upper level

# from background_field_fem import *
from solve_laplace import solve_laplace

  
if __name__=="__main__":
  f = open("folder_name.txt", "r")
  folder_name = f.read()
  path = "../results/"  + folder_name + "/"
  filename = "mesh_data"
  solve_laplace(path, filename)