//
//  ListUpdate.swift
//  HeckelDiff
//
//  Created by Matias Cudich on 11/23/16.
//  Copyright © 2016 Matias Cudich. All rights reserved.
//

import Foundation

public struct ListUpdate {
  public var deletions = [IndexPath]()
  public var insertions = [IndexPath]()
  public var updates = [IndexPath]()
  public var moves = [(from: IndexPath, to: IndexPath)]()

  public init(_ result: [Operation], _ section: Int) {
    for step in result {
      switch step {
      case .delete(let index):
        deletions.append(IndexPath(row: index, section: section))
      case .insert(let index):
        insertions.append(IndexPath(row: index, section: section))
      case .update(let index):
        updates.append(IndexPath(row: index, section: section))
      case let .move(fromIndex, toIndex):
        moves.append((from: IndexPath(row: fromIndex, section: section), to: IndexPath(row: toIndex, section: section)))
      }
    }
  }
}
