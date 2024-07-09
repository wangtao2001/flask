package flask

from net import http.HttpContext, http.HttpResponseBuilder
from std import fs.File
from serialization import serialization.Serializable
from encoding import json.*

public class BaseContext {
    private let context: HttpContext
    private let resp: HttpResponseBuilder


    public init(context: HttpContext) {
        this.context = context
        this.resp = context.responseBuilder
    }

    public func string(str: String): Unit {
        this.resp.body(str)
    }

    public func html(html: String): Unit {
        this.resp.header("content-type", "text/html; charset=utf-8").body(html)
    }

    public func file(path: String): Unit {
        let allBytes: Array<UInt8> = File.readFrom(path)
        let arr = path.split(".")
        let fileType = arr[arr.size-1]
        match(fileType) {
            case "html" => this.resp.header("content-type", "text/html; charset=utf-8")
            case "css" => this.resp.header("content-type", "text/css; charset=utf-8")
            case "js" => this.resp.header("content-type", "text/javascript; charset=utf-8")
            case "jpg" | "png" | "jpeg" => this.resp.header("content-type", "image/jpeg")
            case _ => ""
        }
        this.resp.body(allBytes)
    }

    public func json<T>(data: T) where T<:  Serializable<T> {
        this.resp.header("content-type", "text/json; charset=utf-8").body(data.serialize().toJson().asObject().toJsonString())
    }

    public func getHeaders(): HashMap<String, Collection<String>> {
        let headers = HashMap<String, Collection<String>>()
        for ((k,v) in this.context.request.headers.iterator()) {
            headers[k] = v
        }
        headers
    }

    public func getRequestMethod(): String {
        this.context.request.method
    }

    public func getRequestPath(): String {
        this.context.request.url.path
    }

    public func addHeaders(k: String, v: String): Unit {
        this.resp.header(k, v)
    }
}