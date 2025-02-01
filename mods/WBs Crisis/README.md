# [FNF Mod] - WB's Crisis
## 模组名称问题
* 虽然主创曾把模组名称改成`血腥华纳`（* The Blood WB），而且本库也有一段时间使用过此名
* 但由于对外宣传以及其他方面名称仍是`华纳的危机`（* WB,s Crisis）
* 所以在`demo`发行前模组名字仍然叫`华纳的危机`（* WB,s Crisis）
* `血腥华纳`（* The Blood WB）属于别称
## 模组介绍
本模组abab......等`z杨`来介绍吧
![](https://github.com/VapireMox/The-blood-WB--By-CNE/blob/YourDad/source/场景草稿.jpg)
![笑话](https://github.com/VapireMox/The-blood-WB--By-CNE/blob/YourDad/source/Image_38517362154756.png)
![](https://github.com/VapireMox/The-blood-WB--By-CNE/blob/YourDad/source/一阶段.png)

## 关于进度
`【歌曲】`已完成1942

`【谱子】`already done

`【绘画】` will done

`【编程】`开始

## 交代给编程人员的

### 请开启各自的分支，最后我会合并
关于分支的问题，不是让你填充库，是让你开分支，`create new branch!!!`

### About CNE Version Trouble（关于版本问题）
请统一使用下面链接的`Codename Engine`版本

[电脑版（windows）](https://nightly.link/CodenameCrew/CodenameEngine/workflows/windows/main/Codename%20Engine.zip)

[手机版(android)](https://nightly.link/MobilePorting/CodenameEngine-Mobile/workflows/android/cne-pr/Codename%20Engine.zip)

### Mod Addons（模组组件）
#### 简介
用于解决编程方面的一些儿琐事， 或是让某些东西变得便利化，这得得力于`cne制作组`对于hscript所开发的`class结构体`，如果想想制作一份addons，可以尝试在`addons`文件夹下新建一份脚本，使用`class结构体`即可

#### usage（用法）
```haxe
//想利用addons，必须使用importAddons函数，引入操作与haxe本尊class导入差不多，可看以下操作
importAddons("Point");
importAddons("Point.Point3D");

/**
 * 如果想导入全部文件里的class，可以使用*，玩源码的应该都熟悉
 * importAddons("Point.*");
 */

function create() {
    var point:Point = new Point(1, 1);
    var point3D:Point3D = new Point3D(1, 1, 1);
}
```
#### 缺陷
* 暂时不能在addons文件夹新建一个文件出来，可能会搞出bug来
  
* 无法在本模组的`data/global.hx`脚本以及`data/addonsManager.hx`脚本使用函数`importAddons`，因为他们是这些事物的造物主

### Mod Shader（模组着色器）
#### 问候
别再找`chara`给老子（YourDad）！别往shaders装着色器文件！！想添加着色器到`addons/shader.hx`文件里

#### 如何添加
首先，你得创建一个新的class，想进行其他不可描述的事物的话，可以继承`flixel.FlxBasic`

可看以下模板：
```haxe
//里面的无论函数还是变量，都需要有public修饰符，这很重要！！！
class TestShader extends FlxBasic {
    public var shaderCode:String;
    public var shader:String;

    //如果有uniform可以在这里添加uniform对应的变量，然后再定义set_变量名的函数

    public function new() {
        //如果使用get_xxx()方法的话，需要添加this
        shader = new FunkinShader(this.shaderCode);

        //在这里还需要定义平常值
        // 变量名 = 平常值;
        // shader.变量名 = 变量名;
    }

    /**
        如果想在class内直接定义可能在游戏内造成影响的函数（etc. update），使用的变量名必须添加this，否则无法对其shader里的变量正真的修改
        public override function update(elapsed:Float) {
            this.变量名 += elapsed;
        }
    **/

    /**
        关于set_函数的写法，可以是这样，最好可以保持这样的
        public function set_变量名(val:Float) {
            变量名 = val;
            shader.变量名 = 变量名;
            return 变量名;
        }
    **/

    public function get_shaderCode():String {
        return "着色器代码";
    }
}
```
至于调用可看[Mods Addons](https://github.com/VapireMox/The-blood-WB--By-CNE?tab=readme-ov-file#mod-addons%E6%A8%A1%E7%BB%84%E7%BB%84%E4%BB%B6)的介绍
