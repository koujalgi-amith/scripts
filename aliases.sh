# Setup command aliases
cat >> ~/.bash_profile << EOF1
alias l='ls -al'

fkill_func() {
    if [[ \$# -eq 0 ]]; then
	    echo "Process name not provided."
	    echo "Usage: fkill <process-name>"
	    return 0
    fi
    
    echo "Killing process by name '\$1'..."
    
    PS_NAME=\$1
    for pid in \$(ps -ef | grep \$PS_NAME | awk '{print \$2;}');
    do
        kill -9 \$pid;
    done
}
alias fkill=fkill_func
EOF1
