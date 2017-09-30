//
//  BlueTank.swift
//  singalview-test
//
//  Created by 孙希庚 on 15/12/16.
//  Copyright © 2015年 孙希庚. All rights reserved.
//

import Foundation
import MultipeerConnectivity
class BlueTank{
    var x:CGFloat
    var y:CGFloat
    var playerTankToward:Toward
    var myClient:BluetoothTankWarClient
    static let speed:CGFloat = 4
    var isWalk=false
    var isLive=true
    var isGood:Bool
    var tankview:UIView
    var dirTime:Int = 0
    var walkTime:Int = 0
    var peerID: MCPeerID
    var identifier = "1"
    static let location = ["1":Location(x:0,y:0),
                           "2":Location(x:Tank.paintWidth-32,y:0),
                           "3":Location(x:0,y:Tank.paintHeigth-32),
                           "4":Location(x:Tank.paintWidth-32,y:Tank.paintHeigth-32)]
    static let towardEnum = ["1":Toward.right,
                           "2":Toward.down,
                           "3":Toward.up,
                           "4":Toward.left]
    static let corlor = ["1":"紫","2":"绿","3":"白","4":"黄"]
    static let paintWidth:CGFloat = 414  //屏幕宽度
    static let paintHeigth:CGFloat = 600 //屏幕长度
    static let image1=UIImage(named: "p1-a-cell.png")!
    static let image2=UIImage(named: "p1-a-cell2.png")!
    static let image3=UIImage(named: "p1-a-cell3.png")!
    static let image4=UIImage(named: "p1-a-cell4.png")!
    static let images=[image1,image2,image3,image4]
    static let white1=UIImage(named: "badtank1.png")!
    static let white2=UIImage(named: "badtank2.png")!
    static let white3=UIImage(named: "badtank3.png")!
    static let white4=UIImage(named: "badtank4.png")!
    static let whites=[white1,white2,white3,white4]
    static let purple1=UIImage(named: "purple.png")!
    static let purple2=UIImage(named: "purple2.png")!
    static let purple3=UIImage(named: "purple3.png")!
    static let purple4=UIImage(named: "purple4.png")!
    static let purples=[purple1,purple2,purple3,purple4]
    static let green1=UIImage(named: "green.png")!
    static let green2=UIImage(named: "green2.png")!
    static let green3=UIImage(named: "green3.png")!
    static let green4=UIImage(named: "green4.png")!
    static let greens=[green1,green2,green3,green4]
    static let tankViews=[images,whites,purples,greens]
    static var badTankCount=0
    //static var badTank=0
    init(attribute:Bool,client:BluetoothTankWarClient,peerID:MCPeerID,identifier:String) {
        self.peerID=peerID
        self.identifier=identifier
        self.myClient=client
        self.x = BlueTank.location[identifier]!.x
        self.y = BlueTank.location[identifier]!.y
        isGood=attribute
        playerTankToward = BlueTank.towardEnum[identifier]!
        tankview=UIView(frame: CGRect(x: x, y: y, width: 32, height: 32))
        tankview.backgroundColor=UIColor(patternImage: UIImage(named: "p1-a-cell.png")!)
    }
    func colliedsWithTanks(_ x:CGFloat,y:CGFloat,enemyTank:[BlueTank]) -> Bool {
        for i in 0 ... enemyTank.count-1{
            if(intersects(getRect(x,y: y), r2: enemyTank[i].getRect())){
                return false
            }
        }
        return true
    }
    func colliedsWithWalls(_ x:CGFloat,y:CGFloat,walls:Wall) -> Bool {
        for i in 0 ... walls.ws.count-1{
            if(intersects(getRect(x,y: y), r2: walls.ws[i])){
                return false
            }
        }
        return true
    }
    func colliedsWithBornArea(_ x:CGFloat,y:CGFloat)->Bool{
        return true
    }
    func move(){//坦克的move是否可行
        if playerTankToward == .up && isWalk==true{
            if(self.y-Tank.speed >= 0 && colliedsWithWalls(self.x,y:(self.y-Tank.speed),walls:self.myClient.walls) && colliedsWithTanks(self.x,y:(self.y-Tank.speed),enemyTank: self.myClient.enemyTank)){//检测是否可以走
                self.y -= Tank.speed
            }
        }
        else if playerTankToward == .down && isWalk==true{
            if(self.y+Tank.speed <= Tank.paintHeigth-32 && colliedsWithWalls(self.x,y:(self.y+Tank.speed),walls:self.myClient.walls) && colliedsWithTanks(self.x,y:(self.y+Tank.speed),enemyTank: self.myClient.enemyTank)){//检测是否可以走
                self.y += Tank.speed
            }
        }
        else if playerTankToward == .left && isWalk==true{
            if(self.x-Tank.speed >= 0 && colliedsWithWalls(self.x-Tank.speed,y:self.y,walls:self.myClient.walls) && colliedsWithTanks(self.x-Tank.speed,y:self.y,enemyTank: self.myClient.enemyTank)){//检测是否可以走
                self.x -= Tank.speed
            }
        }
        else if playerTankToward == .right && isWalk==true{
            if(self.x+Tank.speed <= Tank.paintWidth-32 && colliedsWithWalls(self.x+Tank.speed,y:self.y,walls:self.myClient.walls) && colliedsWithTanks(self.x+Tank.speed,y:self.y,enemyTank: self.myClient.enemyTank)){//检测是否可以走
                self.x += Tank.speed
            }
        }
    }
    func colliedsWithTanks(_ tanks:[Tank]){
        
    }
    func colliedsWithWalls(_ walls:[Wall]){
    }
    func getRect(_ x:CGFloat,y:CGFloat)->Rectangle{
        return Rectangle(x: x,y: y,w: 32,h: 32)
    }
    func getRect()->Rectangle{
        return Rectangle(x: x,y: y,w: 32,h: 32)
    }
    func draw(_ view:UIView){
        var tank:UIImageView
        var intToward:Int
        switch playerTankToward{
            case .up:
                intToward=0
            case .down:
                intToward=1
            case .left:
                intToward=2
            case .right:
                intToward=3
        }
        tank=UIImageView(image: BlueTank.tankViews[(identifier as NSString).integerValue-1][intToward])
        tank.frame = CGRect(x: x, y: y, width: 32, height: 32)
        view.addSubview(tank)
    }
}
