package flask

from net import http.FuncHandler

type Handler = (BaseContext)->Unit

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

    public func matchRouter(name: String): ?String {
        let nameRange = name.split("/", removeEmpty: true)
        for ((path, _) in this.routers) {
            let pathRange = path.split("/", removeEmpty: true)
            if (nameRange.size != pathRange.size) {
                continue
            }
            var isMatch = true
            for (idx in 0..nameRange.size) {
                if (nameRange[idx] != pathRange[idx] && pathRange[idx] != "*" && !pathRange[idx].startsWith(":") ) {
                    isMatch = false
                    break
                }
            }
            if (isMatch) {
                return Some(path)
            }
        }
        return None
    }

    private func addRouters(name: String, method: String, handler: Handler) {
        var path = name
        if (!path.startsWith("/")) {
            path = "/" + path
        }
        let httpHandler = FuncHandler {
            context => 
            println("200")
            handler(BaseContext(context))
        }
        if (!this.routers.contains(name)) {
            this.routers[name] = HashMap<String, HttpRequestHandler>([(method, httpHandler)])
        } else {
            this.routers[name][method] = httpHandler
        }
    }

    public func get(name: String, handler: Handler) {
        this.addRouters(name, "GET", handler)
    }

    public func post(name: String, handler: Handler) {
        this.addRouters(name, "POST", handler)
    }
}