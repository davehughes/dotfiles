# TODO: properly package any/all of these for nix
```
CLI_PROJECT_PATH=~/.config/home-manager/python-tools/dave-cli
PYTHON_TOOLS_ENVDIR=~/.local/python-tools
python3 -m venv $PYTHON_TOOLS_ENVDIR
source $PYTHON_TOOLS_ENVDIR/bin/activate
$PYTHON_TOOLS_ENVDIR/bin/pip install -e $CLI_PROJECT_PATH
```
