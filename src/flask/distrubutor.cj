package flask

from net import http.HttpRequestDistributor, http.FuncHandler

class BaseDistrubutor <: HttpRequestDistributor {
    private var handler: HttpRequestHandler
    private var path: String

    public init() {
        this.path = ""
        this.handler = FuncHandler{httpContext => }
    }

    public func register(path: String, handler: HttpRequestHandler): Unit {
        this.path = path
        this.handler = handler
    }

    public func distribute(path: String): HttpRequestHandler {
        return handler
    }
}