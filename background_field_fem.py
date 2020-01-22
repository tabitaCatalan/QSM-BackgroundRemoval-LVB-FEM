"""
This file contains functions to solve read a mesh and point data stored in a VTU file,
and solve the Laplacian Boundary Value problem by Finite Elements.

Author: Hernan Mella
Last Modifiction: Tabita Catalan
"""
import os
import meshio
from subprocess import call
from dolfin import *

  
def set_up_parallel():
  # MPI parameters
  comm = MPI.comm_world
  rank = MPI.rank(comm)
  # Set log level for parallel
  set_log_level(LogLevel.ERROR)
  if rank == 0: set_log_level(LogLevel.PROGRESS)
  return comm

def mesh_from_vtu_to_xdmf(path, filename):
  """
  Read a VTU file with data of a mesh, and creates a file mesh.xdmf in the same directory.
  Input:
  - path: String, path to directory where .vtu file is stored. It must end in '/'.
  - filename: String, name without extension. Complete path to file will be: path + filename + ".vtu".
  Output:
  - point_data: point data gotten from .vtu
  """
  # Read mesh and data
  geometry = meshio.read(path + filename + ".vtu")
  # Get points, cells and cell_data
  points = geometry.points
  cells  = geometry.cells
  cell_data  = geometry.cell_data
  point_data = geometry.point_data
  # Export mesh
  try:
      meshio.write(path+"mesh.xdmf", meshio.Mesh(points=points,
                     cells={"tetra": cells["tetra"]}))
  except:
    print("mesh.xdmf is not OK")
    pass
  return point_data

def write_xdmf_phase(V, path, point_data, comm):
  """
  Input:
  - V: Function Space
  - path: 
  """
  # Name of the point data
  point_data_name = "Phs unwrap"
  # Create dofs mappings
  v2d = vertex_to_dof_map(V)
  d2v = dof_to_vertex_map(V)
  # Phase data
  phi = Function(V)
  phi.vector()[v2d] = point_data[point_data_name].flatten()
  # Write XDMF function
  ofile = XDMFFile(comm, path+"phase.xdmf")
  ofile.write_checkpoint(phi, "unwrapped_phase", 0)
  ofile.close()

def read_xdmf_phase(V, path, comm):
  """
  Input:
  - V: Function Space
  - path: 
  Output:
  - upha:
  """
  ifile = XDMFFile(comm, path + "phase.xdmf")
  upha = Function(V)
  ifile.read_checkpoint(upha, "unwrapped_phase", 0)
  ifile.close()
  return upha

def solve_laplace(V, upha):
  """
  Input:
  - V:
  - upha: funcion of V space, with determines the boundary conditions of LBV problem
  """
  # Boundary conditions
  class Boundary(SubDomain):
    def inside(self, x, on_boundary):
        return on_boundary
  bc = DirichletBC(V, upha, Boundary())
  # Variational formulation
  u = TrialFunction(V)
  v = TestFunction(V)
  F = inner(grad(u), grad(v))*dx #- dot(n,grad(u))*v*ds
  # Separate left and right sides of equation
  a, L = lhs(F), rhs(F)
  # Compute solution
  u = Function(V)
  solve(a == L, u, bc, solver_parameters={'linear_solver': 'cg', 'preconditioner': 'ilu'})
  return u

def save_solution(u, mesh, path):
  """
  Saves u to a Solution.pvd file, located in path.
  Input:
  - u:
  - mesh:
  - path:
  """
  file = File(path + "Solution.pvd")
  file << mesh
  file << u

def read_xdmf_mesh_and_solve(path, point_data, comm):
  """
  Reads data from xdmf and uses it to solve the laplace equation with Dirichlet BC.
  Input:
  - path: to mesh.xdmf file. Solution will be saved in path too. 
  - point_data: It'll be used to set de boundary conditions.
  """
  # Read mesh in XDMF format
  mesh = Mesh()
  with XDMFFile(path+"mesh.xdmf") as infile:
    infile.read(mesh)
  # Create function space
  V = FunctionSpace(mesh, "CG", 1)
  # Create dofs mappings
  #d2v = dof_to_vertex_map(V)
  # Write phase
  write_xdmf_phase(V, path, point_data, comm)
  # Import unwrapped phase
  upha = read_xdmf_phase(V, path, comm)
  # Solve LBV problem
  u = solve_laplace(V, upha)
  # Save solution in file
  save_solution(u, mesh, path)
