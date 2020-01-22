import meshio
from subprocess import call
import os
from dolfin import *

def solve_laplace(path, filename):

  # Read mesh and data
  geometry = meshio.read(path + filename + ".vtu")

  # Get points, cells and cell_data
  points = geometry.points
  cells  = geometry.cells
  cell_data  = geometry.cell_data
  point_data = geometry.point_data

  # Name of the point data
  point_data_name = "Phs unwrap"

  # Export mesh
  try:
      meshio.write(path+"mesh.xdmf", meshio.Mesh(points=points,
                     cells={"tetra": cells["tetra"]}))
  except:
    print("mesh.xdmf is not OK")
    pass

  # MPI parameters
  comm = MPI.comm_world
  rank = MPI.rank(comm)

  # Read mesh in XDMF format
  mesh = Mesh()
  with XDMFFile(path+"mesh.xdmf") as infile:
    infile.read(mesh)
  

  # Create function space
  V = FunctionSpace(mesh, "CG", 1)

  # Create dofs mappings
  v2d = vertex_to_dof_map(V)
  d2v = dof_to_vertex_map(V)

  # Velocity
  phi = Function(V)
  phi.vector()[v2d] = point_data[point_data_name].flatten()

  # Write XDMF function
  ofile = XDMFFile(comm, path+"phase.xdmf")
  ofile.write_checkpoint(phi, "unwrapped_phase", 0)
  ofile.close()

  # Set log level for parallel
  set_log_level(LogLevel.ERROR)
  if rank == 0: set_log_level(LogLevel.PROGRESS)

  # Read mesh
  mesh = Mesh()
  with XDMFFile(path+"mesh.xdmf") as infile:
      infile.read(mesh)

  # Import unwrapped phase
  ifile = XDMFFile(comm, path+"phase.xdmf")
  upha = Function(V)
  ifile.read_checkpoint(upha, "unwrapped_phase", 0)
  ifile.close()
  
  
  # Boundary conditions
  class Boundary(SubDomain):
    def inside(self, x, on_boundary):
        return on_boundary

  bc = DirichletBC(V, upha, Boundary())
  
  # normal to the boundary
  n = FacetNormal(mesh)
  
  # Variational formulation
  u = TrialFunction(V)
  v = TestFunction(V)
  F = inner(grad(u), grad(v))*dx #- dot(n,grad(u))*v*ds

  # Separate left and right sides of equation
  a, L = lhs(F), rhs(F)

  # Compute solution
  u = Function(V)
  solve(a == L, u, bc, solver_parameters={'linear_solver': 'cg', 'preconditioner': 'ilu'})
  
  # Save solution in file
  file = File(path + 'Solution.pvd')
  file << mesh
  file << u
  
