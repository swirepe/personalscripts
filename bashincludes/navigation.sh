# fast navigation
function code {
  cd ~/code
}

function src {
  cd ~/src
}

function pers {
  cd ~/pers   
}

function bigdata {
  activate bigdata
  cd ~/code/bigdata   
}

function science {
  cd ~/code/science   
}

function metadata {
  activate bigdata
  cd $METADATA_HOME
}


function scripts {
  cd ~/scripts   
}

function envs {
  cd ~/envs   
}

function provider_metrics {
  bigdata
  cd script/metrics/provider_metrics
  ls
}
