//
//  Post.swift
//  StaggeredGridLayout
//
//  Created by 秋本大介 on 2016/06/08.
//  Copyright © 2016年 秋本大介. All rights reserved.
//

import UIKit

public class Post: NSObject {
    public var text: String?
    public var image: UIImage?

    func initWithDictionary(dictionary : Dictionary<String, String>) -> Post {
        self.text = dictionary["text"]
        if let _ = dictionary["imageName"] {
            let imageName : String = dictionary["imageName"]!
            self.image = UIImage(named: imageName)
        }
        return self
    }

    class func allPosts() -> Array<Post> {
        var posts : Array<Post> = []

        do {
            let filePath : String = NSBundle.mainBundle().pathForResource("Posts", ofType: "json")!
            let fileData : NSData = try NSData(contentsOfFile: filePath, options: NSDataReadingOptions.DataReadingMappedAlways)
            let jsonPosts : NSArray = try NSJSONSerialization.JSONObjectWithData(fileData, options: NSJSONReadingOptions.MutableContainers) as! NSArray
            for object in jsonPosts as! Array<NSDictionary> {
                let jsonDictionary : Dictionary<String, String> = object as! Dictionary<String, String>
                let post : Post = Post().initWithDictionary(jsonDictionary)
                posts.append(post)
            }
        } catch _ {
            print("Could not load post data")
            return posts
        }


        return posts
    }
}
