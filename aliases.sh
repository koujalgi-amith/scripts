# Setup command aliases
cat > ~/.bash_profile << EOF1
alias l='ls -al'

fkill_func() {
    PS_NAME=$1
    for pid in $(ps -ax | grep '$PS_NAME' | awk '{print $1;}');
    do
        kill -9 $pid;
    done
}
alias fkill=fkill_func
#alias fkill='for pid in $(ps -ax | grep -i \!* | awk '{print $1;}'); do kill -9 $pid; done'
EOF1
