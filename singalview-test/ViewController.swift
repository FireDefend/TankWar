//
//  ViewController.swift
//  singalview-test
//
//  Created by 孙希庚 on 15/11/7.
//  Copyright © 2015年 孙希庚. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func blueButtonPressed(_ sender: UIButton) {
        let blueView=storyboard?.instantiateViewController(withIdentifier: "BluetoothView") as! BluetoothViewController
        blueView.modalTransitionStyle = .flipHorizontal
        self.present(blueView, animated: true, completion: nil)
    }
    @IBAction func buttonPressed(_ sender: UIButton) {
        let subVc=storyboard?.instantiateViewController(withIdentifier: "sub")
        as! SubViewController
        subVc.modalTransitionStyle = .flipHorizontal
        self.present(subVc, animated: true, completion: nil)
    }
    override func viewDidLoad() {

        super.viewDidLoad()
        self.view.backgroundColor=UIColor.black
        //let deskView = UIView(frame:CGRectMake(4,10,400,308))
        //deskView.backgroundColor = UIColor(patternImage: UIImage(named:"desk.jpg")!)
        //view.addSubview(deskView)
        // Do any additional setup after loading the view, typically from a nib.

    }
    /*override func touchesEnded(touches: Set<UITouch>,
        withEvent event: UIEvent?) {
            let view=self.view.viewWithTag(100)
            let subVc=SubViewController()
            subVc.modalTransitionStyle = .PartialCurl
            self.presentViewController(subVc, animated: true, completion: nil)
            view?.removeFromSuperview()
    }*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
class wwww{
    
}

