//
//  ViewController.swift
//  weather
//
//  Created by Joseph Grist on 10/12/21.
//

import UIKit
import SwiftMessages

class ForecastViewController: UICollectionViewController {

    var dataSource: UICollectionViewDiffableDataSource<Int, UUID>?
    let weatherHeaderReuseIdentifier = "WeatherHeader"
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: App.errorNotification, object: nil, queue: .main) {
            [weak self] notification in self?.handleError(notification: notification)
        }
        
        NotificationCenter.default.addObserver(forName: App.newDataIsReady, object: nil, queue: .main) {
            [weak self] notification in self?.onNewDataReady(notification: notification)
        }
        
        collectionView.register(UINib(nibName: weatherHeaderReuseIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: weatherHeaderReuseIdentifier)
        
        dataSource = UICollectionViewDiffableDataSource<Int, UUID>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: UUID) -> UICollectionViewCell? in
            
            func setCommon(weather: CurrentWeather, cell: ForecastCell) {
                cell.temperatureLabel?.text = weather.tempFormatted
                cell.stateLabel?.text = weather.stateName
                cell.setWindDirection(to: weather.windDirection)
                cell.icon?.image = weather.icon
            }
            
            let sectionType = SectionLayoutKind(rawValue: indexPath.section)
            switch sectionType {
            case .Today:
                guard
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodayForecastCell", for: indexPath) as? TodayForecastCell,
                    let weather = App.instance.dataManager.getEntry(uuid: itemIdentifier) else {
                    return nil
                }
                
                setCommon(weather: weather, cell: cell)
                
                cell.maxTemp?.text = weather.minTempFormatted
                cell.minTemp?.text = weather.maxTempFormatted
                cell.windSpeed?.text = weather.windSpeedFormatted
                
                return cell
            case .UpcomingDays:
                guard
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingForecastCell", for: indexPath) as? UpcomingForecastCell,
                    let weather = App.instance.dataManager.getEntry(uuid: itemIdentifier) else {
                    return nil
                }
                
                setCommon(weather: weather, cell: cell)

                if let date = weather.date {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "EEEE"
                    let weekDay = dateFormatter.string(from: date)
                    cell.dayLabel?.text = "\(weekDay) \(Calendar.current.component(.day, from: date))"
                }

                return cell
            case .Sources:
                guard
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastSourceCell", for: indexPath) as? ForecastSourceCell,
                    let source = App.instance.dataManager.getSource(uuid: itemIdentifier) else {
                    return nil
                }
                cell.nameLabel?.text = source.title
                cell.safariIcon?.image = UIImage(systemName: "safari")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(paletteColors: [.systemCyan, .systemGray]))
                return cell
            default:
                break
            }
            
            return nil
        }
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard
                kind == UICollectionView.elementKindSectionHeader,
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.weatherHeaderReuseIdentifier, for: indexPath) as? WeatherHeader else {
                return nil
            }
            header.setTitle(to: SectionLayoutKind(rawValue: indexPath.section)?.header)
            return header
        }
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        update(animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getNewWeather()
    }
    
    func getNewWeather() {
        Task {
            await App.instance.weatherManager.refresh()
        }
    }
    
    func handleError(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let error = userInfo[App.errorNotificationMessageUserInfoKey] as? String else {
                return
            }
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.warning)
        view.configureContent(title: "Error", body: error, iconImage: UIImage(systemName: "exclamationmark.triangle")!)
        SwiftMessages.show(view: view)
    }

    func update(animated: Bool) {
        let snapshot = App.instance.weatherManager.makeSnapshot()
        dataSource?.apply(snapshot, animatingDifferences: animated)
        refreshControl.endRefreshing()
        collectionView.reloadData()
    }
    
    func onNewDataReady(notification: Notification?) {
        update(animated: true)
    }
    
    var layout: UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionLayoutKind = SectionLayoutKind(rawValue: sectionIndex) else { return nil }
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(sectionLayoutKind.estimatedHeight)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: sectionLayoutKind.groupSize, subitem: item, count: sectionLayoutKind.columns)
            group.interItemSpacing = .fixed(2)
            let section = NSCollectionLayoutSection(group: group)
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40.0))
            if let _ = sectionLayoutKind.header {
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                section.boundarySupplementaryItems = [header]
            }
            section.interGroupSpacing = 2
            section.contentInsetsReference = .readableContent
            section.orthogonalScrollingBehavior = sectionLayoutKind.scrollingBehaviour
            return section
        }
        return layout
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let sources = App.instance.dataManager.getSources()
        
        if  indexPath.section == SectionLayoutKind.Sources.rawValue,
            sources.indices.contains(indexPath.row),
            let url = sources[indexPath.row].url {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if indexPath.section == SectionLayoutKind.Sources.rawValue {
            collectionView.cellForItem(at: indexPath)?.contentView.backgroundColor = .secondarySystemBackground
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if indexPath.section == SectionLayoutKind.Sources.rawValue {
            collectionView.cellForItem(at: indexPath)?.contentView.backgroundColor = .systemBackground
        }
    }
    
    @objc func didPullToRefresh(_ sender: AnyObject?) {
        refreshControl.beginRefreshing()
        getNewWeather()
    }
}

enum SectionLayoutKind: Int, CaseIterable {
    case Today
    case UpcomingDays
    case Sources
    
    var columns: Int {
        switch self {
        case .UpcomingDays:
            return 6
        default:
            return 1
        }
    }
  
    var groupSize: NSCollectionLayoutSize {
        
        let width: CGFloat
        
        switch self {
        case .UpcomingDays:
            width = 2.5
        default:
            width = 1
        }
        
        return NSCollectionLayoutSize(widthDimension: .fractionalWidth(width), heightDimension: .estimated(20))
    }
    
    var scrollingBehaviour: UICollectionLayoutSectionOrthogonalScrollingBehavior {
        switch self {
        case .UpcomingDays:
            return .continuous
        default:
            return .none
        }
    }
    
    var header: String? {
        switch self {
        case .Today:
            return nil
        case .UpcomingDays:
            return "This Week"
        case .Sources:
            return "Source"
        }
    }
    
    var estimatedHeight: CGFloat {
        switch self {
        case .Today:
            return 200
        case .UpcomingDays:
            return 150
        case .Sources:
            return 30
        }
    }
}
