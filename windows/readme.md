## VS + OpenCV
opencv_x64_debug.props
opencv_x64_release.props

这两文件使用硬链接，连接到对应 opencv 版本的配置。相应的脚本如下（放弃）：
mklink /h opencv_x64_debug.props opencv4501_x64_debug.props
mklink /h opencv_x64_release.props opencv4501_x64_release.props
这两文件使用软链接，连接到对应 opencv 版本的配置。相应的脚本如下（使用管理员的权限，即可创建）：
mklink opencv_x64_debug.props opencv4501_x64_debug.props
mklink opencv_x64_release.props opencv4501_x64_release.props

## GZ服务器端口映射：
### 步骤一
方法一：在本地网络，ipv4 属性里面->高级-> 添加多个IP地址。（不稳定，不建议）
方法二：在设备管理器中->添加过时设备->网络适配器->Microsoft KM-TEST 环回适配器。之后配置好IP即可，不要配置 网关。
### 步骤二
netsh interface portproxy add v4tov4 listenaddress=10.0.0.2 listenport=445 connectaddress=192.168.0.20 connectport=446
netsh interface portproxy add v4tov4 listenaddress=10.0.0.3 listenport=445 connectaddress=192.168.0.20 connectport=447
使用 netsh xxx delete xxxx 可以删除本地端口映射