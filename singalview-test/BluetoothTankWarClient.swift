//
//  BluetoothTankWarClient.swift
//  singalview-test
//
//  Created by 孙希庚 on 15/12/16.
//  Copyright © 2015年 孙希庚. All rights reserved.
//

import Foundation
import MultipeerConnectivity
class BluetoothTankWarClient:TankWarClient{
    var mytank: BlueTank!
    var isOver = false
    var isYouWin = true
    var identifier = "1"
    var enemyTank:[BlueTank]!
    var viewController: BluetoothViewController!
    var lock = NSLock()
    override init(){
        super.init()
        enemyTank=[]
    }
    func beginGame(_ viewController: BluetoothViewController){
        viewController.connect.isHidden=true
        viewController.beginGame.isHidden=true
        viewController.analogueStick.isHidden=false
        viewController.fireButton.isHidden=false
        viewController.bluetoothTextView.isHidden=true
        self.viewController = viewController
        let queue=DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default)
        queue.async{
            while(!self.isOver){
                DispatchQueue.main.async{
                    let view1=viewController.player.paint()
                    let view=viewController.view.viewWithTag(100)
                    if(view != nil){
                        view?.removeFromSuperview()
                    }
                    viewController.view.insertSubview(view1, at: 0)//添加新的视图
                }
                Thread.sleep(forTimeInterval: 0.06)
            }
            DispatchQueue.main.async{
                let view=viewController.view.viewWithTag(100)
                if(view != nil){
                    view?.removeFromSuperview()
                }
                viewController.bluetoothTextView.isHidden=false
                viewController.analogueStick.isHidden=true
                viewController.fireButton.isHidden=true
                if(self.isYouWin){
                    viewController.bluetoothTextView.text = "you win"
                }
                else{
                    viewController.bluetoothTextView.text = "you lose"
                }
            }
        }
        
    }
    func upadteEnemyLocation(_ str:String){//可改进（利用字典哈希）
        print(str)
        for i in 0 ... enemyTank.count-1{
            if(str.contains(enemyTank[i].peerID.displayName)){
                var range1 = (str as NSString).range(of: "x:")
                var range2 = (str as NSString).range(of: "y:")
                var index1 = range1.location+range1.length
                var index2 = range2.location
                var x = (str as NSString).substring( with: NSMakeRange(index1, index2-index1))
                enemyTank[i].x = CGFloat((x as NSString).integerValue)
                range1 = (str as NSString).range(of: "y:")
                range2 = (str as NSString).range(of: "toward:")
                index1 = range1.location+range1.length
                index2 = range2.location
                x = (str as NSString).substring( with: NSMakeRange(index1, index2-index1))
                enemyTank[i].y = CGFloat((x as NSString).integerValue)
                x = (str as NSString).substring(from: range2.location+range2.length)
                switch x {
                case "up":
                    enemyTank[i].playerTankToward = .up
                case "down":
                    enemyTank[i].playerTankToward = .down
                case "left":
                    enemyTank[i].playerTankToward = .left
                case "right":
                    enemyTank[i].playerTankToward = .right
                default:
                    enemyTank[i].playerTankToward = Toward.up;
                }
            }
        }
    }
    func upadteShell(_ str:String){
        print(str)
        var range1 = (str as NSString).range(of: "x:")
        var range2 = (str as NSString).range(of: "y:")
        var index1 = range1.location+range1.length
        var index2 = range2.location
        let strX = (str as NSString).substring( with: NSMakeRange(index1, index2-index1))
        let shellX = CGFloat((strX as NSString).integerValue)
        range1 = (str as NSString).range(of: "y:")
        range2 = (str as NSString).range(of: "toward:")
        index1 = range1.location+range1.length
        index2 = range2.location
        let strY = (str as NSString).substring( with: NSMakeRange(index1, index2-index1))
        let shellY = CGFloat((strY as NSString).integerValue)
        let strToward = (str as NSString).substring(from: range2.location+range2.length)
        let shellToward:Toward
        switch strToward {
        case "up":
            shellToward = Toward.up
        case "down":
            shellToward = Toward.down
        case "left":
            shellToward = Toward.left
        case "right":
            shellToward = Toward.right
        default:
            shellToward = Toward.up;
        }
        range1 = (str as NSString).range(of: "shellIdentifier:")
        range2 = (str as NSString).range(of: "x:")
        index1 = range1.location+range1.length
        index2 = range2.location
        let id = ((str as NSString).substring( with: NSMakeRange(index1, index2-index1)) as NSString).intValue
        shells.append(Shell(x:shellX,y:shellY,toward:shellToward,client:self,attribute:true,id:id))
    }
    func upadteExplode(_ str:String){
        print(str)
        var range1 = (str as NSString).range(of: "explode")
        let range2 = (str as NSString).range(of: "shellIdentifier:")
        var index1 = range1.location+range1.length
        let index2 = range2.location
        let peerIDName = (str as NSString).substring( with: NSMakeRange(index1, index2-index1))
        print(peerIDName)
        range1 = (str as NSString).range(of: "shellIdentifier:")
        index1 = range1.location+range1.length
        let shellID = (str as NSString).substring(from: index1)
        let id = (shellID as NSString).intValue
        for i in 0...shells.count-1{
            let m = shells[i]
            print(m.shellID)
            if(id==m.shellID){
                explodes.append(Explode(x:m.x,y:m.y))
                m.isLive=false
                break
            }
        }
        for i in 0 ... enemyTank.count-1{
            let t = enemyTank[i]
            if(peerIDName == t.peerID.displayName){
                t.isLive = false
                break
            }
        }

    }
    override func paint()->UIView{//画在一个新画布上
        let view=UIView(frame: CGRect(x: 0, y: (736-Tank.paintHeigth)/2, width: Tank.paintWidth, height: Tank.paintHeigth))
        view.tag=100
        view.backgroundColor = UIColor.black
        if(mytank.isLive){
            var xx=mytank.x
            var yy=mytank.y
            mytank.move()
            if((xx != mytank.x)||(yy != mytank.y)){//移动了再发送
            do{
                try viewController.session.send(("location"+mytank.peerID.displayName+"identifier:"+mytank.identifier+"x:\(mytank.x)y:\(mytank.y)toward:\(mytank.playerTankToward)").data(using: String.Encoding.utf16,
                    allowLossyConversion: false)!, toPeers: viewController.session.connectedPeers,
                    with: MCSessionSendDataMode.unreliable)
                print("send location success")
            }
            catch let error as NSError {
            print("Error sending data: \(error.localizedDescription)")
            }
            }
            mytank.draw(view)
        }

        for(var i=0;i<shells.count;i += 1)
        {
            let m=shells[i]
            m.fly()
            m.hitEdge()
            m.hitTank(mytank)
            m.hitWall(walls)
            if(!m.isLive){
                shells.remove(at: i)
                i--
            }
            else{
                m.draw(view)
            }
        }
        
        for(var i=0;i<enemyTank.count;i++)
        {
            let badtank=enemyTank[i]
            if(badtank.isLive){
                badtank.draw(view)
            }
            else{
                enemyTank.remove(at: i)
                i--
            }
        }

        for(var i=0;i<explodes.count;i++)
        {
            let e=explodes[i];
            if(e.time>0){
                e.draw(view);
            }
            else{
                explodes.remove(at: i)
                i--
            }
        }
        if((enemyTank.count==0)||(mytank.isLive==false&&enemyTank.count==1)){
            isOver = true
        }
        walls.draw(view)
        return view
    }
}
