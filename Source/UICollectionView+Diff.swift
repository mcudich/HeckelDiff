//
//  UICollectionView+Diff.swift
//  HeckelDiff
//
//  Created by Matias Cudich on 11/23/16.
//  Copyright © 2016 Matias Cudich. All rights reserved.
//

import Foundation
import UIKit

public extension UICollectionView {
  func applyDiff<T: Collection>(_ old: T, _ new: T, inSection section: Int, completion: ((Bool) -> Void)?) where T.Iterator.Element: Hashable, T.IndexDistance == Int, T.Index == Int {
    let update = ListUpdate(diff(old, new), section)

    performBatchUpdates({
      self.deleteItems(at: update.deletions)
      self.insertItems(at: update.insertions)
      self.reloadItems(at: update.updates)
      for move in update.moves {
        self.moveItem(at: move.from, to: move.to)
      }
    }, completion: completion)
  }
}
