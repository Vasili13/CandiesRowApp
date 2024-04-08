//
//  SettingsViewController.swift
//  CandiesRowApp
//
//  Created by Василий Вырвич on 8.04.24.
//

import UIKit
import WebKit
import StoreKit

final class SettingsViewController: UIViewController {

    //MARK: - Variables
    private var settingsLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.font = UIFont(name: "Digitalt", size: 52)
        label.textColor = .white
        return label
    }()
    
    private var backButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "homeButton")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(dismissSettingVC), for: .touchUpInside)
        return button
    }()
    
    private var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let usagePolicyWebView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = prefs
        let web = WKWebView(frame: .zero, configuration: configuration)
        return web
    }()
    
    private let closeWebViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "x.circle"), for: .normal)
        button.tintColor = .red
        return button
    }()
        
    private var usagePolicyButton = CustomButton(type: .system)
    private var shareAppButton = CustomButton(type: .system)
    private var rateUsButton = CustomButton(type: .system)

    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        updateViewConstraints()
    }
    
    private func setUpView() {
        view.addSubview(backButton)
        view.addSubview(settingsLabel)
        setUpStackView()
        view.addSubview(stackView)
        
        let backgroundView = CustomBackgroundView(frame: self.view.bounds)
        self.view.insertSubview(backgroundView, at: 0)
        
        usagePolicyButton.setUpButton(color: .gray, title: "Usage Policy")
        usagePolicyButton.addTarget(self, action: #selector(openUsagePolicyLink), for: .touchUpInside)
        shareAppButton.setUpButton(color: .gray, title: "Share App")
        shareAppButton.addTarget(self, action: #selector(openShareAppLink), for: .touchUpInside)
        rateUsButton.setUpButton(color: .gray, title: "Rate Us")
        rateUsButton.addTarget(self, action: #selector(openRateUsLink), for: .touchUpInside)
    }
    
    private func setUpStackView() {
        stackView.addArrangedSubview(usagePolicyButton)
        stackView.addArrangedSubview(shareAppButton)
        stackView.addArrangedSubview(rateUsButton)
    }
    
    @objc func dismissSettingVC() {
        dismiss(animated: true)
    }
    
    @objc func openUsagePolicyLink() {
        let webViewController = WebViewController()
        let navigationController = UINavigationController(rootViewController: webViewController)
                
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc func openShareAppLink() {
        guard let image = UIImage(systemName: "bell"), let url = URL(string: "https://www.google.ru/?hl=ru") else { return
        }
        let shareSheetVC = UIActivityViewController(activityItems: [image, url],
                                                    applicationActivities: nil)
        present(shareSheetVC, animated: true)
    }
    
    @objc func openRateUsLink() {
            guard let scene = view.window?.windowScene, let url = URL(string: "https://www.google.ru/?hl=ru") else { return }
            SKStoreReviewController.requestReview(in: scene)
    }
    
    @objc func goBack() {
        if usagePolicyWebView.canGoBack {
            usagePolicyWebView.goBack()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - Constraints
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(20)
            make.height.width.equalTo(36)
        }
        
        settingsLabel.snp.makeConstraints { make in
            make.top.equalTo(129)
            make.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        usagePolicyButton.snp.makeConstraints { make in
            make.height.equalTo(63)
        }
    }
}
