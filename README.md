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
```
