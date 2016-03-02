# Setup command aliases
cat > ~/.bash_profile << EOF1
alias l='ls -al'
alias fkill=for pid in $(ps -ax | grep !:1 | awk '{print $1;}'); do kill -9 $pid; done
EOF1
