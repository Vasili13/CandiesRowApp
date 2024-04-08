//
//  CustomCollectionViewCell.swift
//  CandiesRowApp
//
//  Created by Василий Вырвич on 8.04.24.
//

import UIKit
import SnapKit

final class CustomCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(45)
        }
    }
}
