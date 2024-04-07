//
//  File.swift
//  
//
//  Created by 권승용 on 4/2/24.
//

import Foundation

struct CacheData: Equatable {
    var cost: Int
    var key: String
    var data: Data
    
    init(cost: Int, key: String, data: Data) {
        self.cost = cost
        self.key = key
        self.data = data
    }
}

class LRUCache {
    typealias Node = DoublyLinkedList<CacheData>.Node
    
    var nodeList = DoublyLinkedList<CacheData>()
    var nodeDict: [String: Node] = [:]
    private let capacity: Int
    private var currentCost: Int
    
    init(capacity: Int) {
        self.capacity = capacity
        self.currentCost = 0
    }
    
    func get(_ key: String) -> CacheData? {
        guard let node = nodeDict[key] else {
            return nil
        }
        moveToHead(key, node)
        return node.data
    }
    
    func insert(_ key: String, _ value: CacheData) {
        if let oldNode = nodeDict[key] {
            remove(key, oldNode)
        }
        let newNode = Node(data: value)
        insertToHead(key, newNode)
        checkCapacityAndClearCache()
    }
}

private extension LRUCache {
    func moveToHead(_ key: String, _ node: Node) {
        remove(key, node)
        insertToHead(key, node)
    }
    
    func remove(_ key: String, _ node: Node) {
        _ = nodeList.remove(node: node)
        currentCost -= node.data.cost
        nodeDict[key] = nil
    }

    func insertToHead(_ key: String, _ node: Node) {
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
