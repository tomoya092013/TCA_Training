import GithubClient
import Dependencies
import SharedModel
import ApiClient

extension GithubClient: DependencyKey {
  public static let liveValue: GithubClient = .live()
  
  static func live(apiClient: ApiClient = .liveValue) -> Self {
    .init(
      searchRepos: {
        try await apiClient.send(request: SearchReposRequest())
      }
//      searchFavoriteRepos: {
//        try await apiClient.send(request: SearchFavoriteReposRequest())
//      }
    )
  }
}
