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
        configureNavBar()
        configureTableView()
        configureDataSource()
    }
    
    private func configureNavBar() {
        navigationItem.title = "Countdown with diffable data source"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startCountdown))
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
            
            if value == 0 {
                cell.textLabel?.text = "App launched 🚀"
            } else {
                cell.textLabel?.text = "\(value)"
            }
            return cell
        })
        //set type of animation
        dataSource.defaultRowAnimation = .fade
        startCountdown()
    }
    
    @objc private func startCountdown() {
        if timer != nil {
            timer.invalidate()
        }
        //configure timer
        //set interval for countdown
        //assign method that is called every second
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(decrementCounter), userInfo: nil, repeats: true)
        
        //reset starting interval
        startInterval = 10
        
        //setup snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems([startInterval])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    @objc private func decrementCounter() {
        //access snapshot to manipulate data
        //snapshot is the source of tableview data
        var snapshot = dataSource.snapshot()
        
        guard startInterval > 1 else {
            //when value hits 0, we stop the count
            timer.invalidate()
            ship()
            return
        }
        startInterval -= 1
        
        snapshot.appendItems([startInterval])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func ship() {
        //add an extra row when timer is invalid
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([0])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

