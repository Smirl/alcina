FROM registry.smirlwebs.com/smirl/nginx-amplify:latest
COPY . .
RUN apt-get update \
	&& apt-get update \
	&& apt-get install -qqy hugo \
	&& rm -rf /var/lib/apt/lists/* \
	&& hugo --destination /usr/share/nginx/html
