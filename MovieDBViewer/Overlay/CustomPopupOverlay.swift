//
//  CustomPopupOverlay.swift
//  MovieDBViewer
//
//  Created by admin on 22/10/24.
//

import UIKit

public class CustomPopupOverlay: UIView {
	
	var primaryButtonAction: (() -> Void)?
	var secondaryButtonAction: (() -> Void)?

	private var titleLabel: UILabel?
	private var subtitleLabel: UILabel?
	private var popupImageView: UIImageView?
	private var primaryButton: CustomButton?
	private var secondaryButton: CustomButton?
	
	init(title: String? = nil,
				subtitle: String? = nil,
				image: UIImage? = nil,
				primaryButtonTitle: String? = nil,
				secondaryButtonTitle: String? = nil,
				primaryButtonStyle: CustomButton.ButtonStyle = .blue,
				secondaryButtonStyle: CustomButton.ButtonStyle = .white) {
		super.init(frame: .zero)
		setupView(title: title,
				  subtitle: subtitle,
				  image: image,
				  primaryButtonTitle: primaryButtonTitle,
				  secondaryButtonTitle: secondaryButtonTitle,
				  primaryButtonStyle: primaryButtonStyle,
				  secondaryButtonStyle: secondaryButtonStyle)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
		
	convenience init(title: String?,
					 subtitle: String?,
					 image: UIImage?,
					 primaryButtonTitle: String?,
					 secondaryButtonTitle: String?) {
		
		self.init(title: title, subtitle: subtitle, image: image, primaryButtonTitle: primaryButtonTitle, secondaryButtonTitle: secondaryButtonTitle, primaryButtonStyle: .blue, secondaryButtonStyle: .white)
	}
	
	private func setupView(title: String?,
						   subtitle: String?,
						   image: UIImage?,
						   primaryButtonTitle: String?,
						   secondaryButtonTitle: String?,
						   primaryButtonStyle: CustomButton.ButtonStyle,
						   secondaryButtonStyle: CustomButton.ButtonStyle) {
		self.backgroundColor = UIColor.white
		self.layer.cornerRadius = 10
		self.clipsToBounds = true
		
		if let title = title {
			titleLabel = UILabel()
			titleLabel?.text = title
			titleLabel?.textAlignment = .center
			titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
			titleLabel?.translatesAutoresizingMaskIntoConstraints = false
			guard let titleLabel = titleLabel else { return }
			self.addSubview(titleLabel)
		}
		
		if let subtitle = subtitle {
			subtitleLabel = UILabel()
			subtitleLabel?.text = subtitle
			subtitleLabel?.textAlignment = .center
			subtitleLabel?.font = UIFont.systemFont(ofSize: 16)
			subtitleLabel?.textColor = UIColor.darkGray
			subtitleLabel?.translatesAutoresizingMaskIntoConstraints = false
			subtitleLabel?.numberOfLines = 4
			guard let subtitleLabel = subtitleLabel else { return }
			self.addSubview(subtitleLabel)
		}
		
		if let image = image {
			popupImageView = UIImageView(image: image)
			popupImageView?.contentMode = .scaleAspectFit
			popupImageView?.translatesAutoresizingMaskIntoConstraints = false
			guard let popupImageView = popupImageView else { return }
			self.addSubview(popupImageView)
		}
		
		if let primaryButtonTitle = primaryButtonTitle {
			primaryButton = CustomButton(style: primaryButtonStyle, title: primaryButtonTitle)
			primaryButton?.translatesAutoresizingMaskIntoConstraints = false
			guard let primaryButton = primaryButton else { return }
			self.addSubview(primaryButton)
			primaryButton.addTarget(self, action: #selector(primaryButtonTapped), for: .touchUpInside)
		}
		
		if let secondaryButtonTitle = secondaryButtonTitle {
			secondaryButton = CustomButton(style: secondaryButtonStyle, title: secondaryButtonTitle)
			secondaryButton?.translatesAutoresizingMaskIntoConstraints = false
			guard let secondaryButton = secondaryButton else { return }
			self.addSubview(secondaryButton)
			secondaryButton.addTarget(self, action: #selector(secondaryButtonTapped), for: .touchUpInside)
		}
		
		setupConstraints(hasSubtitle: subtitle != nil, hasImage: image != nil, hasPrimaryButton: primaryButtonTitle != nil, hasSecondaryButton: secondaryButtonTitle != nil)
	}
	
	@objc private func primaryButtonTapped() {
		print("Primary button tapped!")
		hide()
		self.primaryButtonAction?()
	}
	
	@objc private func secondaryButtonTapped() {
		print("Secondary button tapped!")
		hide()
		self.secondaryButtonAction?()
	}
	
	private func setupConstraints(hasSubtitle: Bool, hasImage: Bool, hasPrimaryButton: Bool, hasSecondaryButton: Bool) {
		var previousView: UIView? = nil
		
		if let titleLabel = titleLabel {
			NSLayoutConstraint.activate([
				titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
				titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
				titleLabel.heightAnchor.constraint(equalToConstant: 40),
				titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8)
			])
			previousView = titleLabel
		}
		
		if let popupImageView = popupImageView {
			NSLayoutConstraint.activate([
				popupImageView.topAnchor.constraint(equalTo: previousView?.bottomAnchor ?? self.topAnchor, constant: 10),
				popupImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
				popupImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2.0),
				popupImageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 4.0)
			])
			previousView = popupImageView
		}
		
		if let subtitleLabel = subtitleLabel {
			NSLayoutConstraint.activate([
				subtitleLabel.topAnchor.constraint(equalTo: previousView?.bottomAnchor ?? self.topAnchor, constant: 10),
				subtitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
				subtitleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8)
			])
			previousView = subtitleLabel
		}
		
		if hasSecondaryButton {
			if let primaryButton = primaryButton {
				NSLayoutConstraint.activate([
					primaryButton.topAnchor.constraint(equalTo: previousView?.bottomAnchor ?? self.topAnchor, constant: 20),
					primaryButton.trailingAnchor.constraint(equalTo: self.centerXAnchor),
					primaryButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: hasSecondaryButton ? 0.4 : 0.6),
					primaryButton.heightAnchor.constraint(equalToConstant: 44)
				])
				previousView = primaryButton
			}
			
			if let secondaryButton = secondaryButton {
				NSLayoutConstraint.activate([
					secondaryButton.topAnchor.constraint(equalTo: primaryButton?.topAnchor ?? self.topAnchor),
					secondaryButton.leadingAnchor.constraint(equalTo: primaryButton?.trailingAnchor ?? self.centerXAnchor, constant: 10),
					secondaryButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4),
					secondaryButton.heightAnchor.constraint(equalToConstant: 44)
				])
				previousView = secondaryButton
			}
		} else {
			if let primaryButton = primaryButton {
				NSLayoutConstraint.activate([
					primaryButton.topAnchor.constraint(equalTo: previousView?.bottomAnchor ?? self.topAnchor, constant: 20),
					primaryButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
					primaryButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: hasSecondaryButton ? 0.4 : 0.6),
					primaryButton.heightAnchor.constraint(equalToConstant: 44)
				])
				previousView = primaryButton
			}
		}
		
		if let previousView = previousView {
			NSLayoutConstraint.activate([
				previousView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
			])
		}
	}
	
	public func show(on parentView: UIView) {
		self.translatesAutoresizingMaskIntoConstraints = false
		parentView.addSubview(self)
		NSLayoutConstraint.activate([
			self.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
			self.centerYAnchor.constraint(equalTo: parentView.centerYAnchor),
			self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.8),
			self.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.6)
		])
		
		UIView.animate(withDuration: 0.3) {
			self.alpha = 1.0
		}
	}
	
	public func hide() {
		UIView.animate(withDuration: 0.3, animations: {
			self.alpha = 0.0
		}) { _ in
			self.removeFromSuperview()
		}
	}
}
