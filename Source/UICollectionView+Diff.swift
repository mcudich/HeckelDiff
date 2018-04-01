//
//  UICollectionView+Diff.swift
//  HeckelDiff
//
//  Created by Matias Cudich on 11/23/16.
//  Copyright © 2016 Matias Cudich. All rights reserved.
//

#if os(iOS) || os(tvOS)
import Foundation
import UIKit

public extension UICollectionView {
  /// Applies a batch update to the receiver, efficiently reporting changes between old and new.
  ///
  /// - parameter old:            The previous state of the collection view.
  /// - parameter new:            The current state of the collection view.
  /// - parameter section:        The section where these changes took place.
  /// - parameter reloadUpdated:  Whether or not updated cells should be reloaded (default: true)
  func applyDiff<T: Collection>(_ old: T, _ new: T, inSection section: Int, reloadUpdated: Bool = true, completion: ((Bool) -> Void)?) where T.Iterator.Element: Hashable, T.Index == Int {
    let update = ListUpdate(diff(old, new), section)

    performBatchUpdates({
      self.deleteItems(at: update.deletions)
      self.insertItems(at: update.insertions)
      for move in update.moves {
        self.moveItem(at: move.from, to: move.to)
      }
    }, completion: reloadUpdated ? nil : completion)

    if reloadUpdated {
      // reloadItems is done separately as the update indexes returne by diff() are in respect to the
      // "after" state, but the collectionView.reloadItems() call wants the "before" indexPaths.
      performBatchUpdates({
        self.reloadItems(at: update.updates)
      }, completion: completion)
    }
  }
}
#endif
