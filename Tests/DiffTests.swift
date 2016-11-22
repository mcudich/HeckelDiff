//
//  DiffTests.swift
//  HeckelDiff
//
//  Created by Matias Cudich on 11/22/16.
//  Copyright © 2016 Matias Cudich. All rights reserved.
//

import XCTest
import HeckelDiff

struct FakeItem: Hashable {
  let value: Int
  let eValue: Int

  var hashValue: Int {
    return value.hashValue
  }
}

func ==(lhs: FakeItem, rhs: FakeItem) -> Bool {
  return lhs.eValue == rhs.eValue
}

func ==(lhs: (from: Int, to: Int), rhs: (from: Int, to: Int)) -> Bool {
  return lhs.0 == rhs.0 && lhs.1 == rhs.1
}

class DiffTests: XCTestCase {
  func testEmptyArrays() {
    let o = [Int]()
    let n = [Int]()
    let result = diff(o, n)
    XCTAssertEqual(0, result.count)
  }

  func testDiffingFromEmptyArray() {
    let o = [Int]()
    let n = [1]
    let result = diff(o, n)
    XCTAssertEqual(.insert(0), result[0])
    XCTAssertEqual(1, result.count)
  }

  func testDiffingToEmptyArray() {
    let o = [1]
    let n = [Int]()
    let result = diff(o, n)
    XCTAssertEqual(.delete(0), result[0])
    XCTAssertEqual(1, result.count)
  }

  func testSwapHasMoves() {
    let o = [1, 2, 3]
    let n = [2, 3, 1]
    let result = diff(o, n)
    XCTAssertEqual([.move(1, 0), .move(2, 1), .move(0, 2)], result)
  }

  func testSwapHasMovesWithOrder() {
    let o = [1, 2, 3]
    let n = [2, 3, 1]
    let result = orderedDiff(o, n)
    XCTAssertEqual([.delete(2), .delete(1), .delete(0), .insert(0), .insert(1), .insert(2)], result)
  }

  func testMovingTogether() {
    let o = [1, 2, 3, 3, 4]
    let n = [2, 3, 1, 3, 4]
    let result = diff(o, n)
    XCTAssertEqual([.move(1, 0), .move(2, 1), .move(0, 2)], result)
  }

  func testMovingTogetherWithOrder() {
    let o = [1, 2, 3, 3, 4]
    let n = [2, 3, 1, 3, 4]
    let result = orderedDiff(o, n)
    XCTAssertEqual([.delete(2), .delete(1), .delete(0), .insert(0), .insert(1), .insert(2)], result)
  }

  func testSwappedValuesHaveMoves() {
    let o = [1, 2, 3, 4]
    let n = [2, 4, 5, 3]
    let result = diff(o, n)
    XCTAssertEqual([.delete(0), .move(3, 1), .insert(2), .move(2, 3)], result)
  }

  func testSwappedValuesHaveMovesWithOrder() {
    let o = [1, 2, 3, 4]
    let n = [2, 4, 5, 3]
    let result = orderedDiff(o, n)
    XCTAssertEqual([.delete(3), .delete(2), .delete(0), .insert(1), .insert(2), .insert(3)], result)
  }

  func testUpdates() {
    let o = [
      FakeItem(value: 0, eValue: 0),
      FakeItem(value: 1, eValue: 1),
      FakeItem(value: 2, eValue: 2)
    ]
    let n = [
      FakeItem(value: 0, eValue: 1),
      FakeItem(value: 1, eValue: 2),
      FakeItem(value: 2, eValue: 3)
    ]
    let result = diff(o, n)
    XCTAssertEqual([.update(0), .update(1), .update(2)], result)
  }

  func testDeletionLeadingToInsertionDeletionMoves() {
    let o = [0, 1, 2, 3, 4, 5, 6, 7, 8]
    let n = [0, 2, 3, 4, 7, 6, 9, 5, 10]
    let result = diff(o, n)
    XCTAssertEqual([.delete(1), .delete(8), .move(7, 4), .insert(6), .move(5, 7), .insert(8)], result)
  }

  func testDeletionLeadingToInsertionDeletionMovesWithOrder() {
    let o = [0, 1, 2, 3, 4, 5, 6, 7, 8]
    let n = [0, 2, 3, 4, 7, 6, 9, 5, 10]
    let result = orderedDiff(o, n)
    XCTAssertEqual([.delete(8), .delete(7), .delete(5), .delete(1), .insert(4), .insert(6), .insert(7), .insert(8)], result)
  }

  func testMovingWithEqualityChanges() {
    let o = [
      FakeItem(value: 0, eValue: 0),
      FakeItem(value: 1, eValue: 1),
      FakeItem(value: 2, eValue: 2)
    ]
    let n = [
      FakeItem(value: 2, eValue: 3),
      FakeItem(value: 1, eValue: 1),
      FakeItem(value: 0, eValue: 0)
    ]
    let result = orderedDiff(o, n)
    XCTAssertEqual([.delete(2), .delete(0), .insert(0), .insert(2), .update(0)], result)
  }

  func testDeletingEqualObjects() {
    let o = [0, 0, 0, 0]
    let n = [0, 0]
    let result = diff(o, n)
    XCTAssertEqual(2, result.count)
  }

  func testInsertingEqualObjects() {
    let o = [0, 0]
    let n = [0, 0, 0, 0]
    let result = diff(o, n)
    XCTAssertEqual(2, result.count)
  }

  func testInsertingWithOldArrayHavingMultipleCopies() {
    let o = [NSObject(), NSObject(), NSObject(), 49, 33, "cat", "cat", 0, 14] as [AnyHashable]
    var n = o
    n.insert("cat", at: 5)
    let result = diff(o, n)
    XCTAssertEqual(1, result.count)
  }
}
