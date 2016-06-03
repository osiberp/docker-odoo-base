ODOO_DEPENDENCIES="python2.7 python-pip ca-certificates"
ODOO_BUILD_DEPENDENCIES="gcc python2.7-dev libxml2-dev \
    libxslt1-dev libevent-dev libsasl2-dev libldap2-dev \
    libpq-dev libpng12-dev libjpeg-dev"

ODOO_DEPENDENCIES_NPM="node-less node-clean-css"

TOOLS="curl"
{
    echo 'Acquire::Languages "none";'
    echo 'Apt::Install-Recommends "false";'
    echo 'Apt::Get::Assume-Yes "true";'
    echo 'Apt::Get::AllowUnauthenticated "true";'
    echo 'Apt::AutoRemove::RecommendsImportant "false";'
    echo 'Apt::AutoRemove::SuggestsImportant "false";'
} | tee /etc/apt/apt.conf.d/odoo-dev > /dev/null

apt-get update
apt-get install ${ODOO_DEPENDENCIES} ${ODOO_BUILD_DEPENDENCIES} \
    ${ODOO_DEPENDENCIES_NPM} ${TOOLS}
curl -o wkhtmltox.deb -SL http://nightly.odoo.com/extra/wkhtmltox-0.12.1.2_linux-jessie-amd64.deb
echo '40e8b906de658a2221b15e4e8cd82565a47d7ee8 wkhtmltox.deb' | sha1sum -c -
dpkg --force-depends -i wkhtmltox.deb
apt-get install -f
apt-get purge --auto-remove npm curl\
rm -rf /var/lib/apt/lists/* wkhtmltox.deb
curl -o /tmp/requirements.txt https://raw.githubusercontent.com/odoo/odoo/9.0/requirements.txt
pip install --upgrade pip
pip install -r /tmp/requirements.txt
