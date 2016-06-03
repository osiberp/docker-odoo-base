#!/bin/bash
set -e

# set odoo database host, port, user and password
: ${PGHOST:=$DB_PORT_5432_TCP_ADDR}
: ${PGPORT:=$DB_PORT_5432_TCP_PORT}
: ${PGUSER:=${DB_ENV_POSTGRES_USER:='postgres'}}
: ${PGPASSWORD:=$DB_ENV_POSTGRES_PASSWORD}
export PGHOST PGPORT PGUSER PGPASSWORD
ADDONS_PATH_ODOO=$(ls -dm /opt/3rd-party-addons/*)

case "$1" in
    --)
        shift
        exec openerp-server "$@"
        ;;
    -*)
        exec openerp-server "$@"
        ;;
    *)
        exec "$@" --addons-path="/opt/odoo/addons,$(ls -dm /opt/3rd-party-addons/*)"
esac

exit 1
