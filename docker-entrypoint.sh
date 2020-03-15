#!/bin/bash

variables=(
	"autobanAttempts"
	"autobanTimeframe"
	"autobanTime"
	"welcometext"
	"serverpassword"
	"bandwidth"
	"users"
	"opusthreshold"
	"channelnestinglimit"
	"channelname"
	"username"
	"textmessagelength"
	"imagemessagelength"
	"allowhtml"
	"logdays"
	"registerName"
	"registerPassword"
	"registerUrl"
	"registerHostname"
	"bonjour"
	"sendversion"
	"certrequired"
)

# cert lookup
if [[ $(find /var/lib/murmur/certs/ -name *.crt -or -name *.pem | wc -l) == "1" ]]; then
	sslCert=$(find /var/lib/murmur/certs/ -name *.crt -or -name *.pem);
	echo "There is only one *.crt or *.pem file on certs directory: ${sslCert}. Assuming  that it is our certificate.";
fi
	

# key lookup
if [[ $(find /var/lib/murmur/certs/ -name *.key | wc -l) == "1" ]]; then
	sslKey=$(find /var/lib/murmur/certs/ -name *.key);
	echo "There is only one *.key file in certs directory: ${sslKey}. Assuming  that it is our certificate key.";
fi
	

if [ ! -z ${sslKey+x} ] && [ ! -z ${sslCert+x} ] && [ -f "${sslKey}" ] && [ -f "${sslCert}" ]; then
	SSLKEY=$(echo $sslKey | sed 's_/_\\/_g');
	SSLCERT=$(echo $sslCert | sed 's_/_\\/_g');
	variables+=("sslKey");
	variables+=("sslCert");
else 
	echo "Self-signed certificate key will be generated";
fi

for var in "${variables[@]}"; do
	var="${var^^}";
	if [ -z ${!var+x} ]; then
		continue;
	fi
	echo "Setting config parameter ${var,,}=${!var}...";
	sed --in-place --regexp-extended "s/^[#;]?(${var})=(.*)$/\1=${!var}/gi" /etc/murmur.ini
done

if [ ! -z ${MUMBLE_SUPW+x} ]; then
	murmurd -supw $MUMBLE_SUPW;
fi

echo "Starting mumble-server..."
murmurd -fg
