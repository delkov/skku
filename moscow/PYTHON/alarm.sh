#!/bin/bash

# время по умолчанию
tm="16:41"

# громкость
volume=10
volume_max=50
# путь к папке с медиафайлами, или к медиафайлу.
folder="/home/delkov/Music/*"
mplayer_start()
{
    # убиваем все процессы mplayer-а
    id=(`ps al | grep [m]player | gawk '{print $3}'`)
    for job in ${id[*]} ; do
        kill -9 $id
    done
    
    # включаем случайную мелодию с бесконечным повтором
    if [ -z "$1" ] ; then
        # mplayer -loop 0 -shuffle $folder &> /dev/null &
    mplayer -loop 0 $folder &
    fi
}

# позволяет вводить время в качестве первого параметра
# ./xxx.sh 16:41

    if [[ "$1" == [0-9]:[0-9][0-9] ]] || [[ "$1" == [0-9][0-9]:[0-9][0-9] ]] ; then
        tm=$1
    fi

date1=$(date -d "`date +%m/%d/%y` $tm" +%s)
date2=$(date -d "`date +%m/%d/%y` $tm tomorrow" +%s)

if [[ $date1 < `date -u +%s` ]] ; then
    date=$(echo $[$date2-`date -u +%s`])
else
    date=$(echo $[$date1-`date -u +%s`])
fi

# засыпаем
sudo rtcwake -m mem -s $date

# устанавливаем громкость
amixer -q set Master $volume%



echo "нажмите ENTER для выключения"
mplayer_start

# повышаем уровень громкости
while true ; do
    amixer sset Master 1%+ &> /dev/null
    volume=$(( $volume+1 ))
    
    if [ $volume -eq $volume_max ] ; then
        break
    fi
    sleep 1 # задержка повышения громкости
done &

read;
mplayer_start false