# stop and restart docker containers for IRIS
docker stop $(docker ps -q)
docker system prune -f

# export required env vars for docker and vue
set -a
source ./src/vue/.env
echo "Exported env variables"

# rebuild and start new containers
docker-compose build --no-cache
docker-compose up -d

# start vue app
echo "Starting vue app"
cd src/vue/
npm i
npm run serve