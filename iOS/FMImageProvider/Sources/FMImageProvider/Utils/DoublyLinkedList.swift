//
//  File.swift
//
//
//  Created by 권승용 on 4/2/24.
//

import Foundation

final class DoublyLinkedList<T: Equatable> {
    final class Node {
        var prev: Node?
        var next: Node?
        let data: T
        
        init(data: T) {
            self.data = data
        }
    }
    
    var head: Node?
    var tail: Node?
    
    var isEmpty: Bool {
        return head == nil
    }
    
    func append(_ data: T) {
        let newNode = Node(data: data)
        
        if isEmpty {
            head = newNode
            tail = newNode
        } else {
            tail?.next = newNode
            newNode.prev = tail
            tail = newNode
        }
    }
    
    func prepend(_ data: T) {
        let newNode = Node(data: data)
        
        if isEmpty {
            head = newNode
            tail = newNode
        } else {
            head?.prev = newNode
            newNode.next = head
            head = newNode
        }
    }
    
    func pop() -> T? {
        if isEmpty {
            return nil
        } else {
            return remove(node: tail!)
        }
    }
    
    func popFirst() -> T? {
        if isEmpty {
            return nil
        } else {
            return remove(node: head!)
        }
    }
    
    func insert(after node: Node, _ data: T) {
        let newNode = Node(data: data)
        if node === tail {
            append(data)
        } else {
            newNode.next = node.next
            node.next?.prev = newNode
            newNode.prev = node
            node.next = newNode
        }
    }
    
    func remove(node: Node) -> T? {
        if node === head {
            head = node.next
            head?.prev = nil
            if head == nil {
                tail = nil
            }
        } else if node === tail {
            tail = node.prev
            tail?.next = nil
        } else {
            node.prev?.next = node.next
            node.next?.prev = node.prev
        }
        return node.data
    }
}
