//
//  TankWarClient.swift
//  singalview-test
//
//  Created by 孙希庚 on 15/11/28.
//  Copyright © 2015年 孙希庚. All rights reserved.
//

import Foundation
class TankWarClient{
    var myTank:Tank!
    var tanks:[Tank]
    var shells:[Shell]
    var walls:Wall
    var explodes:[Explode]
    var badTankInterval1:Int=0
    var badTankInterval2:Int=0
    init(){
        shells=[]
        walls=Wall()
        explodes=[]
        tanks=[]
        myTank=Tank(x: 0,y: (Tank.paintHeigth/2)-64,attribute:true,client:self,toward: .right)
    }
    func paint()->UIView{//画在一个新画布上
        let view=UIView(frame: CGRect(x: 0, y: (736-Tank.paintHeigth)/2, width: Tank.paintWidth, height: Tank.paintHeigth))
        view.tag=100
        view.backgroundColor = UIColor.black
        myTank.move()
        myTank.draw(view)
        if(Tank.badTankCount<50){
            if(tanks.count<35){
                if(badTankInterval1>100){
                    if(drand48() < 0.1 && myTank.colliedsWithTanks(Tank.paintWidth-32, y: 0, tanks: tanks, badi: -1)){
                        tanks.append(Tank(x: Tank.paintWidth-32, y: 0, attribute: false, client: self,toward: .down))
                        badTankInterval1=0
                    }
                }
                else{
                    badTankInterval1 += 1
                }
                if(badTankInterval2>100){
                    if(drand48() < 0.1 && myTank.colliedsWithTanks(Tank.paintWidth-32, y: Tank.paintHeigth-32, tanks: tanks, badi: -1)){
                        tanks.append(Tank(x:Tank.paintWidth-32, y: Tank.paintHeigth-32, attribute: false, client: self,toward: .up))
                        badTankInterval2=0
                    }
                }
                else{
                    badTankInterval2 += 1
                }
            }
        }
        for i in 0 ... shells.count-1
        {
            let m=shells[i]
            m.fly()
            m.hitEdge()
            m.hitTanks(tanks)
            m.hitWall(walls)
            if(!m.isLive){
                shells.remove(at: i)
            }
            else{
                m.draw(view)
            }
        }
        for i in 0 ... tanks.count-1
        {
            let badtank=tanks[i]
            if(badtank.isLive){
                badtank.move(i)
                badtank.badFire()
                badtank.draw(view)
                
            }
            else{
                tanks.remove(at: i)
            }
        }
        
        for i in 0 ... explodes.count-1
        {
            let e=explodes[i];
            if(e.time>0){
                e.draw(view);
            }
            else{
                explodes.remove(at: i)
            }
        }
        walls.draw(view)
        /*var m:Shell
        var t:Tank
        for(var i=0;i<shells.count;i++)
        {
        m=shells[i];
        m.hitWall(walls);
        m.hitTanks(tanks);
        m.hitTank(myTank);
        //m.draw(temporarypaint);//画画布上；
        
        //if(!m.isLive())
        //missiles.remove(m);
        //else m.draw(g);
        }
        for(var i=0;i<tanks.count;i++)
        {
        t=tanks[i];
        t.colliedsWithWalls(walls);
        t.colliedsWithTanks(tanks);
        //t.draw(g);
        }*/
        return view
    }
}

