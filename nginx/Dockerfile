FROM nginx:alpine
COPY nginx.conf /etc/nginx/nginx.conf
RUN rm -rf /usr/share/nginx/html/*

EXPOSE 80
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]