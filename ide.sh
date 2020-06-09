if [ "$1" = "" ]; then
    exit 0
fi

if [ "$2" = "" ]; then
    echo 'Plase set arg 2  workspace name'
fi
while read var value
do
    if [ "$var" != "" ]; then
        export "$var"="$value"
    fi
done < ~/vim-ide/workspaces/$2.conf

case $sourcecontroltype in
    tfs )
        case $1 in
            get )
                mkdir -p $HOME/$workdir
                cd $HOME/$workdir
                /bin/TEE/tf get -login:$user,$passwd -force -overwrite
                ;;
            connect )
                    /bin/TEE/tf workspace -new -collection:$server $2 -login:$user,$passwd
                    /bin/TEE/tf workfold -map -workspace:$2 $sourcedir $HOME/$workdir -login:$user,$passwd
                ;;
            open )
                  export TERM='screen-256color'
                  export "foundWindow"="'$(tmux list-windows -t ide_main | grep $2)'"
                  if [ "$foundWindow" = "''" ]; then
                      tmux new-session -A -s ide_main \; new-window -n $2 \; split-window -h -p 20 -t "$2.1" \; split-window -v -p 20 -t "$2.1" \; send-keys -t "$2.1" C-z "cd  ~"$workdir" && yes | vim" Enter \; send-keys -t "$2.3" C-z           "alias build='$buildcmd' && alias run='$runcmd'" Enter
                  else
                      tmux new-session -A -s ide_main
                  fi
                ;;
            test )
                ;;
            attach )
                    tmux new-session -A -s ide_main
                ;;
        esac
        ;;
    git )
        echo 'git client'
        ;;
esac


#if [ "$1" = "-getoverwrite" ]; then
#    cd $HOME/$workdir
#    /bin/TEE/tf get -login:$user,$passwd -force -overwrite
#fi
