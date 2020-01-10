#!/bin/sh
pip3 install meshio lxml h5py --user
pip3 uninstall h5py --user
sudo apt install libhdf5-dev python3-h5py
