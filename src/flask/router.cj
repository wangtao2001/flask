package flask

from std import collection.HashMap, collection.ArrayList
from net import http.HttpRequestHandler

public class Router {
    private let routerGroups: ArrayList<RouterGroup>

    public init() {
        this.routerGroups = ArrayList<RouterGroup>()
    }

    public func getRouterGroups() {
        this.routerGroups
    }

    public func addRouterGroup(perfix: String) {
        let routerGroup = RouterGroup(perfix)
        this.routerGroups.append(routerGroup)
        return routerGroup
    }
}