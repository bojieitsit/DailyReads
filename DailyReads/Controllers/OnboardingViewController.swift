//
//  OnboardingView.swift
//  DailyReads
//
//  Created by Andrey on 10.05.2023.
//

import UIKit
import UIOnboarding

struct UIOnboardingHelper {
    // App Icon
    static func setUpIcon() -> UIImage {
        return Bundle.main.appIcon ?? .init(named: "onboarding-icon")!
    }

    // First Title Line
    // Welcome Text
    static func setUpFirstTitleLine() -> NSMutableAttributedString {
        .init(string: "Welcome to", attributes: [.foregroundColor: UIColor.label])
    }
    
    // Second Title Line
    // App Name
    static func setUpSecondTitleLine() -> NSMutableAttributedString {
        .init(string: Bundle.main.displayName ?? "DailyReads", attributes: [
            .foregroundColor: UIColor.init(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)
        ])
    }

    // Core Features
    static func setUpFeatures() -> Array<UIOnboardingFeature> {
        return .init([
            .init(icon: .init(named: "feature-1")!,
                  title: "Search until found",
                  description: "Over 100 posts daily!"),
            .init(icon: .init(named: "feature-2")!,
                  title: "Don't lose what you found",
                  description: "Add to favorites the articles you like the most!"),
            .init(icon: .init(named: "feature-3")!,
                  title: "Read without leaving the app",
                  description: "You can read the news in the built-in browser!")
        ])
    }

    // Notice Text
    static func setUpNotice() -> UIOnboardingTextViewConfiguration {
        return .init(icon: .init(named: "onboarding-notice-icon")!,
                     text: "I express my gratitude to the teachers from OTUS.",
                     linkTitle: "Learn more...",
                     link: "https://otus.ru",
                     tint: .init(named: "camou"))
    }

    // Continuation Title
    static func setUpButton() -> UIOnboardingButtonConfiguration {
        return .init(title: "Continue",
                     titleColor: .white, // Optional, `.white` by default
                     backgroundColor: .init(red: 192/255, green: 192/255, blue: 192/255, alpha: 1))
    }
}
