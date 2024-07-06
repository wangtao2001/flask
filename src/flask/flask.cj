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

    public func addRouerGroup(perfix: String) {
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
            if (!routerGroup.getRouters().contains(name)) {
                continue
            }   
            if (!routerGroup.getRouters()[name].contains(requestMethod)) {
                return FuncHandler{
                    context => 
                    context.responseBuilder.status(HttpStatusCode.STATUS_METHOD_NOT_ALLOWED)
                    println("405")
                }.handle(context)
            }
            return routerGroup.getRouters()[name][requestMethod].handle(context)
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

    public func get(path: String, handler: () -> String) {
        let default = this.addRouerGroup("/")
        default.get(path, handler)
    }

    public func post(path: String, handler: () -> String) {
        let default =  this.addRouerGroup("/")
        default.post(path, handler)
    }
}