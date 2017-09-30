//
//  Explode.swift
//  singalview-test
//
//  Created by 孙希庚 on 15/11/29.
//  Copyright © 2015年 孙希庚. All rights reserved.
//

import Foundation
class Explode{
    var x:CGFloat
    var y:CGFloat
    var time:Int
    static let image=UIImage(named: "boom.png")!
    init(x:CGFloat,y:CGFloat){
        self.x=x-5
        self.y=y-5
        time=4
    }
    func draw(_ view:UIView){
        let explode=UIImageView(image: Explode.image)
        explode.frame = CGRect(x: x, y: y, width: 10, height: 10)
        time-=1
        view.addSubview(explode)
    }
}
