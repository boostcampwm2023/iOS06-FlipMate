//
//  File.swift
//
//
//  Created by 권승용 on 4/2/24.
//

import Foundation

class Node<T: Equatable> {
    var prev: Node?
    var next: Node?
    let data: T
    
    init(data: T) {
        self.data = data
    }
}

class DoublyLinkedList<T: Equatable> {
    var head: Node<T>?
    var tail: Node<T>?
    
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
    
    func insert(after node: Node<T>, _ data: T) {
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
    
    func remove(node: Node<T>) -> T? {
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
