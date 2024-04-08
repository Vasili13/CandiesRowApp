//
//  CustomButton.swift
//  CandiesRowApp
//
//  Created by Василий Вырвич on 8.04.24.
//

import UIKit
import SnapKit

enum Color {
    case pink
    case purple
    case blue
    case gray
}

final class CustomButton: UIButton {
    
    //MARK: - Variables

    private let bigRectangle = UIView()
    private let smallRectangle = UIView()
    private let gradientLayerForHoleButton = CAGradientLayer()
    private let gradientLayerForRectangle = CAGradientLayer()
    
    //MARK: - Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
            
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        
        bigRectangle.layer.cornerRadius = 10
        bigRectangle.layer.masksToBounds = true
        self.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayerForHoleButton.frame = self.bounds
        gradientLayerForRectangle.frame = bigRectangle.bounds
        bigRectangle.layer.insertSublayer(gradientLayerForRectangle, at: 0)
        self.layer.insertSublayer(gradientLayerForHoleButton, at: 0)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 2
        self.layer.cornerRadius = 12
        gradientLayerForHoleButton.cornerRadius = 12
        self.layer.masksToBounds = false
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpBigRect() {
        bigRectangle.layer.cornerRadius = 10
        addSubview(bigRectangle)
        
        bigRectangle.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(5)
        }
        bigRectangle.isUserInteractionEnabled = false
    }
    
    private func setUpSmallRect(color: UIColor) {
        smallRectangle.backgroundColor = color
        smallRectangle.layer.cornerRadius = 8
        bigRectangle.addSubview(smallRectangle)
        
        smallRectangle.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(5)
            make.height.equalTo(bigRectangle.snp.height).dividedBy(2)
        }
        smallRectangle.isUserInteractionEnabled = false
    }
    
    private func setUpTitleLabel() {
        titleLabel?.layer.masksToBounds = false
        titleLabel?.layer.shadowColor = UIColor.black.cgColor
        titleLabel?.layer.shadowOffset = CGSize(width: 4, height: 4)
        titleLabel?.layer.shadowOpacity = 1
        titleLabel?.layer.shadowRadius = 2
        titleLabel?.font = UIFont(name: "Digitalt", size: 35)
    }
    
    func setUpButton(color: Color, title: String) -> UIButton {
        switch color {
        case .pink:
            gradientLayerForHoleButton.frame = self.bounds
            gradientLayerForHoleButton.colors = [UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0).cgColor,
                                    UIColor(red: 255/255, green: 59/255, blue: 160/255, alpha: 1.0).cgColor,
                                    UIColor(red: 232/255, green: 0/255, blue: 120/255, alpha: 1.0).cgColor]
            gradientLayerForHoleButton.locations = [0.0, 1.0]
            
            
            gradientLayerForRectangle.colors = [UIColor(red: 255/255, green: 156/255, blue: 207/255, alpha: 1).cgColor,
                           UIColor(red: 255/255, green: 153/255, blue: 206/255, alpha: 1).cgColor,
                           UIColor(red: 255/255, green: 102/255, blue: 181/255, alpha: 1).cgColor,
                           UIColor(red: 255/255, green: 59/255, blue: 160/255, alpha: 1).cgColor]
            gradientLayerForRectangle.startPoint = CGPoint(x: 0.5, y: 0.0) // Начальная точка градиента
            gradientLayerForRectangle.endPoint = CGPoint(x: 0.5, y: 1.0)
            
            setTitle(title, for: .normal)
            setTitleColor(.white, for: .normal)
            let colorForSmallRect = UIColor(red: 255/255, green: 204/255, blue: 250/255, alpha: 1)
            setUpBigRect()
            setUpSmallRect(color: colorForSmallRect)
            setUpTitleLabel()
            return self
        case .purple:
            gradientLayerForHoleButton.colors = [UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0).cgColor,
                                    UIColor(red: 222/255, green: 135/255, blue: 255/255, alpha: 1.0).cgColor,
                                    UIColor(red: 89/255, green: 33/255, blue: 144/255, alpha: 1.0).cgColor]
            gradientLayerForHoleButton.locations = [0.0, 1.0]
            
            gradientLayerForRectangle.colors = [UIColor(red: 216/255, green: 180/255, blue: 251/255, alpha: 1).cgColor,
                           UIColor(red: 168/255, green: 115/255, blue: 220/255, alpha: 1).cgColor,
                           UIColor(red: 89/255, green: 33/255, blue: 144/255, alpha: 1).cgColor,
                           UIColor(red: 123/255, green: 64/255, blue: 182/255, alpha: 1).cgColor]
            gradientLayerForRectangle.startPoint = CGPoint(x: 0.5, y: 0.0) // Начальная точка градиента
            gradientLayerForRectangle.endPoint = CGPoint(x: 0.5, y: 1.0)
            
            setTitle(title, for: .normal)
            setTitleColor(.white, for: .normal)
            let colorForSmallRect = UIColor(red: 255/255, green: 204/255, blue: 250/255, alpha: 1)
            setUpBigRect()
            setUpSmallRect(color: colorForSmallRect)
            setUpTitleLabel()
            return self
        case .blue:
            let colorTop = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0).cgColor
            let colorBottom = UIColor(red: 0/255, green: 182/255, blue: 232/255, alpha: 1).cgColor
            gradientLayerForHoleButton.colors = [colorTop, colorBottom]
            gradientLayerForHoleButton.startPoint = CGPoint(x: 0.5, y: 0.0) // Начальная точка градиента
            gradientLayerForHoleButton.endPoint = CGPoint(x: 0.5, y: 1.0)
            
            gradientLayerForRectangle.colors = [UIColor(red: 160/255, green: 235/255, blue: 255/255, alpha: 1).cgColor,
                           UIColor(red: 142/255, green: 231/255, blue: 255/255, alpha: 1).cgColor,
                           UIColor(red: 0/255, green: 182/255, blue: 232/255, alpha: 1).cgColor,
                           UIColor(red: 59/255, green: 163/255, blue: 240/255, alpha: 1).cgColor]
            gradientLayerForRectangle.startPoint = CGPoint(x: 0.5, y: 0.0) // Начальная точка градиента
            gradientLayerForRectangle.endPoint = CGPoint(x: 0.5, y: 1.0)
            
            setTitle(title, for: .normal)
            setTitleColor(.white, for: .normal)
            let colorForSmallRect = UIColor(red: 234/255, green: 250/255, blue: 254/255, alpha: 1)
            setUpBigRect()
            setUpSmallRect(color: colorForSmallRect)
            setUpTitleLabel()
            return self
        case .gray:
            let colorTop = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0).cgColor
            let colorBottom = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1).cgColor
            gradientLayerForHoleButton.colors = [colorTop, colorBottom]
            gradientLayerForHoleButton.startPoint = CGPoint(x: 0.5, y: 0.0) // Начальная точка градиента
            gradientLayerForHoleButton.endPoint = CGPoint(x: 0.5, y: 1.0)
            
            
            gradientLayerForRectangle.colors = [UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor,
                           UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1).cgColor,
                           UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1).cgColor,
                           UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1).cgColor]
            gradientLayerForRectangle.startPoint = CGPoint(x: 0.5, y: 0.0) // Начальная точка градиента
            gradientLayerForRectangle.endPoint = CGPoint(x: 0.5, y: 1.0)
            
            setTitle(title, for: .normal)
            setTitleColor(.white, for: .normal)
            let colorForSmallRect = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            setUpBigRect()
            setUpSmallRect(color: colorForSmallRect)
            setUpTitleLabel()
            return self
        }
    }
}
