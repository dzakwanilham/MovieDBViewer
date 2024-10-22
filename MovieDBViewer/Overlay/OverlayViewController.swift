//
//  OverlayViewController.swift
//  MovieDBViewer
//
//  Created by admin on 22/10/24.
//

import Foundation
import UIKit

public class OverlayViewController: UIViewController {
	
	private var popupOverlay: CustomPopupOverlay?
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		self.enableBlurEffect()
		self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
	}
	
	public func presentPopup(title: String?, subTitle: String?, image: UIImage?, primaryButtonTitle: String?, secondaryButtonTitle: String?) {
		popupOverlay = CustomPopupOverlay(title: title, subtitle: subTitle, image: image, primaryButtonTitle: primaryButtonTitle, secondaryButtonTitle: secondaryButtonTitle)
		
		if let popupOverlay = popupOverlay {
			popupOverlay.show(on: self.view)
			
			popupOverlay.primaryButtonAction = { [weak self] in
				self?.dismissPopup()
			}
			
			popupOverlay.secondaryButtonAction = { [weak self] in
				self?.dismissPopup()
			}
		}
	}
	
	public func dismissPopup() {
		popupOverlay?.hide()
		self.dismiss(animated: true, completion: nil)
	}
	
	public func showPopup(on viewController: UIViewController, title: String?, subTitle: String?, image: UIImage?, primaryButtonTitle: String?, secondaryButtonTitle: String?) {
		self.modalTransitionStyle = .crossDissolve
		self.modalPresentationStyle = .overFullScreen
		viewController.present(self, animated: true, completion: nil)
		
		self.presentPopup(title: title, subTitle: subTitle, image: image, primaryButtonTitle: primaryButtonTitle, secondaryButtonTitle: secondaryButtonTitle)
	}
	
	fileprivate func enableBlurEffect() {
		let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView.frame = view.bounds
		blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		view.addSubview(blurEffectView)
	}
}
