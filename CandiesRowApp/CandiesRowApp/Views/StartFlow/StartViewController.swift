//
//  ViewController.swift
//  CandiesRowApp
//
//  Created by Василий Вырвич on 8.04.24.
//

import UIKit
import SnapKit

final class StartViewController: UIViewController {
    //MARK: - Variables
    
    private let backImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "candy")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemPink
        return indicator
    }()
    
    private var logoImageView: UIImageView = {
        let image = UIImage(named: "lollipops")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var percentlabel: UILabel = {
        let lable = UILabel()
        lable.textColor = .systemPink
        return lable
    }()
    
    private var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()
    
    //MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        setUpView()
        startAnimating()
    }
    
    private func setUpView() {
        view.addSubview(backImageView)
        view.addSubview(stackView)
        view.addSubview(logoImageView)
        setUpStackView()
        updateViewConstraints()
    }
    
    private func setUpStackView() {
        stackView.addArrangedSubview(activityIndicator)
        stackView.addArrangedSubview(percentlabel)
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
        gradientLayer.frame = view.bounds

        view.layer.addSublayer(gradientLayer)
    }
    
    private func startAnimating() {
        activityIndicator.startAnimating()

        // Ложная загрузка до 100%
        var progress: Float = 0.0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            progress += 0.1

            self.percentlabel.text = "\(Int(progress * 100))%"
            if progress >= 1.0 {
                timer.invalidate()
                self.activityIndicator.stopAnimating()
                // Перейти на главный экран
                let vc = MainViewController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        }
    }
    
    //MARK: - Constraints
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        backImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-200)
            make.height.width.equalTo(281)
            make.centerX.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom)
            make.height.equalTo(260)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(logoImageView.snp.top).offset(-30)
            make.width.equalTo(95)
            make.height.equalTo(30)
        }
    }
}

