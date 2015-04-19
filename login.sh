#!/bin/bash
#
# 登陆集群 默认登陆node2
# 
# 参数 $1   登陆的节点

host=node2
if [ $# == 1 ] ; then
    host=$1
fi
auto_login_ssh () {
        expect -c "set timeout -1;
            spawn -noecho ssh -o StrictHostKeyChecking=no $2
            ${@:3};
            expect *assword:*;
            send -- $1\r;
            interact;";
}
                                                                     
auto_login_ssh cloudetl hadoop@$host
