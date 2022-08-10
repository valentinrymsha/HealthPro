//
//  StartPageViewController.swift
//  HealthPro
//
//  Created by User on 8/3/22.
//

import UIKit

class StartPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        
        
    }
    



}
