# frontend-app

- test the app with below command locally
```
cd frontend-app
python3 -m http.server 8000
- open port 8000
```

```
docker build -t sample-frontend .
docker run -d -p 8000:80 --name frontend-container sample-frontend
docker ps
docker logs frontend-container
docker exec -it frontend-container /bin/bash
docker stop frontend-container

- now push the image manually for the first time to dockerhub
docker login -u sinha352 -p <password>
WARNING! Using --password via the CLI is insecure. Use --password-stdin.
Login Succeeded

docker tag sample-frontend:latest sinha352/frontend-app 

docker push sinha352/frontend-app:latest

```

- now deploy this app with jenkions on to ec2 server with difefrent host ports that can be selected on jenkins file


  ```
  - install jenkins
  - configure ec2 server key inside jenkins credentails
  - configure dockerhub credentails inside jenkins credentails
  - install docker on jenkins to build the image
  ```
