//
//  WeeklyCalendarView.swift
//  FlipMate
//
//  Created by 임현규 on 2024/01/07.
//

import UIKit

enum CalendarScrollState {
    case left
    case none
    case right
}
    
protocol WeeklyCalendarViewDelegate: AnyObject {
    func didSelectDate(_ date: Date)
    func deSelectDate(_ date: Date)
}

final class WeeklyCalendarView: UIView {
    typealias CalendarDataSource = UICollectionViewDiffableDataSource<WeeklySection, WeeklySectionItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<WeeklySection, WeeklySectionItem>
    
    // MARK: - Properties
    weak var delegate: WeeklyCalendarViewDelegate?

    private var dataSource: CalendarDataSource?
    private let calendarManager = CalendarManager()
    
    private var calendarScrollState: CalendarScrollState = .none
    private var isfirstLayoutUpdated: Bool = false
    
    private var selectedDate: String = {
        let today = Date()
        return today.dateToString(format: .yyyyMMdd)
    }()
    
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
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureWeekStackView()
        setDataSource()
        setSnapshot()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Don't use StoryBoard")
    }
    
    // MARK: - Life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        selectTodayItem()
    }
}

// MARK: - DiffableDataSource
private extension WeeklyCalendarView {
    func setDataSource() {
        dataSource = CalendarDataSource(
            collectionView: weekCollectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                switch itemIdentifier {
                case .dateCell(let date):
                    let cell: WeekCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                    cell.updateDate(date)
                    
                    if self.selectedDate == date {
                        cell.showCircleView()
                        self.weekCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
                    } else {
                        cell.hideCircleView()
                    }
                    
                    return cell
                }
            })
    }
    
    func setSnapshot() {
        var snapshot = Snapshot()
        let sections: [WeeklySection] = [.section([])]
        let currentWeekItem = calendarManager.currentWeekItem()
        let previousWeekItem = calendarManager.previousWeekItem()
        let nextWeekItem = calendarManager.nextWeekItem()
        snapshot.appendSections(sections)
        snapshot.appendItems(previousWeekItem)
        snapshot.appendItems(currentWeekItem)
        snapshot.appendItems(nextWeekItem)
        dateLabel.text = monthTitle(from: calendarManager.currentWeek)
        dataSource?.apply(snapshot)
    }
    
    func findItemIndex(at date: String) -> Int? {
        guard let snapshot = dataSource?.snapshot(),
              let targetItem = snapshot.itemIdentifiers.filter({ $0.date == date }).first else { return nil }
        return snapshot.indexOfItem(targetItem)
    }
    
    func selectItem(at date: Date) {
        guard let targetIndex = findItemIndex(at: date.dateToString(format: .yyyyMMdd)) else { return }
        let indexPath = IndexPath(row: targetIndex, section: 0)
        weekCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        delegate?.didSelectDate(date)
    }
}

// MARK: - Scroll
private extension WeeklyCalendarView {
    func didScrollCalendar(calendarScrollState: CalendarScrollState) {
        var snapshot = Snapshot()
        let sections: [WeeklySection] = [.section([])]
        calendarManager.updateCurrentWeek(calendarScrollState: calendarScrollState)
        let currentWeekItem = calendarManager.currentWeekItem()
        let previousWeekItem = calendarManager.previousWeekItem()
        let nextWeekItem = calendarManager.nextWeekItem()
        snapshot.appendSections(sections)
        snapshot.appendItems(previousWeekItem)
        snapshot.appendItems(currentWeekItem)
        snapshot.appendItems(nextWeekItem)
        dateLabel.text = monthTitle(from: calendarManager.currentWeek)
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
        guard let week = DateFormatter().shortWeekdaySymbols else { return }
        week.forEach {
            let label = UILabel()
            label.text = $0
            label.font = FlipMateFont.mediumBold.font
            label.textAlignment = .center
            weekStackView.addArrangedSubview(label)
        }
    }
    
    func selectTodayItem() {
        if !isfirstLayoutUpdated {
            selectItem(at: Date())
            isfirstLayoutUpdated.toggle()
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

// MARK: - UICollectionViewDelegate
extension WeeklyCalendarView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? WeekCollectionViewCell else { return }
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        guard let selectedDate = item.date.toDate(.yyyyMMdd) else { return }
        cell.showCircleView()
        self.selectedDate = item.date
        delegate?.didSelectDate(selectedDate)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? WeekCollectionViewCell else { return }
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        guard let deSelectedDate = item.date.toDate(.yyyyMMdd) else { return }
        cell.hideCircleView()
        delegate?.deSelectDate(deSelectedDate)
    }
}

// MARK: - UIScrollViewDelegate
extension WeeklyCalendarView: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        switch targetContentOffset.pointee.x {
        case 0:
            calendarScrollState = .left
        case frame.width:
            calendarScrollState = .none
        case frame.width * CGFloat(2):
            calendarScrollState = .right
        default:
            return
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        didScrollCalendar(calendarScrollState: calendarScrollState)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
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

// MARK: - Constant
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
