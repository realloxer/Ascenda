//
//  AppDelegate.swift
//  Ascenda
//
//  Created by LocNguyen on 10/02/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchContactsVC = storyboard.instantiateViewController(withIdentifier: "SearchContactsViewController") as! SearchContactsViewController
        searchContactsVC.viewModel = SearchContactsViewModel(contactRepository: ContactRepository())
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = searchContactsVC
        window?.makeKeyAndVisible()
        return true
    }


}

