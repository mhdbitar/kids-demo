import Foundation

final class SharedData {
    
    static let shared = SharedData()
    private init() {}

    var children: [Child] = []
}
