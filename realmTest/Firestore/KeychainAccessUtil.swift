import Foundation
import KeychainAccess

// TODO: Swagger変更対応後に public を消す
final public class KeychainAccessUtil {
    private init() {}
    // FIXME: 環境によってKeyChainを使い分ける
    private static let keychain = Keychain(service: Bundle.main.bundleIdentifier!)
    
    private enum KeychainKeys: String {
        case uuid
    }
}

// MARK: Keychain
extension KeychainAccessUtil {
    
    public static var uuid: String {
        if let uuid = keychain[KeychainKeys.uuid.rawValue] {
            return uuid
        } else {
            let uuid = UUID().uuidString
            setKeychain(.uuid, uuid)
            return keychain[KeychainKeys.uuid.rawValue]!
        }
    }
    
    // --------------------
    // private functions
    // --------------------
    private static func setKeychain(_ key: KeychainKeys, _ value: String?) {
        keychain[key.rawValue] = value
    }
}
