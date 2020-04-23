## 前言
**这个项目是我第一次尝试接触操作系统的编写，期间也阅读了汇编语言王爽这本书**

现在跟着《一个64位操作系统的实现》这本书来走，但是里面的有些内容作者是没有解释清除的，所以学起来还是比较痛苦，但是万事开头难，今天尝试着自己把boot程序写出来了，虽然有很多bug和错误，但是最终经过bochs中的调试，修复了bug成功运行！

## Version 0.0.1
### 现在看到的boot程序有3个：
- hisboot.asm 这个源代码是我在读作者的源码的时候写上的注释，其中有一个读扇区的函数我没有写上注释，因为我感觉三言两语解释不清，所以感兴趣的朋友可以联系我讲解或者上网查资料

- boot.asm 这个是自己尝试写的boot程序，期间写不出来的时候时不时看了一下作者的源码

- myself.asm 这个是我在不看代码的情况下写的，期间修复了不少的错误。相当于巩固了一下知识吧

> 三个文件里面都有零零散散的注释，合在一起看会比较好

>里面的boot.bin是要写入软盘的，三个boot.bin文件写入软盘后，bochs启动显示的字符串颜色会不同来区分不同的源代码
