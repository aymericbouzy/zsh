function testdb {
  local SQL='DROP DATABASE IF EXISTS \`${DB_DATABASE:-$MYSQL_DATABASE}\`; CREATE DATABASE \`${DB_DATABASE:-$MYSQL_DATABASE}\`;'
  local COMMAND='MYSQL_PWD=${DB_PASS:-$MYSQL_PASSWORD} mysql -h ${DB_HOST:-$MYSQL_HOST} -u ${DB_USER:-$MYSQL_USER} -e "'$SQL'"'
  dotenv -e .env.test -- bash -c "$COMMAND"
}

function testdb-flow {
  local SQL='DROP DATABASE IF EXISTS \`${DB_DATABASE:-$MYSQL_DATABASE}\`; CREATE DATABASE \`${DB_DATABASE:-$MYSQL_DATABASE}\`;'
  local COMMAND='MYSQL_PWD=${DB_PASS:-$MYSQL_PASSWORD} mysql -h ${DB_HOST:-$MYSQL_HOST} -u ${DB_USER:-$MYSQL_USER} -e "'$SQL'"'
  NODE_ENV=test dotenv-flow -- bash -c $COMMAND
}

alias tw="testdb && (make init-test || make test-init) && yarn test:watch"

# available: rabbitmq sftp mongodb elasticsearch product-elasticsearch mysql
alias devenv="cd $HOME/Dev/cubyn/infra-docker-compose; docker-compose -f datasources.yml up"

# helm
export CUBYN_HELM_PATH="$HOME/Dev/cubyn/helm"

function shmig-rollback {
  if [ -d migrations/prod ]; then
    local MIGRATIONS_DIRECTORY="migrations/prod"
  else
    local MIGRATIONS_DIRECTORY="migrations"
  fi
  local COMMAND='./shmig -t mysql -l ${DB_USER:-$MYSQL_USER} -p ${DB_PASS:-$MYSQL_PASSWORD} -d ${DB_DATABASE:-$MYSQL_DATABASE} -H ${DB_HOST:-${MYSQL_HOST:-localhost}} -P ${DB_PORT:-${MYSQL_PORT:-3306}} -m '$MIGRATIONS_DIRECTORY' -s migrations rollback 1'
  dotenv -e ${DOTENV_FILE:-.env} -- bash -c "$COMMAND"
}
