/**
 * author:Leng Tingxue
 * time:2017/11/4
 * doc:
 *  ts官网：http://www.tslang.cn/docs/handbook/declaration-merging.html
 *  安装node.js 安装npm包管理器，安装typescript，运行命令 tsc *.ts
 *  url :http://www.runoob.com/w3cnote/getting-started-with-typescript.html
 */

/**
 * 实例
 * 实例属性[boolean|string|number]
 * @param left 字段
 * @param right 字段
 * @returns {number} 返回值类型
 * @constructor
 */
function numAdd(left:number, right:number):number {
    return left + right;
}
console.log(numAdd(1, 2));

/**
 * 接口
 */
interface Shape {
    name:string;
    width:number;
    height:number;
}
/**
 * 使用接口 shape:Shape
 * @param shape
 */
function area(shape:Shape):number {
    if (shape.name === "square") {
        return shape.width * shape.height;
    }
    return 0;
}
//初始化接口，参数必须全部填上
let square = {
    name: "square",
    width: 12,
    height: 12
}
console.log("定义接口，使用接口，初始化接口" + area(square));
//=============================================================
/**
 *箭头函数就是function的简写
 */

var shape = {
    name: "rectangle",
    popup: function () {
        console.log('This inside popup(): ' + this.name);
        setTimeout(function () {
            console.log('function函数中获取名称为：' + this.name);
        }, 3000);//使用.bind(this)，能获取的外面的数据
    }
};
shape.popup();

var shape1 = {
    name: "rectangle",
    popup: function () {
        setTimeout(() => {
            console.log("=>函数中获取名称为：" + this.name)
        }, 3000)
    }
};
shape1.popup();
// js运行时代码
// var shape1 = {
//     name: "rectangle",
//     popup: function () {
//         var _this = this; //<==看这里,定义了一个全局变量
//         setTimeout(function () {
//             console.log("=>函数中获取名称为：" + _this.name);
//         }, 3000);
//     }
// };

/**
 * 定义类
 */
class TestClass1 {
    name:string;
    age:number;
    //构造函数
    constructor(name:string, age:number) {
        this.name = name;
        this.age = age;
    }

    //方法,不写就默认转
    sayHello():string {
        return "hello:" + this.age + ":" + this.name;
    }
}
console.log(new TestClass1("beyond", 11).sayHello());

/**
 * 类继承
 */
class TestClass2 extends TestClass1 {
    location:string;
    constructor(name:string, age:number,location:string) {
        super(name,age);
        this.location =location;
    }
    sayHello():string {
        return super.sayHello()+":location="+this.location;
    }
}
console.log(new TestClass2("aaa",111,"hz").sayHello());
















