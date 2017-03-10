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

# libtiff.so.3
  由于EDA工具使用了比较旧的工具库，所以需要从 /usr/lib/x86_64.../libtiff.so.5 软链接过去

# libmng.so.1
  由于EDA工具使用了比较旧的工具库，所以需要从 /usr/lib/x86_64.../libmng.so.2 软链接过去

# libXi.so.6
  由于 incisiv 是采用了 32bit的 libXi.so.6, 而目前的 ubuntu 一般都是64 bit的啦。所以有点问题：
  Ubuntu 13.10 以及 以後的發行版 64 bit 都是 multiarch意思是 如果你要從 Ubuntu 13.10 套件庫 安裝任何 32 bit 套件直接安裝 32 bit 套件就可以不必事先額外安裝任何套件

```
  sudo dpkg --add-architecture i386
  sudo apt update
  sudo apt install libxi6:i386
```

# 安装 gcc 4.4
  Synopsys 的 EDA 工具，有些是采用 ReadHat 4 编译而来的，而且运行其工具时，也经常要使用到相对比较老版本的 gcc 4.4。所以要安装 gcc 4.4
  例如：VCS，此时的可以采用 cadence 的 IES 来暂时代替。

# beyond compare 4
  做好备份工作
cd /usr/lib64/beyondcompare
cp BCompare BCompare.bak

  采用 sed 进行破解
```
sed -i "s/keexjEP3t4Mue23hrnuPtY4TdcsqNiJL-5174TsUdLmJSIXKfG2NGPwBL6vnRPddT7tH29qpkneX63DO9ECSPE9rzY1zhThHERg8lHM9IBFT+rVuiY823aQJuqzxCKIE1bcDqM4wgW01FH6oCBP1G4ub01xmb4BGSUG6ZrjxWHJyNLyIlGvOhoY2HAYzEtzYGwxFZn2JZ66o4RONkXjX0DF9EzsdUef3UAS+JQ+fCYReLawdjEe6tXCv88GKaaPKWxCeaUL9PejICQgRQOLGOZtZQkLgAelrOtehxz5ANOOqCaJgy2mJLQVLM5SJ9Dli909c5ybvEhVmIC0dc9dWH+/N9KmiLVlKMU7RJqnE+WXEEPI1SgglmfmLc1yVH7dqBb9ehOoKG9UE+HAE1YvH1XX2XVGeEqYUY-Tsk7YBTz0WpSpoYyPgx6Iki5KLtQ5G-aKP9eysnkuOAkrvHU8bLbGtZteGwJarev03PhfCioJL4OSqsmQGEvDbHFEbNl1qJtdwEriR+VNZts9vNNLk7UGfeNwIiqpxjk4Mn09nmSd8FhM4ifvcaIbNCRoMPGl6KU12iseSe+w+1kFsLhX+OhQM8WXcWV10cGqBzQE9OqOLUcg9n0krrR3KrohstS9smTwEx9olyLYppvC0p5i7dAx2deWvM1ZxKNs0BvcXGukR+/g" BCompare
```
  禁止bcompare联网查 license
add "127.0.0.1 scootersoftware.com" to /etc/hosts

  再上网找 license
license:
3VBz7pP0AZAbbQAFMVJp3VrZUPEVdJlv4OC9baY5mDS-Xah45ux44fRLN
4fnBq46aUftmLNsYiwyayebJk2rMfSstmAgavsqoQfFLyHTOY94ozKYF1
-ODbBigieKGqgGpNMOLFdtdB08FZy7P252sh1X4UbUoH8xWIlz6D0dfPM
FaC7vXnDP4-Ck1A6K0CaCSVbcrWoWTmlPqKvRVu9wlNvV1KGr3C+GVf2e
dawekH3EbiE2Nkxz5fDaoQetwPEVU+GDdOF1zhrytrdICBnTQkkSE5UvJ
DGGx38l6PQ13BoaBW2hSHy5xxk4M8cfIcLTM7fOGfBBY5mRhe5aLoZQCU

