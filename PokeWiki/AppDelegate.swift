//
//  AppDelegate.swift
//  PokeWiki
//
//  Created by 박혜민 on 5/12/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // window를 아래 코드에서 생성하기 때문에 처음엔 nil이라 옵셔널로 선언
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 디바이스 전체 화면 크기만큼의 UIWindow 생성
        let window = UIWindow(frame: UIScreen.main.bounds)
                
        window.rootViewController = UINavigationController(rootViewController: ViewController())
        window.makeKeyAndVisible()
        self.window = window
        return true
    }

}

