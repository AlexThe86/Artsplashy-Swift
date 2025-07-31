//
//  MenuView.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 24.01.24.
//
import SwiftUI

struct SideMenuView: View {
    @Binding var isMenuOpen: Bool
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var messageViewModel: MessageViewModel

    
    var body: some View {
            ZStack(alignment: .leading) {
                Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading, spacing: 0) {
                    NavigationLink(destination: UserEditProfileView(userViewModel: userViewModel)) {
                        HeaderView()
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            if userViewModel.profile?.role == "Admin" {
                                NavigationLink(destination: AdminDashboardView(userViewModel: userViewModel)) {
                                    MenuRow(title: "Admin Dashboard", icon: "checkmark.shield")
                                }
                                Divider().background(Color.white)
                            }
                            NavigationLink(destination: ArtQuotesView()) {
                                MenuRow(title: "KunstFakten", icon: "quote.bubble")
                            }
                            Divider().background(Color.white)

                            NavigationLink(destination: SettingsView()) {
                                MenuRow(title: "Einstellungen", icon: "gear")
                            }
                            Divider().background(Color.white)
                            MenuRow(title: "Nachrichten", icon: "message.circle")
                            Divider().background(Color.white)
                            NavigationLink(destination: FollowerView()) {
                                MenuRow(title: "Kontakte", icon: "person.circle")
                            }
                            Divider().background(Color.white)
                            Button(action: {
                                withAnimation {
                                    userViewModel.logout()
                                    self.isMenuOpen = false
                                }
                            }) {
                                MenuRow(title: "Logout", icon: "arrow.right.to.line.circle")
                            }
                            Divider().background(Color.white)
                        }
                    }
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width / 1)
                .background(Color.black.opacity(0.1))
                 .transition(.move(edge: .leading))
             }
             .onAppear {
                 self.isMenuOpen = false
             }
             .onTapGesture {
                 withAnimation {
                     self.isMenuOpen = false
                 }
             }
         }
     }

struct SideMenuView_Previews: PreviewProvider {
    @State static var isMenuOpen = true
    
    static var previews: some View {
        SideMenuView(isMenuOpen: $isMenuOpen)
            .environmentObject(UserViewModel())
    }
}
