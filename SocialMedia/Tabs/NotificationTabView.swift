//
//  NotificationTabView.swift
//  SocialMedia
//
//  Created by Jan Konieczny on 28/01/2021.
//

import SwiftUI

struct NotificationsTabView: View {
    @EnvironmentObject var firebase: Firebase
    var body: some View {
       Text("Notifications")
    }
}

struct NotificationsTabView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsTabView()
    }
}
