/**
 * author:Leng Tingxue
 * time:${DATE}
 * doc: 第一个ts文件,laya团队需要
 * 安装npm ->安装typescript ->
 * webstorm ->配置typescript
 * 进入*。ts的目录，运行命令 tsc *.ts ->生成*。js文件
 * =>后期再改为自动编译
 */
class HeeloWorld{
    public say():void{
        console.log("hello world");
    }
}
new HeeloWorld().say();