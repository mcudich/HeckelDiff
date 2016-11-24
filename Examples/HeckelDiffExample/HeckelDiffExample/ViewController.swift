//
//  ViewController.swift
//  HeckelDiffExample
//
//  Created by Matias Cudich on 11/23/16.
//  Copyright © 2016 Matias Cudich. All rights reserved.
//

import UIKit
import HeckelDiff

class ViewController: UIViewController, UITableViewDataSource {
  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    return tableView
  }()

  var items = ["1", "2", "3", "4", "5"]

  override func loadView() {
    view = tableView
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    refresh()
  }

  func refresh() {
    let previousItems = items
    let last = items.removeLast()
    items.insert(last, at: 0)

    tableView.applyDiff(previousItems, items, inSection: 0, withAnimation: .right)

    let time = DispatchTime.now() + DispatchTimeInterval.seconds(1)
    DispatchQueue.main.asyncAfter(deadline: time) {
      self.refresh()
    }
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = items[indexPath.row]
    return cell
  }
}

