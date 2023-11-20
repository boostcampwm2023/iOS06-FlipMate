//
//  UICollectionView++Extension.swift
//  FlipMate
//
//  Created by 임현규 on 2023/11/20.
//

import UIKit

extension UICollectionView {
    enum SupplementaryViewKind {
        case header
        case footer
        
        var identifier: String {
            switch self {
            case .header:
                return UICollectionView.elementKindSectionHeader
            case .footer:
                return UICollectionView.elementKindSectionFooter
            }
        }
    }
    
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
    
    /// UICollectionReusableView을 상속하는 ReusableView 타입과 종류를 전달받아 해당 ReusableVeiw을 collectionView에 등록합니다.
    func register<T: UICollectionReusableView>(_: T.Type, kind: SupplementaryViewKind) {
        register(T.self,
                 forSupplementaryViewOfKind: kind.identifier,
                 withReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    /// IndexPath와 ReusableView 종류에 따라 전달받은 ReusableView 타입에 맞는 ReusableView을 가져옵니다.
    /// 만약 전달받은 T 타입으로 캐스팅 할 수 없으면 fatalError 발생시킵니다.
    func dequeueReusableView<T: UICollectionReusableView>(for indexPath: IndexPath, kind: String) -> T {
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("identifier가 \(T.defaultReuseIdentifier)인 View을 dequeue할 수 없습니다.")
        }
        return view
    }
}
