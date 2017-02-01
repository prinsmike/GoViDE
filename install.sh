#!/bin/bash

echo -e '>> Initiating install.'

echo -e '>> Checking for Docker install and pulling image.'
if [ $(command -v docker) ]; then
	docker pull prinsmike/govide
else
	echo -e 'ERROR: Docker is not installed in your path.'
	exit 1
fi

echo -e '>> Setting up govide command, will require elevated privileges.'

cat > /tmp/govide <<EOF
#!/bin/bash

if [ \$(command -v docker) ]; then
	docker run --rm -tiv \${GOPATH}/src:/go/src -v ~/.ssh:/home/govide/.ssh prinsmike/govide
else
	echo -e 'This program requires Docker, please install docker'
fi
EOF

chmod +x /tmp/govide

sudo su -c "mv /tmp/govide /usr/local/bin/govide"

echo -e '>> Setup complete.'
echo -e '\n'
