//
//  StaggeredGridLayoutAttributes.swift
//  Rise
//
//  Created by 秋本大介 on 2016/06/06.
//  Copyright © 2016年 秋本大介. All rights reserved.
//

import UIKit

public class StaggeredGridLayoutAttributes: UICollectionViewLayoutAttributes {
    public var imageHeight : CGFloat = 0.0

    public override func copyWithZone(zone: NSZone) -> AnyObject {
        let copy : StaggeredGridLayoutAttributes = super.copyWithZone(zone) as! StaggeredGridLayoutAttributes
        copy.imageHeight = self.imageHeight;
        
        return copy;
    }
    
    public override func isEqual(object: AnyObject?) -> Bool {
        if object is StaggeredGridLayoutAttributes {
            let attributtes : StaggeredGridLayoutAttributes = object as! StaggeredGridLayoutAttributes

            if (attributtes.imageHeight == self.imageHeight) {
                return super.isEqual(attributtes)
            }
        }
        return false;
    }
}
