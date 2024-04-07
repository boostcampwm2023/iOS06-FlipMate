//
//  File.swift
//  
//
//  Created by 권승용 on 4/2/24.
//

import Foundation

protocol Cacheable: Equatable {
    associatedtype CacheKey: Hashable
    associatedtype CachedData
    
    var cost: Int { get set }
    var key: CacheKey { get set }
    var data: CachedData { get set }
    
    static func == (lhs: Self, rhs: Self) -> Bool
}

extension Cacheable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.key == rhs.key
    }
}

struct CacheData<Key: Hashable, Data>: Cacheable {
    typealias CacheKey = Key
    typealias CachedData = Data
    
    var cost: Int
    var key: CacheKey
    var data: CachedData
    
    init(cost: Int, key: CacheKey, data: CachedData) {
        self.cost = cost
        self.key = key
        self.data = data
    }
}

class LRUCache<Value: Cacheable> {
    typealias Key = Value.CacheKey
    typealias Node = DoublyLinkedList<Value>.Node
    
    var nodeList = DoublyLinkedList<Value>()
    var nodeDict: [Key: Node] = [:]
    private let capacity: Int
    private var currentCost: Int
    
    init(capacity: Int) {
        self.capacity = capacity
        self.currentCost = 0
    }
    
    func get(_ key: Key) -> Value? {
        guard let node = nodeDict[key] else {
            return nil
        }
        moveToHead(key, node)
        return node.data
    }
    
    func insert(_ key: Key, _ value: Value) {
        if let oldNode = nodeDict[key] {
            remove(key, oldNode)
        }
        let newNode = Node(data: value)
        insertToHead(key, newNode)
        checkCapacityAndClearCache()
    }
}

private extension LRUCache {
    func moveToHead(_ key: Key, _ node: Node) {
        remove(key, node)
        insertToHead(key, node)
    }
    
    func remove(_ key: Key, _ node: Node) {
        _ = nodeList.remove(node: node)
        currentCost -= node.data.cost
        nodeDict[key] = nil
    }

    func insertToHead(_ key: Key, _ node: Node) {
        nodeList.prepend(node.data)
        currentCost += node.data.cost
        nodeDict[key] = node
    }
    
    func checkCapacityAndClearCache() {
        while currentCost > capacity {
            guard let tailNode = nodeList.pop() else {
                break
            }
            currentCost -= tailNode.cost
            let key = tailNode.key
            nodeDict[key] = nil
        }
    }
}
