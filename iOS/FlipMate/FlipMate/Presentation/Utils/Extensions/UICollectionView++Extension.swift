//
//  UICollectionView++Extension.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/20.
//

import UIKit

extension UICollectionView {
    /// UICollectionViewCell을 상속하는 Cell 타입을 전달받아 해당 Cell을 collectionView에 등록합니다.
    func register<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    /// IndexPath에 따라 전달받은 Cell 타입에 맞는 Cell을 가져옵니다.
    /// 만약 전달받은 T 타입으로 캐스팅 할 수 없으면 fatalError 발생시킵니다.
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("identifier가 \(T.defaultReuseIdentifier)인 Cell을 dequeue할 수 없습니다.")
        }
        return cell
    }
}
