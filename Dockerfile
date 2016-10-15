FROM debian:jessie
MAINTAINER Gonzalo Lopez <gmlp.24a@gmail.com>

#install dependencies

ENV ODOO_VERSION 10.0

RUN set -x; \
        apt-get update \
        && apt-get install -y --no-install-recommends \
            ca-certificates \
            curl \
            gcc \
            node-less \
            node-clean-css \
            python-pyinotify \
            python2.7-dev \
            python-renderpm \
            python-support \
            python-pip \
            libpq-dev \
            libxml2-dev \
            libxslt1-dev \
            libevent-dev \
            libsasl2-dev \
            libldap2-dev \
            libpng12-dev \
            libjpeg-dev \
        && curl -o wkhtmltox.deb -SL http://nightly.odoo.com/extra/wkhtmltox-0.12.1.2_linux-jessie-amd64.deb \
        && echo '40e8b906de658a2221b15e4e8cd82565a47d7ee8 wkhtmltox.deb' | sha1sum -c - \
        && dpkg --force-depends -i wkhtmltox.deb \
        && apt-get -y install -f --no-install-recommends \
        && curl -o /tmp/requirements.txt https://raw.githubusercontent.com/odoo/odoo/${ODOO_VERSION}/requirements.txt \
        && pip install --upgrade pip \
        && pip install -r /tmp/requirements.txt \
        && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false npm \
        && rm -rf /var/lib/apt/lists/* wkhtmltox.deb


RUN useradd -ms /bin/bash odoo && ln -s /opt/odoo/odoo-bin /usr/bin/


# Copy entrypoint script and Odoo configuration file
COPY ./entrypoint.sh /
COPY ./openerp-server.conf /etc/odoo/
RUN chown odoo /etc/odoo/openerp-server.conf

# Mount /var/lib/odoo to allow restoring filestore and odoo repo

RUN mkdir -p /var/lib/odoo/addons \
    && chown -R odoo:odoo /var/lib/odoo

VOLUME ["/opt/odoo","/var/lib/odoo"]

# Expose Odoo services
EXPOSE 8069 8071

# Set the default config file
ENV OPENERP_SERVER /etc/odoo/openerp-server.conf

# Set default user when running the container
#USER odoo

ENTRYPOINT ["/entrypoint.sh"]
CMD ["openerp-server"]
