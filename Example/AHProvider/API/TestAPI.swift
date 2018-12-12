
import Foundation
import AHProvider

enum TestAPI {
    case guardian(pageSize: String)
    case letsbuild
}

extension TestAPI: AHRequest {
    var method: AHHttpMethod {
        switch self {
        case .guardian, .letsbuild:
            return .get
        }
    }
    
    var baseURL: URL {
        switch self {
        case .guardian:
            return URL(string: "https://content.guardianapis.com")!
        case .letsbuild:
            return URL(string: "https://api.letsbuildthatapp.com")!
        }
    }
    
    var path: String {
        switch self {
        case .guardian:
            return "search"
        case .letsbuild:
            return "jsondecodable/website_description"
        }
    }

    var params: [String : String]? {
        switch self {
        case .guardian(let pageSize):
            return ["format": "json", "page-size": pageSize]
        case .letsbuild:
            return nil
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .guardian:
            let key = ["api-key" : "test"]
            return key
        case .letsbuild:
            return nil
        }
    }
}
