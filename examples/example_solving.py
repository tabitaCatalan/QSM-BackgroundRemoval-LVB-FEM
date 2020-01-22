"""
This script reads example data and saves solution

Author: Tabita Catalan
"""

import sys
sys.path.append('../') # to read files from the upper level

from background_field_fem import *
  
if __name__=="__main__":
  f = open("folder_name.txt", "r")
  folder_name = f.read()
  path = "../results/"  + folder_name + "/"
  filename = "mesh_data"
  comm = set_up_parallel()
  point_data = mesh_from_vtu_to_xdmf(path, filename)
  read_xdmf_mesh_and_solve(path, point_data, comm)