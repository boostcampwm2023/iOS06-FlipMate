//
//  WeeklyCalendarView.swift
//  FlipMate
//
//  Created by 임현규 on 2024/01/07.
//

import UIKit

final class WeeklyCalendarView: UIView {
    typealias CalendarDataSource = UICollectionViewDiffableDataSource<WeeklySection, WeeklySectionItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<WeeklySection, WeeklySectionItem>
    
    private var dataSource: CalendarDataSource?
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = FlipMateFont.semiLargeBold.font
        label.text = "2024년 1월"
        return label
    }()
    
    private let weekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var weekCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: setCollectionViewLayout())
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(WeekCollectionViewCell.self)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureWeekStackView()
        setDataSource()
        setSnapshot()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension WeeklyCalendarView {
    func setDataSource() {
        dataSource = CalendarDataSource(
            collectionView: weekCollectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                switch itemIdentifier {
                case .dateCell(let date):
                    let cell: WeekCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                    cell.updateDate(date)
                    return cell
                }
            })
    }
    
    func setSnapshot() {
        var snapshot = Snapshot()
        let sections: [WeeklySection] = [.section([])]
        snapshot.appendSections(sections)
        snapshot.appendItems([.dateCell(1), .dateCell(2), .dateCell(3), .dateCell(4), .dateCell(5), .dateCell(6), .dateCell(7), .dateCell(8), .dateCell(9), .dateCell(10), .dateCell(11), .dateCell(12), .dateCell(13), .dateCell(14)])
        dataSource?.apply(snapshot)
    }
}

private extension WeeklyCalendarView {
    func configureUI() {
        [ dateLabel, weekStackView, weekCollectionView ] .forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            weekStackView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            weekStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            weekStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            weekCollectionView.topAnchor.constraint(equalTo: weekStackView.bottomAnchor, constant: 20),
            weekCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            weekCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            weekCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configureWeekStackView() {
        let week = ["일", "월", "화", "수", "목", "금", "토"]
        week.forEach {
            let label = UILabel()
            label.text = $0
            label.font = FlipMateFont.mediumBold.font
            label.textAlignment = .center
            weekStackView.addArrangedSubview(label)
        }
    }
}

private extension WeeklyCalendarView {
    func makeLayoutSection(sectionType: WeeklySection) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: sectionType.itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: sectionType.groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    func setCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let sectionType = self?.dataSource?.snapshot().sectionIdentifiers[sectionIndex] else { return nil }
            return self?.makeLayoutSection(sectionType: sectionType)
        }
    }
}
