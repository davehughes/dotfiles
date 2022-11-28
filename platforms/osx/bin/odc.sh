#!/bin/bash

# TODO: figure out a way to do this without hard-coding, probably with global system install?
ODC_ROOT=/Users/dave/bin/odc
ODC_VENV="${ODC_ROOT}/env"
ODC_LOGFILE=${ODC_LOGFILE:-/tmp/osx-desktop-control.log}

PYTHONPATH=${ODC_ROOT} ${ODC_VENV}/bin/python -m odc.cli $@
