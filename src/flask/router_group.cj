package flask

from net import http.FuncHandler

public class RouterGroup {
    private let perfix: String
    private let routers: HashMap<String, HashMap<String, HttpRequestHandler>>

    public init(prefix: String) {
        var path = prefix
        if (!path.startsWith("/")) {
            path = "/" + path
        }
        this.perfix = path
        this.routers = HashMap<String, HashMap<String, HttpRequestHandler>>()
    }

    public func getPerfix() {
        this.perfix
    }

    public func getRouters() {
        this.routers
    }

    private func addRouters(name: String, method: String, handler: ()->String) {
        var path = name
        if (!path.startsWith("/")) {
            path = "/" + path
        }
        let httpHandler = FuncHandler {
            context => handler() |> context.responseBuilder.body
            println("200")
        }
        if (!this.routers.contains(name)) {
            this.routers[name] = HashMap<String, HttpRequestHandler>([(method, httpHandler)])
        } else {
            this.routers[name][method] = httpHandler
        }
    }

    public func get(name: String, handler: ()->String) {
        this.addRouters(name, "GET", handler)
    }

    public func post(name: String, handler: ()->String) {
        this.addRouters(name, "POST", handler)
    }
}