FROM registry.smirlwebs.com/smirl/nginx-amplify:latest
COPY . .
RUN (apt-get update || apt-get install apt-transport-https) \
	&& apt-get install hugo \
	&& rm -rf /var/lib/apt/lists/* \
	&& hugo --destination /usr/share/nginx/html
