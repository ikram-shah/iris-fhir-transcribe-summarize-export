docker stop $(docker ps -q)
docker system prune -f
docker-compose build --no-cache
docker-compose up -d