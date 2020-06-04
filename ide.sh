while read var value
do
    export "$var"="$value"
done < ~/vim-ide/workspaces/$2.conf

if [ "$1" = "--connect" ]; then
    /bin/TEE/tf workspace -new -collection:$server $2
    /bin/TEE/tf workfold -map -workspace:$2 $sourcedir $workdir
fi

if [ "$1" = "--get" ]; then
    cd $HOME/$workdir
    /bin/TEE/tf get -login:$user,$passwd -force
fi

if [ "$1" = "-getoverwrite" ]; then
    cd $HOME/$workdir
    /bin/TEE/tf get -login:$user,$passwd -force -overwrite
fi
