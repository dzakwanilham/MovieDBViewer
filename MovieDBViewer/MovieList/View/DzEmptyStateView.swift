//
//  DzEmptyStateView.swift
//  MovieDBViewer
//
//  Created by admin on 21/10/24.
//

import Foundation
import UIKit

class DzEmptyStateView: UIView {
	
	let messageLabel = DzTitleLabel(textAlignment: .center, fontSize: 28)
	let logoImageView = UIImageView()
	
	override init(frame: CGRect) {
		super.init(frame:frame)
		configuremessageLabel()
		configurelogoImageView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	init(message: String) {
		super.init(frame: .zero)
		messageLabel.text = message
		configuremessageLabel()
		configurelogoImageView()
	}
	
	private func configuremessageLabel(){
		
		addSubview(messageLabel)
		
		messageLabel.numberOfLines = 3
		messageLabel.textColor = .secondaryLabel
		
		NSLayoutConstraint.activate([
			messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -150),
			messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
			messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
			messageLabel.heightAnchor.constraint(equalToConstant: 200)
		])
		
	}
		
	private func configurelogoImageView() {
		addSubview(logoImageView)
		
		logoImageView.image = Images.emptyStateLogo
		logoImageView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
			logoImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
			logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 200),
			logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 140)
		])

	}
}
