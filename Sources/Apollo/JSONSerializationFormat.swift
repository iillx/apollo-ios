import Foundation
#if !COCOAPODS
import ApolloAPI
#endif

public final class JSONSerializationFormat {
  public class func serialize(value: any JSONEncodable) throws -> Data {
    return try JSONSerialization.sortedData(withJSONObject: value._jsonValue)
  }

  public class func serialize(value: JSONObject) throws -> Data {
    return try JSONSerialization.sortedData(withJSONObject: value)
  }

  public class func deserialize(data: Data) throws -> JSONValue {
#if canImport(FoundationNetworking) // there is probably a better macro to determine we're running on linux
      let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
      // Don't cast directly to AnyHashable when running on linux to avoid running into crasher.
      // rdar://137300308 (Runtime crash on linux when force casting to AnyHashable (doesn't repro when running on macOS))
      let intermediaryCast = jsonObject as! Dictionary<String, AnyHashable>
      return intermediaryCast as AnyHashable
#else
      return try JSONSerialization.jsonObject(with: data, options: []) as! AnyHashable
#endif
  }
}
