package cat;

/**
 * Created by Administrator on 2017/10/26.
 *
 * @doc: 1.基本数据类型，值传递[传递的是值的拷贝]，之后互不相关。
 * [温馨提示：从下面的代码提示灰色就看出来了，这样传递根本就没有意义。]
 * 1.1内存解释：拷贝到自己的运行栈内存
 * 2.其他，该对象的[地址]引用，会关联修改
 * 2.1内存解释：自己的运行栈内存指向该对象的地址，对象是存在堆中的所有线程共享
 * [温馨提示：查阅jvm基础模型
 *  堆，主内存，线程共享,class信息
 *  栈，非主内存，线程私有
 *  方法区, 方法的信息
 *      常量池
 *  程序计数器
 *  本地方法区
 * ]
 */
public class Test2 {
    public static void main(String[] args) {
        int a = 0; // 不改变
        String name = "test";// 不改变
        String[] arryStr = {"a", "a", "a"};// 改变改变
        User user = new User();// 改变改变
        user.setA(66);
        Test2 test = new Test2();
        test.Change(a, name, arryStr, user);
        System.out.println(a);
        System.out.println(name);
        System.out.println(arryStr[0]);
        System.out.println(user.getA());
        System.out.println("===============调用方法后");
    }

    public void Change(int a, String n, String[] arryStr, User u) {
        a = 33;
        n = "testNewName";
        arryStr[0] = "hello ";
//        u = new User();//这里new 就会是新的对象引用
        u.setA(99);
        System.out.println(a);
        System.out.println(n);
        System.out.println(arryStr[0]);
        System.out.println(u.getA());
        System.out.println("===============调用方法中");
    }
}

class User {
    int a = 0;
    String name = "test";


    public int getA() {
        return a;
    }

    public void setA(int a) {
        this.a = a;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }


}

