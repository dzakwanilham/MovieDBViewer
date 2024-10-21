//
//  UIHelper.swift
//  MovieDBViewer
//
//  Created by admin on 21/10/24.
//

import UIKit

struct UIHelper {
	
	static func createCustomFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
		
		let width = view.bounds.width
		let padding: CGFloat = 12
		let minimumItemSpacing: CGFloat = 10
		
		let availableWidth = width - (padding*2) - (minimumItemSpacing*2)
		let itemWidth = availableWidth / 3
		
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
		flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth * 4/3)
		
		return flowLayout
	}
	
}
