calculate_concurrency() {
  MEMORY_AVAILABLE=${MEMORY_AVAILABLE-$(detect_memory 512)}
  WEB_MEMORY=${WEB_MEMORY-512}
  WEB_CONCURRENCY=${WEB_CONCURRENCY-$((MEMORY_AVAILABLE/WEB_MEMORY))}
  if (( WEB_CONCURRENCY < 1 )); then
    WEB_CONCURRENCY=1
  elif (( WEB_CONCURRENCY > 32 )); then
    WEB_CONCURRENCY=32
  fi
  WEB_CONCURRENCY=$WEB_CONCURRENCY
}

log_concurrency() {
  echo "Detected $MEMORY_AVAILABLE MB available memory, $WEB_MEMORY MB limit per process (WEB_MEMORY)"
  echo "Recommending WEB_CONCURRENCY=$WEB_CONCURRENCY"
}

detect_memory() {
  local default=$1
  local limit=$(ulimit -u)

  case $limit in
    256) echo "512";;
    512) echo "1024";;
    32768) echo "6144";;
    *) echo "$default";;
  esac
}

oracle_home="$HOME/.oracle/"

export PATH="$HOME/.heroku/node/bin:$HOME/bin:$HOME/node_modules/.bin:$oracle_home:$PATH"
export NODE_HOME="$HOME/.heroku/node"

export ORACLE_HOME="$oracle_home"
export LD_LIBRARY_PATH="$oracle_home:$LD_LIBRARY_PATH"
export TNS_ADMIN="$oracle_home/network/admin"
export OCI_LIB_DIR="$oracle_home"
export OCI_INC_DIR="$oracle_home/sdk/include"

calculate_concurrency
log_concurrency

export MEMORY_AVAILABLE=$MEMORY_AVAILABLE
export WEB_MEMORY=$WEB_MEMORY
export WEB_CONCURRENCY=$WEB_CONCURRENCY
