//
//  CustomButton.swift
//  MovieDBViewer
//
//  Created by admin on 22/10/24.
//

import Foundation
import UIKit

public class CustomButton: UIButton {
	
	var didTap: (() -> Void)?
	
	enum ButtonStyle {
		case white
		case blue
	}
	
	init(style: ButtonStyle, title: String) {
		super.init(frame: .zero)
		self.setTitle(title, for: .normal)
		setupStyle(style)
		self.translatesAutoresizingMaskIntoConstraints = false
		self.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	private func setupStyle(_ style: ButtonStyle) {
		switch style {
		case .white:
			self.backgroundColor = UIColor.white
			self.setTitleColor(UIColor.blue, for: .normal)
			self.layer.borderColor = UIColor.blue.cgColor
			self.layer.borderWidth = 2
		case .blue:
			self.backgroundColor = UIColor.blue
			self.setTitleColor(UIColor.white, for: .normal)
		}
		
		self.layer.cornerRadius = 8
		self.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
	}
	
	@objc private func tapButton() {
		self.didTap?()
	}
}
