Here is a docker-compose.yml example: 

services:
  parking:
    image: regentcollege/parking
    ports: 
       - '80:80'
    volumes:
      - /var/www/parking:/var/www/parking
