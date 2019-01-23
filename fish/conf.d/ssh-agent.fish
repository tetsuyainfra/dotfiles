# if it does not exist, create the file
setenv SSH_ENV $HOME/.ssh/environment

set -x SSH_AGENT_EXEC ssh-agent
set -x SSH_AGENT_ARGS ""
if which weasel-pageant > /dev/null ;
  echo use weasel-pageant
  set -x SSH_AGENT_EXEC (which weasel-pageant)
  set -x SSH_AGENT_ARGS -r -S fish
else if which ssh-agent-wsl > /dev/null ;
  echo use ssh-agent-wsl with Microsoft ssh-agent service
  set -x SSH_AGENT_EXEC (which ssh-agent-wsl)
  set -x SSH_AGENT_ARGS -r -S fish
end

function start_agent
    echo "Initializing new SSH agent ..."
    $SSH_AGENT_EXEC $SSH_AGENT_ARGS | sed 's/^echo/#echo/' > $SSH_ENV
    echo "succeeded"
    chmod 600 $SSH_ENV 
    . $SSH_ENV > /dev/null
    ssh-add
end

function test_identities
    ssh-add -l | grep "The agent has no identities" > /dev/null
    if [ $status -eq 0 ]
        ssh-add
        if [ $status -eq 2 ]
            start_agent
        end
    end
end

if [ -n "$SSH_AGENT_PID" ] 
    ps -ef | grep $SSH_AGENT_PID | grep $SSH_AGENT_EXEC > /dev/null
    if [ $status -eq 0 ]
        test_identities
    end  
else
    if [ -f $SSH_ENV ]
        . $SSH_ENV > /dev/null
    end  
    ps -ef | grep "$SSH_AGENT_PID" | grep -v grep | grep $SSH_AGENT_EXEC > /dev/null
    if [ $status -eq 0 ]
        test_identities
    else 
        start_agent
    end  
end
