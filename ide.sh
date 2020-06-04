while read var value
do
    export "$var"="$value"
done < ~/vim-ide/ide.conf
