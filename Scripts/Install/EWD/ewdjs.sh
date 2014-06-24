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
nodever="0.10"
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
su $instance -c "source $basedir/.profile && nvm install $nodever && nvm alias default 0.10 && nvm use default"

# Put it in the profile too
echo "nvm use $nodever" >> $basedir/.profile

# Create directories for node
su $instance -c "source $basedir/etc/env && mkdir $basedir/ewdjs"

# Install required node modules
cd $basedir/ewdjs
su $instance -c "source $basedir/.profile && source $basedir/etc/env && npm install --quiet nodem >> $basedir/log/nodemInstall.log"
su $instance -c "source $basedir/.profile && source $basedir/etc/env && npm install --quiet ewdjs >> $basedir/log/ewdjsInstall.log"
su $instance -c "source $basedir/.profile && source $basedir/etc/env && npm install --quiet ewdliteclient >> $basedir/log/ewdliteclientInstall.log"
su $instance -c "source $basedir/.profile && source $basedir/etc/env && npm install --quiet ewdrest >> $basedir/log/ewdrestInstall.log"
su $instance -c "source $basedir/.profile && source $basedir/etc/env && npm install --quiet ewdvistaterm >> $basedir/log/ewdvistatermInstall.log"

# Copy the right mumps$shortnodever.node_$arch
su $instance -c "cp $basedir/ewdjs/node_modules/nodem/lib/mumps"$shortnodever".node_$arch $basedir/ewdjs/mumps.node"
su $instance -c "mv $basedir/ewdjs/node_modules/nodem/lib/mumps"$shortnodever".node_$arch $basedir/ewdjs/node_modules/nodem/lib/mumps.node"

# Copy any routines in ewdjs
su $instance -c "find $basedir/ewdjs/node_modules/ewdjs -name \"*.m\" -type f -exec cp {} $basedir/p/ \;"

# Setup GTM C Callin
# with nodem 0.3.3 the name of the ci has changed. Determine using ls -1
calltab=$(ls -1 $basedir/ewdjs/node_modules/nodem/resources/*.ci)
echo "export GTMCI=$calltab" >> $basedir/etc/env
# Ensure nodem routines are in gtmroutines search path
echo "export gtmroutines=\"\${gtmroutines}\"\" \"\$basedir/ewdjs/node_modules/nodem/src" >> $basedir/etc/env

# Create ewd.js config
cat > $basedir/ewdjs/node_modules/OSEHRA-Config.js << EOF
module.exports = {
  setParams: function() {
    return {
      ssl: true
    };
  }
};
EOF

# Ensure correct permissions
chown $instance:$instance $basedir/ewdjs/node_modules/OSEHRA-Config.js

# Use EWD.js installer
su $instance -c "source $basedir/.profile && source $basedir/etc/env && cd $basedir/ewdjs/node_modules/ewdjs && node install silent >> $basedir/log/ewdInstall.log"

# Perform renames to ensure paths are right
perl -pi -e 's#/home/ubuntu#'$basedir'#g' $basedir/ewdjs/node_modules/ewdjs/OSEHRA/*.js
su $instance -c "cp $basedir/ewdjs/node_modules/ewdjs/OSEHRA/*.js $basedir/ewdjs/node_modules/"
perl -pi -e 's#'$basedir'/mumps#'$basedir'/ewdjs/mumps#g' $basedir/ewdjs/node_modules/ewdjs/OSEHRA/*.js

# VistATerm setup
su $instance -c "cp $basedir/ewdjs/node_modules/ewdjs/OSEHRA/VistATerm.js $basedir/ewdjs/node_modules/"
su $instance -c "mkdir $basedir/ewdjs/ewdVistATerm"
su $instance -c "cp -r $basedir/ewdjs/node_modules/ewdvistaterm/terminal/* $basedir/ewdjs/ewdVistATerm"
su $instance -c "cp $basedir/ewdjs/node_modules/ewdjs/OSEHRA/VistATerm.js $basedir/ewdjs"
perl -pi -e 's#'$basedir'/ssl/#'$basedir'/ewdjs/ssl/#g' $basedir/ewdjs/VistATerm.js
perl -pi -e 's#'$basedir'/www#'$basedir'/ewdjs#g' $basedir/ewdjs/VistATerm.js

# ewdRest setup
su $instance -c "cp $basedir/ewdjs/node_modules/ewdjs/OSEHRA/ewdRest.js $basedir/ewdjs"
perl -pi -e 's#'$basedir'/ssl/#'$basedir'/ewdjs/ssl/#g' $basedir/ewdjs/ewdRest.js

# Install webservice credentials
su $instance -c "cp $basedir/ewdjs/node_modules/ewdjs/OSEHRA/registerWSClient.js $basedir/ewdjs"
# delete the require('gtm-config') line (only used for ewdjs-gtm standalone install
perl -pi -e "s#require\(\'gtm-config\'\);# #g" $basedir/ewdjs/registerWSClient.js
su $instance -c "source $basedir/.profile && source $basedir/etc/env && cd $basedir/ewdjs && node registerWSClient.js"

# Modify init.d scripts to reflect $instance
perl -pi -e 's#/home/foia#'$basedir'#g' $basedir/etc/init.d/ewdjs

# Create startup service
ln -s $basedir/etc/init.d/ewdjs /etc/init.d/${instance}vista-ewdjs

# Install init script
update-rc.d ${instance}vista-ewdjs defaults

echo "Done installing EWD.js"
service ${instance}vista-ewdjs start
