//
//  CustomBackgroundView.swift
//  CandiesRowApp
//
//  Created by Василий Вырвич on 8.04.24.
//

import UIKit
import SnapKit

class CustomBackgroundView: UIView {
    
    //MARK: - Varibles
    private var flowImageView: UIImageView = {
        let flowImage = UIImage(named: "flowPicture")
        let imageView = UIImageView(image: flowImage)
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var lollipopsImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "lollipops"))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setGradientBackground()
        
        addSubview(flowImageView)
        addSubview(lollipopsImageView)
        
        updateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setGradientBackground() {
        let colorTop = UIColor(red: 250/255,
                               green: 205/255,
                               blue: 212/255,
                               alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 247/255,
                                  green: 174/255,
                                  blue: 191/255,
                                  alpha: 1.0).cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds

        self.layer.addSublayer(gradientLayer)
    }
    
    //MARK: - Constraints
    override func updateConstraints() {
        super.updateConstraints()
        
        flowImageView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.width.equalToSuperview()
            make.height.lessThanOrEqualTo(self.snp.height).dividedBy(2)
        }
        
        lollipopsImageView.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing).dividedBy(1.8)
            make.height.equalTo(200)
        }
    }
}
