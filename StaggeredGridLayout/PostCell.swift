//
//  PostCell.swift
//  StaggeredGridLayout
//
//  Created by 秋本大介 on 2016/06/08.
//  Copyright © 2016年 秋本大介. All rights reserved.
//

import UIKit
import AVFoundation

class PostCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentLabel: UILabel!
    
    var post : Post = Post()

    // MARK: - Accessor

    func setModel(post : Post) {
        self.imageView.image = post.image
        self.commentLabel.text = post.text
    }

    // MARK: - UICollectionReusableView

    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        if layoutAttributes is StaggeredGridLayoutAttributes {
            let attributes : StaggeredGridLayoutAttributes = layoutAttributes as! StaggeredGridLayoutAttributes
            self.imageViewHeightLayoutConstraint.constant = attributes.imageHeight;
        }
    }
    
    // MARK: - Public

    class func imageHeightWithImage(image : UIImage, cellWidth : CGFloat) -> CGFloat {
        let boundingRect : CGRect  =  CGRectMake(0, 0, cellWidth, CGFloat.max);
        let rect : CGRect = AVMakeRectWithAspectRatioInsideRect(image.size, boundingRect);
        
        return rect.size.height;
    }
    
    class func bodyHeightWithText(text : String,  cellWidth : CGFloat) -> CGFloat {
        let padding : CGFloat = 4.0
        let width : CGFloat = (cellWidth - padding * 2)
        let font = UIFont.systemFontOfSize(14.0)
        let attributes = [NSFontAttributeName:font]
        let rect : CGRect = (text as NSString).boundingRectWithSize(CGSizeMake(width, CGFloat.max),
            options : NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: attributes,
            context: nil)
        return padding + ceil(rect.size.height) + padding
    }
}
