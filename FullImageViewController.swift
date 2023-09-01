//
//  FullImageViewController.swift
//  myBucketList
//
//  Created by 陳佩琪 on 2023/9/1.
//

import UIKit

class FullImageViewController: UIViewController {

    @IBOutlet var fullImageView: UIImageView!

    var imageName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let imageName {
            let imageUrl = URL.documentsDirectory.appending(path: imageName).appendingPathExtension(for: .jpeg)
            if let image = UIImage(contentsOfFile: imageUrl.path) {
                fullImageView.image = image                
            }
            
            

            
//            let imageWidth = (image?.size.width)!
//            let imageHeight = (image?.size.height)!
//            print("w,h",imageWidth,imageHeight)
//
//            if Double(imageWidth) > Double(imageHeight) {
//                fullImageView.frame.size = CGSize(width: fullImageView.frame.width, height: (image?.size.height)!)
//                fullImageView.frame.origin = CGPoint(x: 0, y: 0)
//            }
           
        }

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
