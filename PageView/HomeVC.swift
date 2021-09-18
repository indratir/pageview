//
//  HomeVC.swift
//  PageView
//
//  Created by Indra Tirta Nugraha on 16/09/21.
//

import UIKit

var currentOffset: CGPoint = CGPoint(x: 0, y: 0)

class HomeVC: UIViewController {
    
    // MARK:- Outlets

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var stickyView: UIView!
    @IBOutlet weak var headerViewTop: NSLayoutConstraint!
    
    // MARK:- Programmatic UI
    var pageViewController = UIPageViewController()
    var contentsViewController = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let topInset = headerView.frame.height + stickyView.frame.height
        currentOffset = CGPoint(x: 0, y: -topInset)
        
        setupPageViewController()
        populateContainerView()
    }
    
    func setupPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
    }
    
    func populateContainerView() {
        for index in 0..<3 {
            let contentViewController = ContentVC()
            contentViewController.scrollDelegate = self
            contentViewController.numberOfCells = Int.random(in: 30..<50)
            
            switch index {
            case 0:
                contentViewController.prefixCell = "Berita"
                contentViewController.backgroundColor = .systemBlue
            case 1:
                contentViewController.prefixCell = "QNA"
                contentViewController.backgroundColor = .systemYellow
            case 2:
                contentViewController.prefixCell = "Livesteam"
                contentViewController.backgroundColor = .systemGreen
            default:
                contentViewController.backgroundColor = .systemBackground
            }
            
            contentsViewController.append(contentViewController)
        }
        
        pageViewController.setViewControllers(
            [contentsViewController[0]],
            direction: .forward,
            animated: true,
            completion: nil
        )
        
        addChild(pageViewController)
        pageViewController.willMove(toParent: self)
        containerView.addSubview(pageViewController.view)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        pageViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        pageViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        pageViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        pageViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }

}

extension HomeVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentVCIndex = contentsViewController.firstIndex(where: { $0 == viewController }),
           (1..<contentsViewController.count).contains(currentVCIndex) {
            return contentsViewController[currentVCIndex - 1]
        }
        return nil
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentVCIndex = contentsViewController.firstIndex(where: { $0 == viewController }),
           (0..<(contentsViewController.count - 1)).contains(currentVCIndex) {
            return contentsViewController[currentVCIndex + 1]
        }
        return nil
    }
}

extension HomeVC: ContentViewScrollDelegate {
    var headerStickyHeight: CGFloat {
        return headerView.frame.height + stickyView.frame.height
    }
    
    var stickyHeight: CGFloat {
        return stickyView.frame.height
    }
    
    func didScroll(offsetY: CGFloat) {
        let _headerViewTop = headerView.frame.height + stickyView.frame.height + offsetY
        
        if _headerViewTop <= headerView.frame.height {
            headerViewTop.constant = (-_headerViewTop)
        }
    }
}
