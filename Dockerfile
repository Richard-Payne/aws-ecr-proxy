FROM nginx:1.12.0-alpine

RUN apk -v --update add \
        python \
        py-pip \
        ca-certificates \
        && \
    update-ca-certificates && \
    pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org --upgrade pip awscli && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/*

ADD configs/nginx/nginx.conf /etc/nginx/nginx.conf
ADD configs/nginx/ssl /etc/nginx/ssl

ADD configs/entrypoint.sh /entrypoint.sh
ADD configs/auth_update.sh /auth_update.sh
ADD configs/renew_token.sh /renew_token.sh

EXPOSE 80 443

ENTRYPOINT ["/entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
