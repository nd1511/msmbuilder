#!/bin/bash

# Print each line, exit on error
set -ev

# Install the built package
conda create --yes -n docenv python=$CONDA_PY
source activate docenv
conda install -yq --use-local msmbuilder-dev

# We don't use conda for these:
# sphinx_rtd_theme's latest releases are not available
# neither is msmb_theme
# neither is sphinx > 1.3.1 (fix #1892 autodoc problem)
# msmexplorer has msmbuilder release as a dependency on conda
pip install -I sphinx==1.3.5 sphinx_rtd_theme==0.1.9 msmb_theme==1.2.0 msmexplorer==0.1.0

# Install doc requirements
conda install -yq --file docs/requirements.txt

# Make docs
cd docs && make html && cd -

# Move the docs into a versioned subdirectory
python devtools/travis-ci/set_doc_version.py

# Prepare versions.json
python devtools/travis-ci/update_versions_json.py
