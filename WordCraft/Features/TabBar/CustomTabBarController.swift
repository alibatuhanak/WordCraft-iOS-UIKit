//
//  CustomTabBarController.swift
//  WordCraft
//
//  Created by Ali Batuhan AK on 17.01.2025.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let homeNavigationController = generateNavigationController(vc: HomeView(), title: "Home", image: UIImage(named: "home_tabBar")!)
        let leaderboardNavigationController = generateNavigationController(vc: LeaderboardView(), title: "Leaderboard", image: UIImage(named: "leaderboard_tabBar")!)
        let achievementsNavigationController = generateNavigationController(vc: AchievementsView(), title: "Achievements", image: UIImage(named: "badge_tabBar")!)
        let profileNavigationController = generateNavigationController(vc: ProfileView(), title: "Profile", image: UIImage(named: "profile_tabBar")!)
        
        UINavigationBar.appearance().prefersLargeTitles = true
        viewControllers = [homeNavigationController,
                           leaderboardNavigationController,
                           achievementsNavigationController,
                           profileNavigationController]
        

        
        if let items = tabBar.items {
            for item in items {
                item.imageInsets = UIEdgeInsets(top: 11.5, left: 0, bottom: -15.5, right: 0)
                
                item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 6)
            }
        }
        selectedIndex = 0

       
        // Do any additional setup after loading the view.
    }
    
    
    fileprivate func generateNavigationController(vc: UIViewController,
                                           title: String, image: UIImage) -> UINavigationController{
         
        let navController = UINavigationController(rootViewController: vc)
        //vc.navigationItem.title = title
     //   vc.title = title
        vc.tabBarItem.image = image
//        self.tabBar.tintColor = UIColor(red: 249 / 255, green: 189 / 255, blue: 51/255, alpha: 1.0)
//        UITabBar.appearance().unselectedItemTintColor = .gray
//        self.tabBar.unselectedItemTintColor = .red
        return navController
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var tabFrame = tabBar.frame
        tabFrame.size.height = 60
        tabFrame.origin.y = view.frame.size.height - 75
        tabFrame.size.width = view.frame.size.width - 60
        tabFrame.origin.x = (view.frame.size.width - tabFrame.size.width) / 2
          
        tabBar.frame = tabFrame
        tabBar.layer.cornerRadius = 30
        tabBar.layer.masksToBounds = true
        
        
    //  tabBar.backgroundColor = UIColor.primarypurple.withAlphaComponent(0.3)
        
        
//       let appearance = UITabBarAppearance()
////        appearance.configureWithTransparentBackground()
////        appearance.backgroundColor = .primarypurple.withAlphaComponent(0.5)
//        appearance.configureWithDefaultBackground()
//        tabBar.isOpaque = true
//          
//         tabBar.standardAppearance = appearance
//        
//        tabBar.unselectedItemTintColor = .primarypurple.withAlphaComponent(0.4)
//        tabBar.tintColor = .primarypurple
//        
////        UITabBar.appearance().tintColor = .white
////        UITabBar.appearance().barTintColor = UIColor(named: "PrimaryDark")
////        UITabBar.appearance().isOpaque = false
////       
//      UITabBar.appearance().unselectedItemTintColor = .red
        
        
        
        let appearance = UITabBarAppearance()

        appearance.configureWithDefaultBackground()
        // appearance.configureWithOpaqueBackground()

        appearance.backgroundColor = .primarypurple.withAlphaComponent(0.2)

        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.primarypurple
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.primaryColor
        ]

        appearance.stackedLayoutAppearance.normal.iconColor = .systemPurple.withAlphaComponent(0.5)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.blue
        ]

        appearance.shadowColor = nil

        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }

    }
    
    static func presentTabBarController(from vc: UIViewController) {
        let customTabBarController = CustomTabBarController()
        customTabBarController.selectedIndex = 1
        customTabBarController.modalPresentationStyle = .fullScreen
        customTabBarController.modalTransitionStyle = .flipHorizontal
        
        UIView.animate(withDuration: 0.3, animations: {
            vc.view.alpha = 0
        }) { _ in
            vc.present(customTabBarController, animated: true) {
                vc.view.alpha = 1 
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
