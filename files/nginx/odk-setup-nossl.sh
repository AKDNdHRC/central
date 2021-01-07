echo "writing a new nginx configuration file.."
/bin/bash -c "cp /usr/share/nginx/odk-nossl.conf.template /etc/nginx/conf.d/odk.conf"
echo "starting nginx without certbot.."
nginx -g "daemon off;"