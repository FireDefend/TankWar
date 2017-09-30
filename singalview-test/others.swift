//
//  SomeEnum.swift
//  singalview-test
//
//  Created by 孙希庚 on 15/11/28.
//  Copyright © 2015年 孙希庚. All rights reserved.
//

import Foundation
enum Toward{
    case up
    case down
    case left
    case right
}
struct Rectangle{
    var x:CGFloat
    var y:CGFloat
    var w:CGFloat
    var h:CGFloat
}
struct Location{
    var x:CGFloat
    var y:CGFloat
}
func CrossLine(_ left:CGFloat, right:CGFloat, y:CGFloat, top:CGFloat, bottom:CGFloat, x:CGFloat)->Bool{
    return (top <= y)&&(bottom >= y)&&(left <= x)&&(right >= x)
}
func intersects(_ r1:Rectangle,r2:Rectangle)->Bool{
    let r2w = r2.x+r2.w
    let r2h = r2.y+r2.h
    let r1w = r1.x+r1.w
    let r1h = r1.y+r1.h
    //      overflow || intersec
    return CrossLine(r1.x, right: r1w, y: r1.y, top: r2.y, bottom: r2h, x: r2.x)||CrossLine(r1.x, right: r1w, y: r1.y, top: r2.y, bottom: r2h, x: r2w)||CrossLine(r1.x, right: r1w, y: r1h, top: r2.y, bottom: r2h, x: r2.x)||CrossLine(r1.x, right: r1w, y: r1h, top: r2.y, bottom: r2h, x: r2w)||CrossLine(r2.x, right: r2w, y: r2.y, top: r1.y, bottom: r1h, x: r1.x)||CrossLine(r2.x, right: r2w, y: r2.y, top: r1.y, bottom: r1h, x: r1w)||CrossLine(r2.x, right: r2w, y: r2h, top: r1.y, bottom: r1h, x: r1.x)||CrossLine(r2.x, right: r2w, y: r2h, top: r1.y, bottom: r1h, x: r1w);
}
func absolute(_ x:CGFloat)->CGFloat{//取绝对值
    if(x>=0){
        return x;
    }
    else{
        return -x;
    }
}
