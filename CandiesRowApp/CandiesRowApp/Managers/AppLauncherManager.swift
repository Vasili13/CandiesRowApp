//
//  AppLauncherManager.swift
//  CandiesRowApp
//
//  Created by Василий Вырвич on 8.04.24.
//

import Foundation

class AppLauncherManager {
    static let shared = AppLauncherManager()
    
    func isNewUser() -> Bool {
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    func setIsNotNewUser() {
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
}
