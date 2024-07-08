package flask

from net import http.Server, http.ServerBuilder, http.HttpContext, http.HttpStatusCode

public class Flask {
    private let router: Router
    private let server: Server

    public init(addr: String, port: UInt16) {
        this.router = Router()
        this.server = ServerBuilder().distributor(BaseDistrubutor()).addr(addr).port(port).build()
        println("listening on http://${addr}:${port}")
    }

    public func addRouterGroup(perfix: String) {
        return this.router.addRouterGroup(perfix)
    }

    private func handler(context: HttpContext) {
        let requestPath = context.request.url.path
        let requestMethod = context.request.method

        print("${requestMethod}\t${requestPath}\t")
        
        for (routerGroup in this.router.getRouterGroups()) {
            let perfix = routerGroup.getPerfix()
            if (!requestPath.startsWith(perfix)) {
                continue
            }
            var name = requestPath
            if (perfix != "/") {
                name = requestPath[perfix.size..]
            }
            match(routerGroup.matchRouter(name)) {
                case Some(path) => 
                    print("${path}\t")
                    if (!routerGroup.getRouters()[path].contains(requestMethod)) {
                        return FuncHandler{
                            context => 
                            context.responseBuilder.status(HttpStatusCode.STATUS_METHOD_NOT_ALLOWED)
                            println("405")
                        }.handle(context)
                    }
                    return routerGroup.getRouters()[path][requestMethod].handle(context)
                case None => ""
            }
        }

        return FuncHandler{
            context =>
            context.responseBuilder.status(HttpStatusCode.STATUS_NOT_FOUND)
            println("404")
        }.handle(context)
    }

    public func run() {
        this.server.distributor.register("/", this.handler)
        this.server.serve()
    }

    public func get(path: String, handler: Handler) {
        let default = this.addRouterGroup("/")
        default.get(path, handler)
    }

    public func post(path: String, handler: Handler) {
        let default =  this.addRouterGroup("/")
        default.post(path, handler)
    }

    public func static_(path: String, folder: String) {
        let default =  this.addRouterGroup("/")
        default.static_(path, folder)
    }
}