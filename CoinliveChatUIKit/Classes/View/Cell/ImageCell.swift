//
//  ImageCell.swift
//  CoinliveChatUIKit
//
//  Created by Parkjonghyun on 2022/12/14.
//
import UIKit

final class ImageCell: UICollectionViewCell {
    static let id = "MyCell"
    
    
    private weak var imageView: UIImageView?
    
    // MARK: Initializer
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 6.0
        iv.clipsToBounds = true
        self.contentView.addSubview(iv)
        self.imageView = iv
        
        NSLayoutConstraint.activate([
            iv.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            iv.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            iv.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            iv.topAnchor.constraint(equalTo: self.contentView.topAnchor),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.prepare(image: nil)
    }
    
    func prepare(image: UIImage?) {
        self.imageView?.image = image
    }
}
