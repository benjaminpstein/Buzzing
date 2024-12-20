import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userData: UserData

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .top, spacing: 10) {
                VStack(alignment: .center, spacing: 6) {
                    AsyncImage(url: URL(string: realUser.profPicURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } placeholder: {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.white)
                            )
                    }.padding(.bottom, 8)

                    Text(realUser.username)
                        .font(.system(size: 27))
                        .foregroundColor(.appLight)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 8)

                    Button(action: {
                        logout()
                    }) {
                        Text("Log Out")
                            .font(.system(size: 20))
                            .foregroundColor(.appLight)
                            .frame(width: 150, height: 40)
                            .background(Color.appPrimary)
                            .cornerRadius(10)
                    }
                }
            }
            .padding(.top, 50)
            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)

            RecentPostView(username: realUser.username)
                .padding(.top, 16)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appDark)
    }

    private func logout() {
        print("[DEBUG] Logging out user.")
        UserDefaults.standard.removeObject(forKey: "realUser")
        userData.appState = .onboarding
    }
}

#Preview {
    ProfileView().environmentObject(UserData())
}
