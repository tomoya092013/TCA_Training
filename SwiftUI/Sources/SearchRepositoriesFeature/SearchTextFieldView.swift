import SwiftUI
import ComposableArchitecture

struct SearchTextFieldView: View {
  let store: StoreOf<SearchTextFieldReducer>
  @FocusState var focus:Bool
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in

      VStack {
        HStack {
          ZStack {
            RoundedRectangle(cornerRadius: 8)
              .fill(Color(red: 239 / 255,
                          green: 239 / 255,
                          blue: 241 / 255))
              .frame(height: 36)
            
            HStack(spacing: 6) {
              TextField("Search", text: viewStore.binding(
                get: \.text,
                send: { .binding(.set(\.$text, $0)) }
              ))
                .focused(self.$focus)
                .padding(.leading)
              
              if !viewStore.text.isEmpty {
                Button(action:{
                  viewStore.send(.clearTextField)
                  //Todo：$queryを空にする処理
                }) {
                  Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                }
                .padding(.trailing, 6)
              }
              Button {
                //Todo：$queryを空にする処理
                viewStore.send(.searchIconTapped)
              } label: {
                Image(systemName: "magnifyingglass")
                  .foregroundColor(.gray)
                  .padding([.leading, .trailing], 8)
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
    }
  }
}

#Preview {
  SearchTextFieldView(
    store: .init(initialState: SearchTextFieldReducer.State()) {
      SearchTextFieldReducer()
    }
  )
}
