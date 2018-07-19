//
//  UITableView+Diff.swift
//  HeckelDiff
//
//  Created by Matias Cudich on 11/23/16.
//  Copyright © 2016 Matias Cudich. All rights reserved.
//

#if os(iOS) || os(tvOS)
import Foundation
import UIKit

public extension UITableView {
  /// Applies a batch update to the receiver, efficiently reporting changes between old and new.
  ///
  /// - parameter old:              The previous state of the table view.
  /// - parameter new:              The current state of the table view.
  /// - parameter section:          The section where these changes took place.
  /// - parameter animation:        The animation type.
  /// - parameter reloadUpdated:    Whether or not updated cells should be reloaded (default: true)
  func applyDiff<T: Collection>(_ old: T, _ new: T, inSection section: Int, withAnimation animation: UITableViewRowAnimation, reloadUpdated: Bool = true) where T.Iterator.Element: Hashable, T.Index == Int {
    let update = ListUpdate(diff(old, new), section)

    if update.isOrderChanged {
        beginUpdates()

        deleteRows(at: update.deletions, with: animation)
        insertRows(at: update.insertions, with: animation)
        for move in update.moves {
            moveRow(at: move.from, to: move.to)
        }
        endUpdates()
    }

    // reloadItems is done separately as the update indexes returne by diff() are in respect to the
    // "after" state, but the collectionView.reloadItems() call wants the "before" indexPaths.
    if reloadUpdated && update.updates.count > 0 {
      beginUpdates()
      reloadRows(at: update.updates, with: animation)
      endUpdates()
    }
  }
}
#endif
