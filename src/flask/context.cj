package flask

from net import http.HttpContext, http.HttpResponseBuilder

public class BaseContext {
    private let context: HttpContext
    private let resp: HttpResponseBuilder


    public init(context: HttpContext) {
        this.context = context
        this.resp = context.responseBuilder
    }

    public func string(str: String) {
        this.resp.body(str)
    }

    public func html(html: String) {
        this.resp.header("content-type", "text/html; charset=utf-8").body(html)
    }

    
    public func getHeaders(): HashMap<String, Collection<String>> {
        let headers = HashMap<String, Collection<String>>()
        for ((k,v) in this.context.request.headers.iterator()) {
            headers[k] = v
        }
        return headers
    }

    public func addHeaders(k: String, v: String) {
        this.resp.header(k, v)
    }
}