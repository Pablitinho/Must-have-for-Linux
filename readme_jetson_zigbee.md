## DONT USE THIS ONE
sudo npm install -g pm2 --unsafe-perm
pm2 startup
pm2 start homebridge
pm2 save


# Zigbee usb CC2531 installation
## Check that the USB is listed in the system

lsusb

Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
###Bus 001 Device 018: ID 0451:16a8 Texas Instruments, Inc. 
Bus 001 Device 003: ID 1a40:0801 Terminus Technology Inc. 
Bus 001 Device 002: ID 0bda:c811 Realtek Semiconductor Corp. 
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub


test -w /dev/ttyACM0 && echo success || echo failure

### If you have failure do:
sudo usermod -a -G dialout $USER
sudo chmod a+r+w /dev/ttyACM0
sudo ls -l /proc/[0-9]/fd/ |grep /dev/ttyACM0

You need to apply this on every reboot. To fix this you can use a ‘udev’ rule:

udevadm info -a -n /dev/ttyACM0 | grep 'serial' get the serial to your device YOURSERIAL

Create the rule file with: 

sudo vi /etc/udev/rules.d/99-usb-serial.rules

add this line: 

SUBSYSTEM=="tty", ATTRS{idVendor}=="0451", ATTRS{idProduct}=="16a8", ATTRS{serial}=="YOURSERIAL", SYMLINK="ttyUSB.CC2531-01", OWNER="jetson"

modify your Zigbee2MQTT config to adjust new SYMLINK name: nano /opt/zigbee2mqtt/data/configuration.yaml

… serial: port: /dev/ttyUSB.CC2531-01 …


###  Apply this on every reboot
udevadm info -a -n /dev/ttyACM0 | grep 'serial'


## Install

### Install mosquito 
sudo apt-get install mosquitto
sudo apt-get install -y libffi-dev
### Install MQTT Explorer

http://mqtt-explorer.com/

### Install platypush
git clone https://github.com/BlackLight/platypush
cd platypush
python3 setup.py build
python3 setup.py install
pip3 install -r requirements.txt

### Server 
sudo apt install python3-pip
sudo apt-get install redis-server
sudo systemctl start redis.service
sudo systemctl enable redis.service
pip3 install 'platypush[zigbee,http,mqtt]'

### Skip it if you have installed
sudo curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs git make g++ gcc


### Clone zigbee2mqtt
sudo git clone https://github.com/Koenkk/zigbee2mqtt.git /opt/zigbee2mqtt

sudo chown -R jetson:jetson /opt/zigbee2mqtt

cd /opt/zigbee2mqtt
npm ci --production

### Check if the config file is generated properly

C
### Add network key
/opt/zigbee2mqtt/data/configuration.yaml -> Here
advanced:
network_key: GENERATE

### Run Zigbee2MQTT
sudo npm start

#### if error:
sudo chmod a+r+w -R data

### Run as a service

sudo vi /etc/systemd/system/zigbee2mqtt.service

### add

#####----------------------------------
[Unit]
Description=zigbee2mqtt
After=network.target

[Service]
ExecStart=/usr/bin/npm start
WorkingDirectory=/opt/zigbee2mqtt
StandardOutput=inherit
StandardError=inherit
Restart=always
User=jetson

[Install]
WantedBy=multi-user.target

#####----------------------------------
# Start Zigbee2MQTT
sudo systemctl start zigbee2mqtt

# Show status
systemctl status zigbee2mqtt.service

# Add on boot
sudo systemctl enable zigbee2mqtt.service

# status
systemctl status zigbee2mqtt.service


# View the log of Zigbee2MQTT
sudo journalctl -u zigbee2mqtt.service -f


## Config mqtthing HomeBridge plugin for Philips Motion seson

zigbee2mqtt/0x0017880108661c0a -> Baño
zigbee2mqtt/0x001788010865e676 -> Cocina
zigbee2mqtt/0x001788010865e72b -> Cuarto 
        {
            "accessory": "mqttthing",
            "type": "occupancySensor",
            "name": "PHILIPS Occupancy Studio",
            "topics": {
                "getOccupancyDetected": {
                    "topic": "zigbee2mqtt/0x001788010865e676",
                    "apply": "return JSON.parse(message).occupancy;"
                },
                "getBatteryLevel": {
                    "topic": "zigbee2mqtt/0x001788010865e676",
                    "apply": "return JSON.parse(message).battery;"
                }
            },
            "integerValue": true,
            "logMqtt": true
        },
        {
            "accessory": "mqttthing",
            "type": "temperatureSensor",
            "name": "PHILIPS Temperature Studio",
            "topics": {
                "getCurrentTemperature": {
                    "topic": "zigbee2mqtt/0x001788010865e676",
                    "apply": "return JSON.parse(message).temperature;"
                },
                "getBatteryLevel": {
                    "topic": "zigbee2mqtt/0x001788010865e676",
                    "apply": "return JSON.parse(message).battery;"
                }
            },
            "logMqtt": true
        },
        {
            "accessory": "mqttthing",
            "type": "lightSensor",
            "name": "PHILIPS Light Intensity Studio",
            "topics": {
                "getCurrentAmbientLightLevel": {
                    "topic": "zigbee2mqtt/0x001788010865e676",
                    "apply": "return Math.pow(10, (JSON.parse(message).illuminance - 1)/10000);"
                },
                "getBatteryLevel": {
                    "topic": "zigbee2mqtt/0x001788010865e676",
                    "apply": "return JSON.parse(message).battery;"
                }
            },
            "logMqtt": true
        }
        
        
/dev/ttyUSB.CC2531-01

        

