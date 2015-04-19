#!/bin/bash
#
# 登陆新集群 可以输入集群节点编号
# 也可以使用ip的最后一位
# 
# 参数 $1   登陆的节点

if [ $# == 1 ];then
    if [ $1 -lt 40 ] ; then
        host=jfg6bcetl$1
    else
        host='10.180.168.'$1
    fi
else 
    host=jfg6bcetl5
fi

auto_login_ssh () {
        expect -c "set timeout -1;
            spawn -noecho ssh -o StrictHostKeyChecking=no $2
            ${@:3};
            expect *assword:*;
            send -- $1\r;
            interact;";
}
                                                                     
auto_login_ssh hdfs hdfs@$host
