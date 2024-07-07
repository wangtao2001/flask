import flask.Flask

main(): Unit {
    let app = Flask("0.0.0.0", 8888)
    app.get("/index") {
        context => 
        context.string("index")
    }
    app.run()
}