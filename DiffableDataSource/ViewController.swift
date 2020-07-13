//
//  ViewController.swift
//  DiffableDataSource
//
//  Created by casandra grullon on 7/13/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum Section {
    case main
    }

    private var tableView: UITableView!
    
    //define the UITableViewDiffableDataSource instance
    //Needs Data types for <Section, Row>
    private var dataSource: UITableViewDiffableDataSource<Section, Int>!
    
    private var timer: Timer!
    
    private var startInterval = 10
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureTableView()
        configureDataSource()
    }
    
    private func configureTableView() {
        //programmatically adding a tableview to vc
        tableView = UITableView(frame: view.bounds, style: .plain)
        //setting up tableview constraints
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }

    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section,Int>(tableView: tableView, cellProvider: { (tableView, indexPath, value) -> UITableViewCell? in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "\(value)"
            return cell
        })
        //set type of animation
        dataSource.defaultRowAnimation = .fade
        //Setup snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems([1,2,3,4,5,6,7,8,9,10])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

