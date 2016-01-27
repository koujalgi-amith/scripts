#!/bin/bash

# install geary mail client
sudo apt-get install -y geary

# install gradle
sudo add-apt-repository -y ppa:cwchien/gradle
sudo apt-get update
sudo apt-get install -y gradle-ppa
