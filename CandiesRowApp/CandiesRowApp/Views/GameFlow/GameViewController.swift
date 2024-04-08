//
//  GameViewController.swift
//  CandiesRowApp
//
//  Created by Василий Вырвич on 8.04.24.
//

import UIKit
import SnapKit
import AVFoundation

final class GameViewController: UIViewController {

    //MARK: - Variables
    private var viewModel = GameVCViewModel()
    
    private var pauseButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "pauseButton")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(pauseGame), for: .touchUpInside)
        return button
    }()
    
    private var currentTurnLabel: UILabel = {
        let label = UILabel()
        label.text = "Player 1"
        label.font = UIFont(name: "Digitalt", size: 52)
        label.textColor = UIColor(red: 67/255, green: 173/255, blue: 255/255, alpha: 1)
        return label
    }()
    
    private var currentCircleImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "blueCandy"))
        return imageView
    }()
    
    private var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.layer.cornerRadius = 5
        return collection
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
    
    private var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.backgroundColor = .black
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurView
    }()
    
    private let pauseLabel: UILabel = {
        let label = UILabel()
        label.text = "pause"
        label.textColor = .white
        label.font = UIFont(name: "Digitalt", size: 52)
        return label
    }()
    
    private var stackViewGameOver: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        return stack
    }()
        
    private let backHomeButton = CustomButton(type: .system)
    
    private let continueButton = CustomButton(type: .system)
    
    private var startPosition: CGPoint?
    
    private var originalCenter: CGPoint?
    
    private var movingView: UIView!
    
    private let imageView = UIImageView(image: UIImage(named: "playingField"))
    
    private let gameIsOverLabel: UILabel = {
        let label = UILabel()
        label.text = "Game is over"
        label.textColor = .white
        label.font = UIFont(name: "Digitalt", size: 52)
        return label
    }()
    
    private let winnerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "Digitalt", size: 38)
        return label
    }()
    
    private var backButtonImage: UIImageView = {
        let image = UIImage(named: "backButton")
        let iv = UIImageView(image: image)
        return iv
    }()
    
    private let playAgainButton = CustomButton(type: .system)
    private let backToHomeButton = CustomButton(type: .system)
    
    private let linePath = UIBezierPath()
    private let shapeLayer = CAShapeLayer()
    
    private var audioPlayer: AVAudioPlayer?
    
    private var staticView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        return view
    }()

    //MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        

        setUpView()
        updateViewConstraints()
        self.view.layoutIfNeeded()
        setCellWidthHeight()

        startPosition = currentCircleImageView.frame.origin
    }
    
    private func setUpView() {
        if let soundURL = Bundle.main.url(forResource: "effect", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            } catch {
                print("Ошибка загрузки звукового файла")
            }
        }
        imageView.contentMode = .scaleToFill
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        movingView = UIView()
        movingView.backgroundColor = UIColor(red: 255/255, green: 101/255, blue: 180/255, alpha: 1)
        
        movingView.isHidden = true
        
        let bgView = CustomBackgroundView(frame: self.view.bounds)
        view.insertSubview(bgView, at: 0)
        view.addSubview(movingView)
        view.addSubview(pauseButton)
        view.addSubview(collectionView)
        view.addSubview(imageView)
        view.addSubview(currentTurnLabel)
        setUpStackView()
        view.addSubview(blurEffectView)
        view.addSubview(stackView)
        blurEffectView.isHidden = true
        stackView.isHidden = true
        stackViewGameOver.isHidden = true
        view.addSubview(staticView)
        staticView.addSubview(currentCircleImageView)
        view.addSubview(gameIsOverLabel)
        view.addSubview(winnerLabel)
        view.addSubview(stackViewGameOver)
        gameIsOverLabel.isHidden = true
        winnerLabel.isHidden = true
        view.addSubview(pauseLabel)
        pauseLabel.isHidden = true
        stackViewGameOver.isHidden = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        currentCircleImageView.addGestureRecognizer(panGesture)
        originalCenter = currentCircleImageView.center
        currentCircleImageView.isUserInteractionEnabled = true
        
        setUpButtons()
        
        viewModel.resetBoard()
        
        self.view.insertSubview(currentCircleImageView, belowSubview: imageView)
    }
    
    private func setUpButtons() {
        backHomeButton.setUpButton(color: .purple, title: "back home")
        backHomeButton.addTarget(self, action: #selector(returnToMainVC), for: .touchUpInside)
        backHomeButton.addSubview(backButtonImage)
        
        continueButton.setUpButton(color: .pink, title: "continue")
        continueButton.addTarget(self, action: #selector(continueGame), for: .touchUpInside)
        
        playAgainButton.setUpButton(color: .pink, title: "Play again")
        playAgainButton.addTarget(self, action: #selector(playAgain), for: .touchUpInside)
        
        backToHomeButton.setUpButton(color: .purple, title: "Back Home")
        backToHomeButton.addTarget(self, action: #selector(returnToMainVC), for: .touchUpInside)
        
    }
    
    private func drawLine(list: [IndexPath]) {
        if let firstCoordinates = list.first, let secondCoordinates = list.last {
            let startSection = firstCoordinates[0]
            let startRow = firstCoordinates[1]
            let endSection = secondCoordinates[0]
            let endRow = secondCoordinates[1]
            
            let startIndexPath = IndexPath(row: startRow, section: startSection)
            let endIndexPath = IndexPath(row: endRow, section: endSection)
            
            if let startAttributes = collectionView.cellForItem(at: startIndexPath), let endAttributes = collectionView.cellForItem(at: endIndexPath) {
                let startPoint = CGPoint(x: startAttributes.frame.midX, y: startAttributes.frame.midY)
                let endPoint = CGPoint(x: endAttributes.frame.midX, y: endAttributes.frame.midY)
                
                linePath.move(to: startPoint)
                linePath.addLine(to: endPoint)
                
                UIColor.white.setStroke()
                linePath.lineWidth = 10
                linePath.stroke()
            }
        }
        
        shapeLayer.path = linePath.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.cornerRadius = 10
        shapeLayer.lineWidth = 10
        shapeLayer.masksToBounds = false
        collectionView.layer.insertSublayer(shapeLayer, above: imageView.layer)
    }
    
    private func setCellWidthHeight() {
        let width = collectionView.frame.size.width / 9
        let height = collectionView.frame.size.height / 6
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    private func dismissBlurEffect() {
        blurEffectView.isHidden = true
        pauseLabel.isHidden = true
        stackView.isHidden = true
    }
    
    private func setUpStackView() {
        stackView.addArrangedSubview(continueButton)
        stackView.addArrangedSubview(backHomeButton)
    }
    
    private func showGameIsOver(with title: String) {
        blurEffectView.isHidden = false
        blurEffectView.backgroundColor = .black
        blurEffectView.alpha = 0.7
        stackViewGameOver.isHidden = false
        
        gameIsOverLabel.isHidden = false
        winnerLabel.isHidden = false
        
        if viewModel.currentTurnTile() == CandyType.purple {
            winnerLabel.textColor = UIColor(red: 67/255, green: 173/255, blue: 255/255, alpha: 1)
        } else {
            winnerLabel.textColor = UIColor(red: 237/255, green: 72/255, blue: 224/255, alpha: 1)
        }

        winnerLabel.text = "\(title) Won"
        
        stackViewGameOver.addArrangedSubview(playAgainButton)
        stackViewGameOver.addArrangedSubview(backToHomeButton)
    }
    
    func resetCell() {
        for cell in collectionView.visibleCells as! [CustomCollectionViewCell] {
            cell.imageView.image = nil
        }
    }
    
    func victoryAchieved() {
        if viewModel.victoryAchieved() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showGameIsOver(with: self.viewModel.currentTurnVictoryMessage())
            }
            drawLine(list: viewModel.holeList)
        
        } else if viewModel.boardIsFull() {
            showGameIsOver(with: "Draw")
        }
    }
    
    //MARK: - @objc Methods
    @objc func returnToMainVC() {
        dismiss(animated: true)
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        let movingViewCenter = sender.location(in: self.staticView)
        let translation = sender.translation(in: self.staticView)
        let indexPath = collectionView.indexPathForItem(at: movingViewCenter)
        
        var newX = currentCircleImageView.center.x + translation.x
        
        let minX = (currentCircleImageView.frame.size.width + 5) / 2
        let maxX = staticView.frame.size.width - 10// - currentCircleImageView.frame.size.width
        
        newX = min(maxX, max(minX, newX))
        
        currentCircleImageView.center = CGPoint(x: newX, y: currentCircleImageView.center.y)
        
//        currentCircleImageView.center = CGPoint(x: currentCircleImageView.center.x + translation.x, y: currentCircleImageView.center.y)

        if sender.state == .began {
            movingView.isHidden = false
        } else if sender.state == .changed {
            movingView.center = CGPoint(x: currentCircleImageView.center.x + translation.x, y: movingView.center.y)
        } else if sender.state == .ended {
            movingView.isHidden = true
            if let indexPath = indexPath {
                if var boardItem = viewModel.getLowestEmptyBoardItem(indexPath.row) {
                    if let cell = collectionView.cellForItem(at: boardItem.indexPath) as? CustomCollectionViewCell {
                        
                        let convert = collectionView.convert(cell.frame, to: self.view)
                        
                        UIView.animate(withDuration: 0.5) {
                            self.currentCircleImageView.frame.origin = convert.origin
                        } completion: { _ in
                            self.currentCircleImageView.frame.origin = self.startPosition!
                            cell.imageView.image = self.viewModel.currentTurnColor()
                            if UserDefaults.standard.bool(forKey: "isEffectsEnabled") {
                                if let player = self.audioPlayer {
                                    player.play()
                                }
                            }
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.viewModel.toggleTurn(self.currentCircleImageView, title: self.currentTurnLabel)
                        }
                        boardItem.tile = self.viewModel.currentTurnTile()

                        viewModel.updateBoardWithBoardItem(boardItem)
                        
                        victoryAchieved()
                        
                        if viewModel.boardIsFull() {
                            showGameIsOver(with: "WINNER HAS NOT BEEN DETERMINED")
                        }
                    }
                }
            }
        }
        sender.setTranslation(CGPoint.zero, in: self.staticView)
    }
    
    @objc func pauseGame() {
        blurEffectView.isHidden = false
        blurEffectView.alpha = 0.7
        stackView.isHidden = false
        pauseLabel.isHidden = false
    }
    
    @objc func continueGame() {
        dismissBlurEffect()
    }
    
    @objc func playAgain() {
        blurEffectView.isHidden = true
        stackViewGameOver.isHidden = true
        gameIsOverLabel.isHidden = true
        winnerLabel.isHidden = true
        linePath.removeAllPoints()
        shapeLayer.removeFromSuperlayer()
        viewModel.resetBoard()
        resetCell()
    }
    
    //MARK: - Constraints
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        collectionView.snp.makeConstraints { make in
            make.width.equalTo(collectionView.snp.height).multipliedBy(7.0 / 6.0)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-200)
        }
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(collectionView.snp.height).multipliedBy(7.0 / 6.0)
            
            make.top.equalTo(collectionView.snp.top).offset(-7)
            make.bottom.equalTo(collectionView.snp.bottom).offset(7)
            make.leading.equalToSuperview().offset(3)
            make.trailing.equalToSuperview().offset(-3)
            make.centerX.equalToSuperview()
        }
        
        currentTurnLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(129)
        }
        
        currentCircleImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(collectionView.snp.top).inset(-10)
            make.height.width.equalTo(45)
        }
        
        staticView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(collectionView.snp.top).inset(-10)
            make.height.equalTo(60)
            make.width.equalTo(collectionView.snp.width)
        }
        
        movingView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(collectionView.snp.top)
            make.bottom.equalTo(collectionView.snp.bottom)
            make.height.equalTo(collectionView.snp.height)
            make.width.equalTo(collectionView.snp.width).dividedBy(7)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        pauseButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(20)
            make.height.width.equalTo(36)
        }
        
        blurEffectView.snp.makeConstraints { make in
            make.bottom.top.leading.trailing.equalToSuperview()
        }
        
        backHomeButton.snp.makeConstraints { make in
            make.height.equalTo(63)
        }
        
        backToHomeButton.snp.makeConstraints { make in
            make.height.equalTo(63)
        }
        
        gameIsOverLabel.snp.makeConstraints { make in
            make.top.equalTo(129)
            make.centerX.equalToSuperview()
        }
        
        pauseLabel.snp.makeConstraints { make in
            make.top.equalTo(129)
            make.centerX.equalToSuperview()
        }
        
        winnerLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(208)
        }
        
        stackViewGameOver.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        backButtonImage.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CustomCollectionViewCell else { fatalError()}
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let column = indexPath.item
        if var boardItem = viewModel.getLowestEmptyBoardItem(column) {
            if let cell = collectionView.cellForItem(at: boardItem.indexPath) as? CustomCollectionViewCell {
                if UserDefaults.standard.bool(forKey: "isEffectsEnabled") {
                    if let player = audioPlayer {
                        player.play()
                    }
                }
                cell.imageView.image = viewModel.currentTurnColor()
                boardItem.tile = viewModel.currentTurnTile()
                viewModel.updateBoardWithBoardItem(boardItem)
                currentTurnLabel.text = viewModel.currentTurnTitle()
                victoryAchieved()
                viewModel.toggleTurn(currentCircleImageView, title: currentTurnLabel)
            }
        }
    }
}
