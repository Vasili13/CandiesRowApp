//
//  MainViewController.swift
//  CandiesRowApp
//
//  Created by Василий Вырвич on 8.04.24.
//

import UIKit
import SnapKit
import AVFoundation

final class MainViewController: UIViewController {

    //MARK: - Variables
    private var isMusicEnabled = true
    private var isEffectsEnabled = true
    
    private var player: AVAudioPlayer?
    private var defaults = UserDefaults.standard
    
    private let muteImage = UIImage(named: "muteButton")
    private let unmuteImage = UIImage(named: "unmuteButton")
    
    private var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        return stack
    }()
    
    private var logoImageView: UIImageView = {
        let logoImage = UIImage(named: "candy")
        let imageView = UIImageView(image: logoImage)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var playButton = CustomButton(type: .system)
    private var settingsButton = CustomButton(type: .system)
    private var musicButton = CustomButton(type: .system)
    private var effectsButton = CustomButton(type: .system)
        
    private var imageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    private var efImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    //MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        updateViewConstraints()
        getUserDefaultsResultForMusic()
        getUserDefaultsResultForEffects()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if AppLauncherManager.shared.isNewUser() {
            let vc = WelcomeViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
    
    private func getUserDefaultsResultForEffects() {
        let result = defaults.bool(forKey: "isEffectsEnabled")
        if result {
            efImageView.image = unmuteImage
        } else {
            efImageView.image = muteImage
        }
    }
    
    private func getUserDefaultsResultForMusic() {
        let result = defaults.bool(forKey: "isMusicTrue")
        if result {
            playMusic()
            imageView.image = unmuteImage
        } else {
            player?.stop()
            imageView.image = muteImage
        }
    }
    
    private func playMusic() {
        if let player = player, player.isPlaying {
            player.stop()
        } else {
            
            let urlString = Bundle.main.path(forResource: "audio", ofType: "mp3")
            
            do {
                try AVAudioSession.sharedInstance().setMode(.default)
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                
                guard let urlString = urlString else { return }
                
                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
                player?.numberOfLoops = -1
                guard let player = player else { return }
                
                player.play()
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)

    }
    
    private func setUpView() {
        setUpStackView()
        view.addSubview(stackView)
        
        playButton.setUpButton(color: .pink, title: "Play")
        playButton.addTarget(self, action: #selector(moveToPlayVC), for: .touchUpInside)
        
        settingsButton.setUpButton(color: .blue, title: "Settings")
        settingsButton.addTarget(self, action: #selector(moveToSettingsVC), for: .touchUpInside)
        
        musicButton.setUpButton(color: .purple, title: "Music")
        musicButton.addTarget(self, action: #selector(muteMusic), for: .touchUpInside)
        
        effectsButton.setUpButton(color: .purple, title: "Effects")
        effectsButton.addTarget(self, action: #selector(muteEffects), for: .touchUpInside)
        
        musicButton.addSubview(imageView)
        effectsButton.addSubview(efImageView)
        
        view.addSubview(logoImageView)
        
        let bgView = CustomBackgroundView(frame: self.view.bounds)
        self.view.insertSubview(bgView, at: 0)
    }
    
    private func setUpStackView() {
        stackView.addArrangedSubview(playButton)
        stackView.addArrangedSubview(settingsButton)
        stackView.addArrangedSubview(musicButton)
        stackView.addArrangedSubview(effectsButton)
    }
    
    //MARK: - @objc Methods
    
    @objc func moveToPlayVC() {
        let vc = GameViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc func moveToSettingsVC() {
        let vc = SettingsViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc func muteMusic() {
        isMusicEnabled.toggle()
        defaults.set(isMusicEnabled, forKey: "isMusicTrue")
                
        getUserDefaultsResultForMusic()
    }
    
    @objc func muteEffects() {
        defaults.set(isEffectsEnabled, forKey: "isEffectsEnabled")
        getUserDefaultsResultForEffects()
        isEffectsEnabled.toggle()
    }
    
    @objc func appDidEnterBackground() {
        player?.pause()
    }
    
    @objc func appWillEnterForeground() {
        player?.play()
    }
    //MARK: - Constraints
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view.snp.top).offset(63)
            make.width.equalTo(294)
            make.height.equalTo(146)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        playButton.snp.makeConstraints { make in
            make.height.equalTo(63)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(musicButton).offset(16)
            make.top.equalTo(musicButton).offset(16)
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
        
        efImageView.snp.makeConstraints { (make) in
            make.left.equalTo(effectsButton).offset(16)
            make.top.equalTo(effectsButton).offset(16)
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
    }

}
