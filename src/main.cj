import flask.Flask

main(): Unit {
    let app = Flask("0.0.0.0", 8888)
    app.get("/hello") {
        => "hello, world"
    }
    app.run()
}