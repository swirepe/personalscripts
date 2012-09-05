
export HADOOP_HOME=/home/swirepe/src/hadoop
export HADOOP_CONF_DIR=/home/swirepe/src/hadoop/conf

export HIVE_HOME=/home/swirepe/src/hive
export HIVE_CONF_DIR=/home/swirepe/src/hive/build/dist/conf


## via ethan - for projects
export JAVA_HOME=/usr/lib/jvm/java-1.6.0-openjdk-amd64
export EDITOR=/usr/bin/vim
export SVN_EDITOR=$EDITOR
export GIT_EDITOR=$EDITOR
export SCIENCE_HOME=~/code/science
export BIGDATA_HOME=~/code/bigdata
export METADATA_HOME=~/code/metadata
export RELEASE_HIVERC=$BIGDATA_HOME/target/hiverc
export BASE_PYTHONPATH="$PYTHONPATH"
export PYTHON_HOME=$(which python)
export PYTHON_HOME_TARBALL=~/src/python-virtualenv.tar.gz
export SCIENCE_HOME_TARBALL=~/src/science-science.tar.gz
export BIGDATA_HOME_TARBALL=$BIGDATA_HOME/target/bigdata-bigdata-1.0.6.tgz
export BIGDATA_PYTHON_TARBALL=$BIGDATA_HOME/target/bigdata-python-bigdata-1.0.6.tar.gz

PATH=$PATH:~/bin:$HADOOP_HOME/bin:$JAVA_HOME/bin

SCIENCE_PATH="$SCIENCE_HOME/core:$SCIENCE_HOME/script:$SCIENCE_HOME:$BASE_PYTHONPATH:$SCIENCE_HOME/metrics/src/main/python" 
METADATA_PATH="$METADATA_HOME:$METADATA_HOME/tugboat:$METADATA_HOME/tugboat/clients:$METADATA_HOME/tugboat/models:$METADATA_HOME/tugboat/modules"
BIGDATA_PATH="$BIGDATA_HOME/src/main/python:$BIGDATA_HOME/core/src/main/python:$BIGDATA_HOME/common/src/main/python:$SCIENCE_HOME:$BASE_PYTHONPATH:$BIGDATA_HOME/metrics/src/main/python:$METADATA_PATH"

