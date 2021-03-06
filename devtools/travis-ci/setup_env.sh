#!/bin/sh

if [ "$TRAVIS_OS_NAME" = "osx" ]; then
    wget http://repo.continuum.io/miniconda/Miniconda-3.7.0-MacOSX-x86_64.sh -O miniconda.sh;
else
    wget http://repo.continuum.io/miniconda/Miniconda-3.7.0-Linux-x86_64.sh -O miniconda.sh;
fi

bash miniconda.sh -b

export PATH=$HOME/miniconda/bin:$PATH
# install stable version
pip install conda
conda update -n root conda-build --yes
conda install --yes conda-build jinja2 anaconda-client pip

# create myenv
conda create -y -n myenv python=$PYTHON_VERSION
source activate myenv

pip install -r $TRAVIS_BUILD_DIR/pip-requirements-test.txt
sh $TRAVIS_BUILD_DIR/conda-requirements-test.sh

if [ "$TEST_NOTEBOOK" = "yes" ]; then
    npm install -g nightwatch
fi

# download ngl data
git clone https://github.com/arose/ngl
mv ngl ../
