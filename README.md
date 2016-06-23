## Docker Image for OCR and CV service on Heroku

This docker image has NodeJS, OpenCV and Tesseract for [Heroku](http://heroku.com) and the
[heroku-docker](https://github.com/heroku/heroku-docker) CLI plugin.

[Available on Dockerhub!](https://hub.docker.com/r/hideyuki/docker-heroku-nodejs-opencv-tesseractv/).


```
$ docker pull hideyuki/docker-heroku-nodejs-opencv-tesseract
```

### Versions

- [OpenCV](http://opencv.org/): 2.4.13
- [Tesseract](https://github.com/tesseract-ocr/tesseract): 3.4.1
- [Leptonica](http://www.leptonica.org/): 1.73

### References
- [guitarmind/tesseract-web-service](https://github.com/guitarmind/tesseract-web-service)
- [pastak/docker-heroku-nodejs-opencv](https://github.com/pastak/docker-heroku-nodejs-opencv)

## Deploy

```
$ docker build --tag=hideyuki/docker-heroku-nodejs-opencv-tesseract .
$ docker push hideyuki/docker-heroku-nodejs-opencv-tesseract
```
