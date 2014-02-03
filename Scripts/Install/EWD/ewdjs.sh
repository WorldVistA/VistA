#!/usr/bin/env bash
#---------------------------------------------------------------------------
# Copyright 2011-2014 The Open Source Electronic Health Record Agent
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#---------------------------------------------------------------------------

# Script to install EWD.js (or EWDLite)

# Ensure presence of required variables
if [[ -z $instance && $gtmver && $gtm_dist && $basedir ]]; then
    echo "The required variables are not set (instance, gtmver, gtm_dist)"
fi

# Set the node version
nodever="0.10.25"
shortnodever="10"

# set the arch
arch=$(uname -m | tr -d _)

# This should be ran as the instance owner to keep all of VistA together
if [[ -z $basedir ]]; then
    echo "The required variable \$instance is not set"
fi

echo "Installing ewd.js"

# Copy init.d scripts to VistA etc directory
su $instance -c "cp -R etc $basedir"

# Download installer in tmp directory
cd $basedir/tmp

# Install node.js using NVM (node version manager)
echo "Downloading NVM installer"
curl -k --remote-name --progress-bar -L  https://raw.github.com/creationix/nvm/master/install.sh
echo "Done downloading NVM installer"

# Execute it
chmod +x install.sh
su $instance -c "./install.sh"

# Remove it
rm -f ./install.sh

# move to $basedir
cd $basedir

# Install node
su $instance -c "source $basedir/.profile && nvm install $nodever"

# Put it in the profile too
echo "nvm use $nodever" >> $basedir/.profile

# Create directories for node
su $instance -c "source $basedir/etc/env && mkdir $basedir/node"

# Install required node modules
cd $basedir/node
su $instance -c "source $basedir/.profile && source $basedir/etc/env && npm install --quiet nodem >> $basedir/log/nodemInstall.log"
su $instance -c "source $basedir/.profile && source $basedir/etc/env && npm install --quiet ewdgateway2 >> $basedir/log/ewdgateway2Install.log"
su $instance -c "source $basedir/.profile && source $basedir/etc/env && npm install --quiet ewdliteclient >> $basedir/log/ewdliteclientInstall.log"
su $instance -c "source $basedir/.profile && source $basedir/etc/env && npm install --quiet ewdrest >> $basedir/log/ewdrestInstall.log"

# Link items from node_modules to their places
su $instance -c "ln -s $basedir/node/node_modules/ewdgateway2/ewdLite/www/ewd $basedir/www/ewd"
su $instance -c "ln -s $basedir/node/node_modules/ewdgateway2/ewdLite/www/ewdLite $basedir/www"
su $instance -c "ln -s $basedir/node/node_modules/ewdgateway2/ewdLite/www/js $basedir/www/js"
su $instance -c "ln -s $basedir/node/node_modules/ewdgateway2/ewdLite/ssl $basedir/ssl"

# Need to pull out backend files to node_modules
su $instance -c "ln -s $basedir/node/node_modules/ewdgateway2/ewdLite/node_modules/*.js $basedir/node/node_modules"

# Move webservice backend files to node directory
su $instance -c "ln -s $basedir/node/node_modules/ewdgateway2/ewdLite/OSEHRA/*.js $basedir/node"

# Perform renames to ensure paths are right
perl -pi -e 's#/home/ubuntu#'$basedir'#g' $basedir/node/*.js
perl -pi -e 's#'$basedir'/mumps#'$basedir'/node/mumps#g' $basedir/node/*.js

# Copy the right mumps$shortnodever.node_$arch
su $instance -c "cp $basedir/node/node_modules/nodem/lib/mumps"$shortnodever".node_$arch $basedir/node/mumps.node"

# Copy any routines in ewdgateway2
su $instance -c "find $basedir/node/node_modules/ewdgateway2 -name \"*.m\" -type f -exec cp {} $basedir/p/ \;"

# Setup GTM C Callin
echo "export GTMCI=\$basedir/node/node_modules/nodem/resources/calltab.ci" >> $basedir/etc/env
echo "export gtmroutines=\"\$basedir/node/node_modules/nodem/src \"\${gtmroutines}\"\"" >> $basedir/etc/env

# Create ewd startup script
cat > $basedir/node/ewdStart.js << EOF
var ewd = require('ewdgateway2');
var params = {
      poolSize: 2,
      httpPort: 8080,
       https: {
         enabled: true,
         keyPath: "$basedir/ssl/ssl.key",
         certificatePath: "$basedir/ssl/ssl.crt",
      },
      database: {
        type: 'gtm',
        nodePath: "$basedir/node/mumps"
      },
      lite: true,
      modulePath: '$basedir/node/node_modules',
      traceLevel: 3,
      webServerRootPath: '$basedir/www',
      logFile: '$basedir/log/ewdLog.txt',
      management: {
        password: 'keepThisSecret!'
     }
};
ewd.start(params);
EOF

# Ensure correct permissions
chown osehra:osehra $basedir/node/ewdStart.js

# Install webservice credentials
su $instance -c "source $basedir/.profile && source $basedir/etc/env && node $basedir/node/registerWSClient.js"

# Modify init.d scripts to reflect $instance
perl -pi -e 's#/home/foia#'$basedir'#g' $basedir/etc/init.d/ewdjs

# Create startup service
ln -s $basedir/etc/init.d/ewdjs /etc/init.d/${instance}vista-ewdjs

# Install init script
update-rc.d ${instance}vista-ewdjs defaults

echo "Done installing EWD.js"
service ${instance}vista-ewdjs start
