#!/usr/bin/env bash
set -e

# check files (install, htaccess)
echo "### STEP: 1 -- Check updates"
if [[ -e "$PWD/composer.json" ]]; then
  echo "SUCCESS: Composer found in $PWD - update now..."

  composer config -g github-oauth.github.com $GITHUB_TOKEN
  composer install

  echo "SUCCESS: Complete! Composer has been successfully updated in $PWD"
fi

# check certs (generate)
echo "### STEP: 2 -- Check ssl"
if [[ ! -e "/var/www/provision/proxy/certs/$APP_DOMAIN/cert.crt" ]]; then
  echo "WARNING: SSL certs is not defined - generate now..."

  /var/www/provision/web/scripts/gen-certs.sh $APP_DOMAIN

  echo "SUCCESS: Complete! SSL certs is generated in $PWD"
fi

echo "================================================================="
echo "Installation is complete"
echo ""
echo "Site Url: https://${APP_DOMAIN}"
echo "Frontend Url: https://frontend.${APP_DOMAIN}"
echo "Backend Url: https://backend.${APP_DOMAIN}"
echo ""
echo "================================================================="

exec "$@"
