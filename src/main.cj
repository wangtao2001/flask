import flask.Flask

main(): Unit {
    let app = Flask("0.0.0.0", 7676)
    app.static_("/", "static")
    app.get("/") {
        context =>
        context.file("static/index.html")
    }
    app.run()
}