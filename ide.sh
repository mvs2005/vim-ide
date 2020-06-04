while read var value
do
    export "$var"="$value"
done < ~/vim-ide/ide.conf

echo "$server"
echo "$user"
echo "$passwd"
echo "$workDir"
echo "$sourceDir"
