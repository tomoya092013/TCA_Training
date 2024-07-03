import SwiftUI
import ComposableArchitecture
import RepositoryDetailFeature

public struct SearchRepositoriesView: View {
  let store: StoreOf<SearchRepositoriesReducer>
  @State var editing: Bool = false
  @FocusState var focus:Bool
  
  struct ViewState: Equatable {
    @BindingViewState var query: String
    @BindingViewState var showFavoritesOnly: Bool
    let hasMorePage: Bool
    
    init(store: BindingViewStore<SearchRepositoriesReducer.State>) {
      self._query = store.$query
      self._showFavoritesOnly = store.$showFavoritesOnly
      self.hasMorePage = store.hasMorePage
    }
  }
  
  public init(store: StoreOf<SearchRepositoriesReducer>) {
    self.store = store
  }
  
  public var body: some View {
    NavigationStackStore(store.scope(state: \.path, action: \.path)) {
      WithViewStore(store, observe: ViewState.init(store:)) { viewStore in
        VStack {
          
          HStack {
            ZStack {
              RoundedRectangle(cornerRadius: 8)
                .fill(Color(red: 239 / 255,
                            green: 239 / 255,
                            blue: 241 / 255))
                .frame(height: 36)
              
              HStack(spacing: 6) {
                Button {
                  //Todo：検索処理
                } label: {
                  Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding([.leading, .trailing], 8)
                }
                
                TextField("Search", text: viewStore.$query)
                  .focused(self.$focus)
                
                if !viewStore.$query.wrappedValue.isEmpty {
                  Button {
                    //Todo：$queryを空にする処理
                  } label: {
                    Image(systemName: "xmark.circle.fill")
                      .foregroundColor(.gray)
                  }
                  .padding(.trailing, 6)
                }
              }
            }
            .padding(.top, self.focus ? 0 : 40)

            if self.focus {
              Button(action: {
                self.focus = false
                //Todo：$queryを空にする処理、フォーカスを外す
              }, label: {
                Text("Cancel")
              })
            }
          }
        }
        .padding(.horizontal)
        
        List {
          Toggle(isOn: viewStore.$showFavoritesOnly) {
            Text("Favorites Only")
          }
          
          ForEachStore(store.scope(
            state: \.filteredItems,
            action: \.items
          )) { itemStore in
            WithViewStore(itemStore, observe: { $0 }) { itemViewStore in
              NavigationLink(
                state: RepositoryDetailReducer.State(
                  repository: itemViewStore.repository,
                  liked: itemViewStore.liked
                )
              ) {
                RepositoryItemView(store: itemStore)
                  .onAppear {
                    viewStore.send(.itemAppeared(id: itemStore.withState(\.id)))
                  }
              }
            }
          }
          
          if viewStore.hasMorePage {
            ProgressView()
              .frame(maxWidth: .infinity)
          }
        }
      }
    } destination: {
      RepositoryDetailView(store: $0)
    }
  }
}

#Preview {
  SearchRepositoriesView(
    store: .init(initialState: SearchRepositoriesReducer.State()) {
      SearchRepositoriesReducer()
        .dependency(
          \.githubClient,
           .init(searchRepos: { _, _ in .mock() })
        )
    }
  )
}
