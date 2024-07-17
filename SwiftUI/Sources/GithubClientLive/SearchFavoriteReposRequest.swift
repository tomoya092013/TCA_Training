import APIKit
import SharedModel

struct SearchFavoriteReposRequest: GithubRequest {
  typealias Response = SearchReposResponse
  let method = APIKit.HTTPMethod.get
  let path = "/user/starred"
  let queryParameters: [String: Int]?
  
  public init() {
    self.queryParameters = [
      "page": 1,
      "per_page": 10
    ]
  }
}
