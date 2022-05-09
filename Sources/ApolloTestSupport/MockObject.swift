import ApolloAPI

@dynamicMemberLookup
public class Mock<O: Mockable>: JSONEncodable {
  public var _data: JSONEncodableDictionary

  public init() {
    _data = ["__typename": O.__typename.description]
  }

  public var __typename: String { _data["__typename"] as! String }

  public subscript<T: JSONEncodable>(dynamicMember keyPath: KeyPath<O.MockFields, Field<T>>) -> T? {
    get {
      let field = O.__mockFields[keyPath: keyPath]
      return _data[field.key.description] as? T
    }
    set {
      let field = O.__mockFields[keyPath: keyPath]
      _data[field.key.description] = newValue
    }
  }

  public subscript<T: Mockable>(dynamicMember keyPath: KeyPath<O.MockFields, Field<T>>) -> Mock<T>? {
    get {
      let field = O.__mockFields[keyPath: keyPath]
      return _data[field.key.description] as? Mock<T>
    }
    set {
      let field = O.__mockFields[keyPath: keyPath]
      _data[field.key.description] = newValue
    }
  }

  // MARK: JSONEncodable

  public var jsonValue: JSONValue { "" } // TODO 

}

public protocol Mockable: Object {
  associatedtype MockFields

  static var __mockFields: MockFields { get }
}
