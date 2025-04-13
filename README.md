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
```

- now deploy this app with jenkions on to ec2 server with difefrent host ports that can be selected on jenkins file

  
