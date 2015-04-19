#!/bin/bash
#
# 什么都不加查看
# -t 时间
# -c 创建
# -i 添加
# -d 删除
# -s task 成功标记
## ###############
## plan long-plan to-do record task
## 默认task

time="today"
var=""
path=~/.record/`date -d $time +%Y%m%d`/

task_insert(){
    var='y'
    while (  expr x$var : "^x[yY]" >> /dev/null ); do
        echo -e "  添加待做事项"
        echo -n -e "\t时间:"
        read t_time
        #应该添加判断时间


        echo -n -e "\t事件:"
        read t_task

        echo -n -e "\t是否添加提醒[y/n]:"
        read notify
        ##写入at中
        atid=-1
        if ( expr $notify : "^[^nN]" >> /dev/null );then
            atid=`./at_expect.sh $t_time "notify-send -t 1000 待做事项 $t_task"`
            atid=`echo $atid|sed -n  "s/^.*job \([0-9]*\).*$/\1/p"`
        fi

        ##写入文件中
        if [ ! -d $path ]; then
            mkdir -p $path
        fi
        echo "$t_time $t_task $atid" >> ${path}/task.file

        echo -n -e "  是否继续[y/n]:"
        read var
    done
}

task_display(){
    echo ""
    echo " 今天的任务有："
    cat $path/task.file | awk '{if($4 == "ss"){print "    "$1,"完成  ",$2} else {
                                print "    "$1,"未完成",$2}}'
    echo ""
}

task_successed(){
    file=$path/task.file
    echo "请选择完成的任务"
    str=`awk '!/ss$/ {print $2}' $file`
    var="y"
    while ( expr x$var : "^x[yY]" >> /dev/null );do
        select var in $str;do
            if [ -z $var ];then
                echo "请选择正确编号"
            fi
            awk -e '{if($2 == var){print $0," ss"} else {print $0}}' var=$var $file >${file}.bak
            mv ${file}.bak $file
            str=`awk '!/ss$/ {print $2}' $file`
            break;
        done
        echo -n "是否继续[y/n]:"
        read var
    done
}

notify(){   
     notify-send -t 1000 $1 $2
}

#task_insert
task_display
#task_successed
