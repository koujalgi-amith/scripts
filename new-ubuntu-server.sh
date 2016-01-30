#!/bin/bash

# install maven
sudo apt-get install -y maven

# install gradle
sudo add-apt-repository -y ppa:cwchien/gradle
sudo apt-get update
sudo apt-get install -y gradle-ppa

sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-set-default
sudo apt-get install oracle-java8-installer

sudo apt-get install -y subversion
sudo apt-get install -y git
