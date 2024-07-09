<div align="center">
<h1>Flask: cangjie web框架</h1>
</div>

> 适配版本：Cangjie Compiler: 0.51.4 (cjnative)

### 特性：

- 支持返回多种类型数据
- 动态路由、路由分组

### 使用

##### 1. 直接使用当前项目

```bash
git clone git@github.com:wangtao2001/flask.git
cd flask
cjpm run
```

访问 `http://localhost:7676` 即可得到默认页面

##### 2. 作为三方库使用

将 `cjpm.toml` 中 output-type 字段修改为 "static" 或 "dynamic" 并在项目中引用

### 使用示例

```
main(): Unit {
    # 创建容器
    let app = Flask("0.0.0.0", 7676)
    # 设置静态资源目录
    app.static_("/", "static")
    # 绑定路由及处理函数
    app.get("/") {
        context =>
        context.file("dist/index.html")
    }
    # 路由分组
    let user = app.addRouterGroup("/user")
    user.get("/*") {
        context => 
        context.string("user")
    }
    # 启动容器
    app.run()
}
```