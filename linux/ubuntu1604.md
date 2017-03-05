# 修改网卡名称
升级或者新安装了 ubuntu 16.04 之后,你会发现16.04 已经通过udev和systemd 管理的网卡命名.你ifconfig 下会发现eth0 变成了enp4s0f1 wlan0变成了wlp3s0.

由于相对比较旧的EDA工具，都只是识别出eth0这块网卡，所以我们有必要将enp4s0f1修改回eth0.

1, sudo vim /etc/default/grub
   给GRUB_CMDLINE_LINUX添加参数，"net.ifnames=0 biosdevname=0"。修改后如下：
    GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"
2, sudo update-grub 。更新grub的配置，因为修改了Bios中的命令方式，所以需要重启系统
3, sudo reboot

# rc.local
由于ubuntu的 /bin/sh 直接link到 dash （注意！不是bash）
1,所以在 rc.local中，要注意脚本语法的兼容性。
例如，dash是没有 'source' 这命令的。
例如：usr/bin/mystar >& /dev/null &         # dash报错，bash和csh不会报错
/usr/bin/mystar > /dev/null 2>&1     # dash兼容

/bin/sh -e
　　就是这个 -e ，只要任何一条命令出错，脚本就会停止执行。
2,将 /bin/sh 直接软链接回 /bin/bash
  ln -sf /bin/bash /bin/sh
