//
//  ImageTableViewCell.swift
//  ExImageCache
//
//  Created by 김종권 on 2021/10/28.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    static let identifier = String(describing: ImageTableViewCell.self)

    var model: UIImage? { didSet { bind() } }

    private lazy var imagesView: UIImageView = {
        let view = UIImageView()
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        makeConstraints()
    }

    private func addSubviews() {
        contentView.addSubview(imagesView)
    }

    private func makeConstraints() {
        imagesView.translatesAutoresizingMaskIntoConstraints = false
        imagesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imagesView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imagesView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imagesView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    }

    private func bind() {
        imagesView.image = model
    }

    required init?(coder: NSCoder) { fatalError("init?(coder: NSCoder) is not implemented") }
}
