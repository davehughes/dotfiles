#!/bin/zsh

SCRIPT_DIR=${0:a:h}
ODC_ROOT="${SCRIPT_DIR}/odc"
ODC_VENV="${ODC_ROOT}/env"
ODC_LOGFILE=${ODC_LOGFILE:-/tmp/osx-desktop-control.log}

PYTHONPATH=${ODC_ROOT} ${ODC_VENV}/bin/python -m odc.cli $@
