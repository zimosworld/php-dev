
This is an example that can be used for developing a PHP project locally using Docker.   
  
This example uses [jwilder nginx-proxy](https://github.com/jwilder/nginx-proxy) which allows you to have multiple websites running under different containers at the same time.  
  
## Setup  
  
Setting up this template consists of two main steps, firstly the proxy (this is only required once per machine), then there is the container.  
  
### Proxy Setup  
  
To setup the proxy there are two options, with SSL or without SSL .
  
With SSL requires you to generate a SSL Certificate and place it into the certificates folder from where you run the below command.
```  
docker run -d -p 80:80 -p 443:443 -v ./certificates:/etc/nginx/certs -v /var/run/docker.sock:/tmp/docker.sock:ro --name=proxy jwilder/nginx-proxy  
```  
  
Without SSL does not require any other changes.
```  
docker run -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro --name=proxy jwilder/nginx-proxy  
```  
  
### Container Setup  
There are two parts to the container setup, firstly setting up some environment variables in a .env file then starting the container.

The environment variables that are needed in the .env file are:
#### For Linux
```
HOST_UNAME=Linux

#Optional if your UID and/or GID is not 1000
#APACHE_UID=1001
#APACHE_GID=1001
```
#### For Windows
```
HOST_UNAME=Windows
```
  
To setup/start the container run:  
  
```  
docker-compose up -d  
```