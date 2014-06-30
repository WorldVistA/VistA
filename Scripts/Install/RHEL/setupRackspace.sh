#!/bin/bash

echo "This will create a Rackspace.sh file that will contain the correct \
environment variables for Rackspace."
echo "THIS WILL OVERWRITE ANY EXISTING Rackspace.sh. QUIT NOW (Ctrl-C) TO KEEP \
YOUR current one"

echo "What is your Rackspace User Name?"
read rs_USERNAME
echo "What is your Rackspace API Key?"
read rs_APIKEY
echo "What is the path to your Rackspace Public Key?"
read rs_PUBKEY
echo "What is the path to your Rackspace Private Key"
read rs_PRIVATEKEY

# Build bash file to source Vagrant variables from
echo "#!/bin/bash" > Rackspace.sh
echo export RS_USERNAME="$rs_USERNAME" >> Rackspace.sh
echo export RS_API_KEY="$rs_APIKEY" >> Rackspace.sh
echo export RS_PUBLIC_KEY="$rs_PUBKEY" >> Rackspace.sh
echo export RS_PRIVATE_KEY="$rs_PRIVATEKEY" >> Rackspace.sh

echo You may now source Rackspace.sh to setup the required variables
