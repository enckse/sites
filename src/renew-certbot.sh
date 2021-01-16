#!/bin/bash
/usr/bin/certbot renew --quiet --agree-tos
systemctl reload nginx.service
