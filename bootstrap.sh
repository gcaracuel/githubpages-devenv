#!/bin/bash --login

CLONEREPO='https://github.com/gcaracuel/gcaracuel.github.io.git'
CLONEDIR="/vagrant/$(basename $CLONEREPO)"

# Install the need software
sudo apt-get update --assume-yes > /dev/null

sudo apt-get install -y vim curl git-core nodejs python-software-properties software-properties-common

curl -sL https://deb.nodesource.com/setup | sudo bash -

gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
   \curl -sSL https://get.rvm.io | bash -s stable --ruby

source ~/.rvm/scripts/rvm

fingerprint="$(ssh-keyscan -H github.com)"
if ! grep -qs "$fingerprint" ~/.ssh/known_hosts; then
   echo "$fingerprint" >> ~/.ssh/known_hosts
fi

# If your project is not present (you are about to start development) then clone, if not work on your folder!
if [[ ! -d "$CLONEDIR" ]]; then
        git clone "$CLONEREPO" "$CLONEDIR"
fi

gem install bundle

# Build and launch the Jekyll project
cd $CLONEDIR
/home/vagrant/.rvm/gems/ruby-2.2.1@global/bin/bundle install
nohup /home/vagrant/.rvm/gems/ruby-2.2.1/bin/jekyll serve --force_polling  &> /dev/null &

echo "Server built. Use your project folder on the Vagranfile directory (shared to /vagran/ in the guest). To run again Jekyll use: nohup /home/vagrant/.rvm/gems/ruby-2.2.1/bin/jekyll serve --force_polling  &> /dev/null &"
