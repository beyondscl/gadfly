/**
 * author:Leng Tingxue
 * time:2017/11/4
 * doc:
 *  ts官网：http://www.tslang.cn/docs/handbook/declaration-merging.html
 *  安装node.js 安装npm包管理器，安装typescript，运行命令 tsc *.ts
 *  url :http://www.runoob.com/w3cnote/getting-started-with-typescript.html
 */
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];

    function __() {
        this.constructor = d;
    }

    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};

/**
 * 实例
 * 实例属性[boolean|string|number]
 * @param left 字段
 * @param right 字段
 * @returns {number} 返回值类型
 * @constructor
 */
function numAdd(left, right) {
    return left + right;
}

console.log(numAdd(1, 2));

/**
 * 使用接口 shape:Shape
 * @param shape
 */
function area(shape) {
    if (shape.name === "square") {
        return shape.width * shape.height;
    }
    return 0;
}

//初始化接口，参数必须全部填上
var square = {
    name: "square",
    width: 12,
    height: 12
};
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
        }, 3000); //使用.bind(this)，能获取的外面的数据
    }
};
shape.popup();
var shape1 = {
    name: "rectangle",
    popup: function () {
        var _this = this;
        setTimeout(function () {
            console.log("=>函数中获取名称为：" + _this.name);
        }, 3000);
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
var TestClass1 = (function () {
    //构造函数
    function TestClass1(name, age) {
        this.name = name;
        this.age = age;
    }

    //方法,不写就默认转
    TestClass1.prototype.sayHello = function () {
        return "hello:" + this.age + ":" + this.name;
    };
    return TestClass1;
}());
console.log(new TestClass1("beyond", 11).sayHello());
/**
 * 类继承
 */
var TestClass2 = (function (_super) {
    __extends(TestClass2, _super);

    function TestClass2(name, age, location) {
        _super.call(this, name, age);
        this.location = location;
    }

    TestClass2.prototype.sayHello = function () {
        return _super.prototype.sayHello.call(this) + ":location=" + this.location;
    };
    return TestClass2;
}(TestClass1));
console.log(new TestClass2("aaa", 111, "hz").sayHello());
//# sourceMappingURL=index.js.map