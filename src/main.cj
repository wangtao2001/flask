import flask.Flask

from serialization import serialization.*
from encoding import json.*

class User <: Serializable<User> {
    var name: String
    var age: Int

    public init(name: String, age: Int) {
        this.name = name
        this.age = age
    }

    public func serialize(): DataModel {
        return DataModelStruct().add(field<String>("name", this.name))
                                .add(field<Int>("age", this.age))
    }   

    public static func deserialize(data: DataModel): User {
        var ds = match(data) {
            case ds: DataModelStruct => ds
            case _ => throw Exception()
        }
        return User(String.deserialize(ds.get("name")), Int.deserialize(ds.get("age")))
    }
}

main(): Unit {
    let app = Flask("0.0.0.0", 7676)
    app.get("/") {
        context =>
        context.file("dist/index.html")
    }
    app.get("/info/user") {
        context =>
        context.json(User("xiao", 20))
    }
    app.run()
}