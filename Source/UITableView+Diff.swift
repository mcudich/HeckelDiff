//
//  UITableView+Diff.swift
//  HeckelDiff
//
//  Created by Matias Cudich on 11/23/16.
//  Copyright © 2016 Matias Cudich. All rights reserved.
//

import Foundation
import UIKit

public extension UITableView {
  /// Applies a batch update to the receiver, efficiently reporting changes between old and new.
  ///
  /// - parameter old:       The previous state of the table view.
  /// - parameter new:       The current state of the table view.
  /// - parameter section:   The section where these changes took place.
  /// - parameter animation: The animation type.
  func applyDiff<T: Collection>(_ old: T, _ new: T, inSection section: Int, withAnimation animation: UITableViewRowAnimation) where T.Iterator.Element: Hashable, T.IndexDistance == Int, T.Index == Int {
    let update = ListUpdate(diff(old, new), section)

    beginUpdates()

    deleteRows(at: update.deletions, with: animation)
    insertRows(at: update.insertions, with: animation)
    reloadRows(at: update.updates, with: animation)
    for move in update.moves {
      moveRow(at: move.from, to: move.to)
    }

    endUpdates()
  }
}
