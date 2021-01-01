sudo -u homeassistant -H -s
cd /srv/homeassistant

sudo -u homeassistant -H -s
cd /srv/homeassistant
python3.7 -m venv .
source bin/activate

curl -sfSL https://hacs.xyz/install | bash -
