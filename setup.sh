SCRIPT_DIR=$(cd "$(dirname "$0")"; pwd)
PYTHON_TOOLS_ENVDIR="${HOME}/.local/python-tools"

python3 -m venv "${PYTHON_TOOLS_ENVDIR}"
${PYTHON_TOOLS_ENVDIR}/bin/pip install -e ${SCRIPT_DIR}/python-tools/dave-cli
