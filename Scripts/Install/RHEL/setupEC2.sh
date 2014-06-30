#!/bin/bash

echo "This will create a EC2.sh file that will contain the correct environment \
variables for EC2."
echo "THIS WILL OVERWRITE ANY EXISTING EC2.sh. QUIT NOW (Ctrl-C) TO KEEP YOUR \
current one"

echo "What is your AWS Access Key ID?"
read aws_AKID
echo "What is your AWS Secret Access Key?"
read aws_SAK
echo "What is your AWS Keypair Name?"
read aws_KN
echo "What is the path to your AWS Private Key"
read aws_PK

# Build bash file to source Vagrant variables from
echo "#!/bin/bash" > EC2.sh
echo export AWS_ACCESS_KEY_ID="$aws_AKID" >> EC2.sh
echo export AWS_SECRET_ACCESS_KEY="$aws_SAK" >> EC2.sh
echo export AWS_KEYPAIR_NAME="$aws_KN" >> EC2.sh
echo export AWS_PRIVATE_KEY="$aws_PK" >> EC2.sh

echo You may now source EC2.sh to setup the required variables
