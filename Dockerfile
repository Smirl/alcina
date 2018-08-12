FROM registry.smirlwebs.com/smirl/nginx-amplify:latest
ADD https://github.com/gohugoio/hugo/releases/download/v0.46/hugo_0.46_Linux-64bit.deb /tmp/hugo.deb
COPY . /opt/alcina
RUN dpkg -i /tmp/hugo.deb \
    && rm /tmp/hugo.deb \
    && hugo -s /opt/alcina -d /usr/share/nginx/html  --cleanDestinationDir
