#!/bin/bash

set -euxo pipefail

# ssh shellbox.dev create-from-oci masonm docker.io/library/php:8.5.6-fpm-trixie

ssh masonm@sb 'apt-get install -y php8.4-fpm nginx git rsync vim'
rsync -avz nginx masonm@sb:/etc/
rsync -avz --usermap='*:www-data' --groupmap='*:www-data' www/masonm.org masonm@sb:/var/www/
ssh masonm@sb 'service nginx restart'

