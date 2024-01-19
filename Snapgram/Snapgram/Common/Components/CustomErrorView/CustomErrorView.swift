//
//  CustomErrorVIew.swift
//  Snapgram
//
//  Created by Phincon on 01/12/23.
//

import UIKit
import Lottie

class CustomErrorView: UIView {
    internal var animationView: LottieAnimationView = {
        let animationView = LottieAnimationView()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.backgroundColor = .systemBackground
        animationView.contentMode = .scaleToFill
        animationView.animation = LottieAnimation.named("error_animation")
        return animationView
    }()

    internal var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Uh oh! Something's wrong!"
        label.font = UIFont(name: "Helvetica-Bold", size: 14)
        return label
    }()

    internal var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Please pull to refresh"
        label.font = UIFont(name: "Helvetica", size: 12)
        return label
    }()
    
    internal var navigateBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Explore store", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .systemBlue
        button.configuration = UIButton.Configuration.filled()
        button.setAnimateBounce()
        button.isHidden = true
        button.makeCornerRadius(8.0)
        button.addShadow()
        return button
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureAnimation()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
        configureAnimation()
    }
    
    // MARK: - Functions

    private func configureView() {
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        [animationView, titleLabel, descriptionLabel, navigateBtn].forEach { addSubview($0) }

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: frame.width),
            heightAnchor.constraint(equalToConstant: frame.height),
            animationView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100),
            animationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            animationView.heightAnchor.constraint(equalToConstant: 400),

            titleLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            navigateBtn.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            navigateBtn.centerXAnchor.constraint(equalTo: centerXAnchor),
            navigateBtn.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func configureAnimation() {
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.play()
    }
}
