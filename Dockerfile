# Inherit from Heroku's stack
FROM heroku/python

# Which version of node?
ENV NODE_ENGINE 4.1.1
# Locate our binaries
ENV PATH /app/heroku/node/bin/:/app/user/node_modules/.bin:$PATH

# Install OpenCV
RUN mkdir -p /app/.heroku/opencv /tmp/opencv
ADD Install-OpenCV /tmp/opencv
WORKDIR /tmp/opencv/Ubuntu
RUN echo 'deb http://archive.ubuntu.com/ubuntu trusty multiverse' >> /etc/apt/sources.list && apt-get update
RUN version=2.4.11 ./opencv_latest.sh

# Create some needed directories
RUN mkdir -p /app/heroku/node /app/.profile.d
WORKDIR /app/user

# Install node
RUN curl -s https://s3pository.heroku.com/node/v$NODE_ENGINE/node-v$NODE_ENGINE-linux-x64.tar.gz | tar --strip-components=1 -xz -C /app/heroku/node

# Export the node path in .profile.d
RUN echo "export PATH=\"/app/heroku/node/bin:/app/user/node_modules/.bin:\$PATH\"" > /app/.profile.d/nodejs.sh
RUN echo "export PKG_CONFIG_PATH=\"/app/.heroku/opencv/lib/pkgconfig\"" >> /app/.profile.d/nodejs.sh
RUN echo "export LD_LIBRARY_PATH=\"/app/.heroku/opencv/lib/:$LD_LIBRARY_PATH\"" >> /app/.profile.d/nodejs.sh

# Install leptonica for tesseract
RUN mkdir ~/temp &&\ 
    cd ~/temp/ &&\ 
    wget http://www.leptonica.org/source/leptonica-1.69.tar.gz &&\ 
    tar -zxvf leptonica-1.69.tar.gz &&\ 
    cd leptonica-1.69 &&\ 
    ./configure &&\ 
    make &&\ 
    checkinstall &&\ 
    ldconfig
    rm -rf ~/temp

# Install tesseract
RUN mkdir ~/temp &&\
    cd ~/temp/ &&\ 
    wget https://tesseract-ocr.googlecode.com/files/tesseract-ocr-3.02.02.tar.gz &&\ 
    tar xvf tesseract-ocr-3.02.02.tar.gz &&\ 
    cd tesseract-ocr &&\ 
    ./autogen.sh &&\ 
    mkdir ~/local &&\ 
    ./configure --prefix=$HOME/local/ &&\ 
    make &&\ 
    make install &&\ 
    cd ~/ &&\ 
    rm -rf ~/temp

# Add tesseact eng data
RUN cd ~/local/share &&\ 
    wget https://tesseract-ocr.googlecode.com/files/tesseract-ocr-3.02.eng.tar.gz &&\ 
    tar xvf tesseract-ocr-3.02.eng.tar.gz &&\
    rm -rf tesseract-ocr-3.02.eng.tar.gz

ENV PATH $PATH:/root/local/bin
ENV TESSDATA_PREFIX=/root/local/share/tesseract-ocr/

ONBUILD ADD package.json /app/user/
ONBUILD RUN /app/heroku/node/bin/npm install
ONBUILD ADD . /app/user/

