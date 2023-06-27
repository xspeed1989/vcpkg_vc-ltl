# 描述

[vcpkg](https://github.com/microsoft/vcpkg)是微软出品的一款跨平台的C++包管理器，可以一键编译所需第三方库,

[VC-LTL](https://github.com/Chuyu-Team/VC-LTL5)是一个基于微软VC修改的开源运行时，有效减少应用程序体积并摆脱微软运行时DLL依赖

本仓库结合VC-LTL和VCPKG，让VCPKG编译的库自动使用VC-LTL

# 使用方法

例子：编译64位版本的curl，并使用VC-LTL优化运行时

```bash
git clone git@github.com:xspeed1989/vcpkg_vc-ltl.git
cd vcpkg_vc-ltl
./vcpkg install curl:x64-ltl-dll-mt
```

**注意： 这里比官方仓库少了调用bootstrap-vcpkg.bat的步骤，原因是vcpkg原版exe会检测过期crt，所以我对vcpkg.exe源码进行了修改，修改版源码仓库：[vcpkg-tool](https://github.com/xspeed1989/vcpkg-tool)**

支持的vcpkg triplet：

* **x64-ltl-dll-mt**
* **x64-ltl-static-mt**
* **x86-ltl-dll-mt**
* **x86-ltl-static-mt**