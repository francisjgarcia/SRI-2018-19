FROM debian
MAINTAINER Francis "francisjgarcia94@gmail.com"

RUN apt-get update && apt-get install -y nginx && apt-get clean

EXPOSE 80

ADD ["datos/default","/etc/nginx/sites-available"]

RUN service nginx restart

CMD ["nginx", "-g", "daemon off;"]
