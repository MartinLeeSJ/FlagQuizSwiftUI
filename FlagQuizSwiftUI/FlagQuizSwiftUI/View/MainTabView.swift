//
//  MainTabView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import SwiftUI

enum Tabs: Int, Hashable, CaseIterable {
    case quizSetting = 0
    case news
    
    var title: LocalizedStringKey {
        let result: LocalizedStringKey = switch self {
        case .quizSetting: .init("tabs.quizSetting.title")
        case .news: .init("tabs.news.title")
        }
        return result
    }
    
    var imageName: String {
        switch self {
        case .quizSetting: "q.square.fill"
        case .news: "newspaper.fill"
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    @State private var tabSelection: Tabs = .quizSetting
    
    var body: some View {
        VStack {
            TabView(selection: $tabSelection)  {
                ForEach(Tabs.allCases, id: \.self) { tab in
                    Group {
                        switch tab {
                        case .quizSetting:
                            QuizSettingView()
                                
                        case .news: NewsView()
                        }
                    }
                    .tabItem {
                        VStack {
                            Text(tab.title)
                            Image(systemName: tab.imageName)
                        }
                    }
                    
                }
            }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(DIContainer(services: StubService()))
}
