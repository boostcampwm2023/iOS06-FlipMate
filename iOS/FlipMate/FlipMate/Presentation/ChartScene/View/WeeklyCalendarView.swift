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
    
    // MARK: - Properties
    private enum ScrollState {
        case left
        case none
        case right
    }
    
    private var dataSource: CalendarDataSource?
    private var scrollState: ScrollState = .none
    private var currentWeekDate = Date()
    private var calendar = Calendar.current
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = FlipMateFont.semiLargeBold.font
        return label
    }()
    
    private let weekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var weekCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(WeekCollectionViewCell.self)
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureWeekStackView()
        setDataSource()
        setSnapshot()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.weekCollectionView.scrollToItem(at: IndexPath(row: Constant.currentWeekSundayIndex, section: 0), at: .centeredHorizontally, animated: false)
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
        let currentWeekDate = Date()
        let lastWeekDate = addDays(date: currentWeekDate, days: Constant.lastWeekValue)
        let nextWeekDate = addDays(date: currentWeekDate, days: Constant.nextWeekValue)
        snapshot.appendSections(sections)
        snapshot.appendItems(weekendItem(lastWeekDate))
        snapshot.appendItems(weekendItem(currentWeekDate))
        snapshot.appendItems(weekendItem(nextWeekDate))
        dateLabel.text = monthTitle(from: currentWeekDate)
        dataSource?.apply(snapshot)
    }
}

private extension WeeklyCalendarView {
    func weekendItem(_ date: Date) -> [WeeklySectionItem] {
        var weekendDate = [Int]()
        var current = findSunday(date: date)
        let nextSunday = addDays(date: current, days: Constant.nextWeekValue)
        
        while current < nextSunday {
            guard let date = Int(current.dateToString(format: .day)) else { continue }
            weekendDate.append(date)
            current = addDays(date: current, days: 1)
        }
        
        return weekendDate.map { WeeklySectionItem.dateCell($0) }
    }
    
    func findSunday(date: Date) -> Date {
        var current = date
        let oneWeekAgo = addDays(date: current, days: Constant.lastWeekValue)
        
        while current > oneWeekAgo {
            let currentWeekDay = calendar.dateComponents([.weekday], from: current).weekday
            if currentWeekDay == 1 {
                return current
            }
            current = addDays(date: current, days: -1)
        }
        return current
    }
    
    func addDays(date: Date, days: Int) -> Date {
        return calendar.date(byAdding: .day, value: days, to: date) ?? Date()
    }
}

private extension WeeklyCalendarView {
    func leftScroll() {
        var snapshot = Snapshot()
        let sections: [WeeklySection] = [.section([])]
        let followingWeekDate = currentWeekDate
        currentWeekDate = addDays(date: followingWeekDate, days: Constant.lastWeekValue)
        let previousWeekDate = addDays(date: currentWeekDate, days: Constant.lastWeekValue)
        snapshot.appendSections(sections)
        snapshot.appendItems(weekendItem(previousWeekDate))
        snapshot.appendItems(weekendItem(currentWeekDate))
        snapshot.appendItems(weekendItem(followingWeekDate))
        dateLabel.text = monthTitle(from: currentWeekDate)
        dataSource?.apply(snapshot, animatingDifferences: false)
        weekCollectionView.scrollToItem(at: IndexPath(row: Constant.currentWeekSundayIndex, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    func rightScroll() {
        var snapshot = Snapshot()
        let sections: [WeeklySection] = [.section([])]
        let previousWeekDate = currentWeekDate
        currentWeekDate = addDays(date: previousWeekDate, days: Constant.nextWeekValue)
        let followingWeekDate = addDays(date: currentWeekDate, days: Constant.nextWeekValue)
        snapshot.appendSections(sections)
        snapshot.appendItems(weekendItem(previousWeekDate))
        snapshot.appendItems(weekendItem(currentWeekDate))
        snapshot.appendItems(weekendItem(followingWeekDate))
        dateLabel.text = monthTitle(from: currentWeekDate)
        dataSource?.apply(snapshot, animatingDifferences: false)
        weekCollectionView.scrollToItem(at: IndexPath(row: Constant.currentWeekSundayIndex, section: 0), at: .centeredHorizontally, animated: false)
    }
}

private extension WeeklyCalendarView {
    func configureUI() {
        [ dateLabel, weekStackView, weekCollectionView ] .forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constant.top),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.leading),
            
            weekStackView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Constant.top),
            weekStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.leading),
            weekStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constant.trailing),
            
            weekCollectionView.topAnchor.constraint(equalTo: weekStackView.bottomAnchor, constant: Constant.top),
            weekCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            weekCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            weekCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configureWeekStackView() {
        // TODO: - 다국어 지원
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
    func monthTitle(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy MMM")
        return dateFormatter.string(from: date)
    }
}

extension WeeklyCalendarView: UICollectionViewDelegate, UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        switch targetContentOffset.pointee.x {
        case 0:
            scrollState = .left
        case frame.width:
            scrollState = .none
        case frame.width * CGFloat(2):
            scrollState = .right
        default:
            return
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch scrollState {
        case .left:
            leftScroll()
        case .none:
            return
        case .right:
            rightScroll()
        }
    }
}

extension WeeklyCalendarView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: frame.width / Constant.weeklyCount, height: Constant.cellHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return Constant.cellSpacing
    }
}

private extension WeeklyCalendarView {
    enum Constant {
        static let currentWeekSundayIndex = 7
        static let lastWeekValue = -7
        static let nextWeekValue = 7
        
        static let top: CGFloat = 20
        static let bottom: CGFloat = 20
        static let leading: CGFloat = 20
        static let trailing: CGFloat = -20
        
        static let weeklyCount: CGFloat = 7
        static let cellHeight: CGFloat = 30
        static let cellSpacing: CGFloat = 0
    }
}
