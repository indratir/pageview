//
//  ContentVC.swift
//  PageView
//
//  Created by Indra Tirta Nugraha on 16/09/21.
//

import UIKit

enum ContentViewScrollDirection {
    case up
    case down
}

protocol ContentViewScrollDelegate: AnyObject {
    var currentHeaderHeight: CGFloat { get }
    
    func didScroll(offset: CGFloat)
}

class ContentVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    weak var scrollDelegate: ContentViewScrollDelegate?
    var numberOfCells = 30
    var backgroundColor = UIColor.systemBackground
    var prefixCell = "Item"
    
    private var scrollDirection: ContentViewScrollDirection = .up
    private var oldContentOffset = CGPoint.zero
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        refreshControl.translatesAutoresizingMaskIntoConstraints = false
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.backgroundColor = backgroundColor
        tableView.refreshControl = refreshControl
        tableView.showsVerticalScrollIndicator = false
        
        if let topInset = scrollDelegate?.currentHeaderHeight {
            tableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
            refreshControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 24).isActive = true
            refreshControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
    }
    
    @objc func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.refreshControl.endRefreshing()
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        tableView.setContentOffset(CGPoint(x: 0, y: currentOffset), animated: false)
//    }

}

extension ContentVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "\(prefixCell) \(indexPath.row)"
        cell.backgroundColor = .clear
        
        return cell
    }
    
    // MARK:- Scroll delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        if let topInset = scrollDelegate?.currentHeaderHeight {
            let distance = topInset + scrollView.contentOffset.y
            
            scrollDelegate?.didScroll(offset: -distance)
        }
    }
}
