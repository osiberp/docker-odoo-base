FROM debian:jessie
MAINTAINER Gonzalo Lopez <gmlp.24a@gmail.com>

COPY docker-build-helpers/*.bash /usr/share/docker-build-helpers/
COPY docker-build-helpers/entrypoint.sh /entrypoint.sh
RUN bash /usr/share/docker-build-helpers/build.bash
VOLUME ["/opt/odoo","/opt/3rd-party-addons"]
RUN useradd -ms /bin/bash odoo && ln -s /opt/odoo/openerp-server /usr/bin/
USER odoo
WORKDIR /opt
#python /opt/odoo/odoo.py --db_user=odoo --addons-path="/opt/odoo/addons/,$(ls -dm /opt/3rd-party-addons/*)"
EXPOSE 8069 8071
ENTRYPOINT ["/entrypoint.sh"]
CMD ["openerp-server"]


