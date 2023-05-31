import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "users"

    @ID
    var id: UUID?
    @Field(key: "name")
    var name: String
    @Field(key: "username")
    var username: String
    @Field(key: "password")
    var password: String
    @Children(for: \.$user)
    var acronyms: [Acronym]

    init() {}

    init(
        id: UUID? = nil,
        name: String,
        username: String,
        password: String
    ) {
        self.name = name
        self.username = username
        self.password = password
    }
}

extension User {

    func buildResponse() -> UserResponse {
        return UserResponse(id: id, name: name, username: username)
    }
}

extension Collection where Element: User {

    func buildResponses() -> [UserResponse] {
        return self.map { $0.buildResponse() }
    }
}

extension User: ModelAuthenticatable {

    static let usernameKey = \User.$username
    static let passwordHashKey = \User.$password

    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}

struct UserResponse: Content {
    var id: UUID?
    var name: String
    var username: String
}
