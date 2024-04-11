//
//  File.swift
//  
//
//  Created by 권승용 on 4/2/24.
//

import Foundation

struct LRUCacheData: Equatable, Codable {
    let cost: Int
    let filePath: String
    
    init(cost: Int, key: String) {
        self.cost = cost
        self.filePath = key
    }
}

class LRUCache {
    typealias Node = DoublyLinkedList<LRUCacheData>.Node
    
    var nodeList = DoublyLinkedList<LRUCacheData>()
    var nodeDict: [String: Node] = [:]
    private let capacity: Int
    private var currentCost: Int
    
    /// capacity와 함께 LRU캐시 초기화. 각 데이터들의 cost 합이 capacity를 넘으면 가장 오래전에 사용된 데이터를 캐시에서 제거한다.
    /// - Parameter capacity: 디스크 캐시 최대 용량
    init(capacity: Int) {
        self.capacity = capacity
        self.currentCost = 0
    }
    
    /// key에 대응하는 data를 반환하는 함수
    /// - Parameter key: 이미지 url로부터 생성된 key
    /// - Returns: key에 대응하는 캐시 데이터
    func get(_ key: String) -> LRUCacheData? {
        guard let node = nodeDict[key] else {
            return nil
        }
        moveToHead(key, node)
        return node.data
    }
    
    /// LRU 캐시에 데이터를 저장하는 함수
    /// - Parameters:
    ///   - key: 이미지 url로부터 생성된 key
    ///   - value: key에 대응하는 캐시 데이터
    func insert(_ key: String, _ value: LRUCacheData) {
        if let oldNode = nodeDict[key] {
            remove(key, oldNode)
        }
        let newNode = Node(data: value)
        insertToHead(key, newNode)
        checkCapacityAndClearCache()
    }
    
    /// LRU캐시를 전부 초기화하는 함수
    func removeAll() {
        nodeList = DoublyLinkedList<LRUCacheData>()
        nodeDict = [:]
        currentCost = 0
    }
    
    /// 이중연결리스트를 파일로 저장하기 위해 배열로 변환하는 함수
    /// - Returns: 배열로 변환된 데이터 목록
    func makeArray() -> [LRUCacheData] {
        var arr: [LRUCacheData] = []
        while true {
            guard let newValue = nodeList.popFirst() else {
                break
            }
            arr.append(newValue)
        }
        return arr
    }
    
    /// LRU 알고리즘을 적용 및 관리하기 위해 배열을 LRUCache 내부 자료구조로 변환하는 함수.
    /// 해당 자료구조는 이중연결리스트이다.
    /// - Parameter arr: 변환할 데이터 목록 배열
    func initWithArr(_ arr: [LRUCacheData]) {
        arr.reversed().forEach { cacheData in
            self.insert(cacheData.filePath, cacheData)
        }
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
            let key = tailNode.filePath
            nodeDict[key] = nil
        }
    }
}
