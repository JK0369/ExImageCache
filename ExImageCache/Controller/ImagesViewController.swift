//
//  ImagesViewController.swift
//  ExImageCache
//
//  Created by 김종권 on 2021/10/28.
//

import UIKit

class ImagesViewController: UIViewController {

    private var dataSource: UITableViewDiffableDataSource<Section, ImageItem>!

    lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(ImageTableViewCell.self, forCellReuseIdentifier: ImageTableViewCell.identifier)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDiffableDataSouce()
        addSubviews()
        makeConstraints()
        requestItunesImages()
    }

    private func setupViews() {
        title = "iOS 앱 개발 알아가기 (ImageCache)"
        navigationController?.hidesBarsOnSwipe = true
    }

    private func setupDiffableDataSouce() {
        dataSource = UITableViewDiffableDataSource<Section, ImageItem>(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifier, for: indexPath) as! ImageTableViewCell
            cell.model = itemIdentifier.image
            ImageCache.shared.load(url: itemIdentifier.imageUrl as NSURL, item: itemIdentifier) { originItem, fetchedImage in
                guard let fetchedImage = fetchedImage, fetchedImage != originItem.image,
                      let originItem = originItem as? ImageItem else { return }
                originItem.image = fetchedImage
                var snapshot = self.dataSource.snapshot()
                snapshot.reloadItems([originItem])
                self.dataSource.apply(snapshot, animatingDifferences: true)
            }
            return cell
        }
    }

    private func addSubviews() {
        view.addSubview(tableView)
    }

    private func makeConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }

    private func requestItunesImages() {
        ItunesAPI.fetchImages { [weak self] result in
            switch result {
            case .success(let itunesImageModel):
                guard var snapshot = self?.dataSource.snapshot() else { return }
                if snapshot.sectionIdentifiers.isEmpty == true { snapshot.appendSections([.main]) }
                let placeholderImage = UIImage(systemName: "rectangle")!
                let urlStrs = itunesImageModel.results.compactMap { $0.screenshotUrls.first }
                let urls = urlStrs.compactMap { URL(string: $0) }
                let imageItems = urls.map { return ImageItem(image: placeholderImage, imageUrl: $0) }
                snapshot.appendItems(imageItems)
                self?.dataSource.apply(snapshot)
            case .failure(let error):
                print(error)
            }
        }
    }
}
