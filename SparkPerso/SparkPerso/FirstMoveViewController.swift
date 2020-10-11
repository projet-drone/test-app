//
//  FirstMoveViewController.swift
//  SparkPerso
//
//  Created by  on 23/09/2020.
//  Copyright © 2020 AlbanPerli. All rights reserved.
//

import UIKit
import DJISDK

class FirstMoveViewController: UIViewController {
    
    let newSeq = SeqManager.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func frontClicked(_ sender: UIButton) {
        print("frontClicked")
        if let mySpark = DJISDKManager.product() as? DJIAircraft {
            mySpark.mobileRemoteController?.rightStickVertical = 0.5
        }
    }
    
    @IBAction func backClicked(_ sender: UIButton) {
        print("backClicked")
        if let mySpark = DJISDKManager.product() as? DJIAircraft {
            mySpark.mobileRemoteController?.rightStickVertical = -0.5
        }
    }
    
    
    @IBAction func rightClicked(_ sender: UIButton) {
        print("rightClicked")
        if let mySpark = DJISDKManager.product() as? DJIAircraft {
            mySpark.mobileRemoteController?.rightStickHorizontal = 0.5
        }
    }
    
    @IBAction func leftClicked(_ sender: UIButton) {
        print("leftClicked")
        if let mySpark = DJISDKManager.product() as? DJIAircraft {
            mySpark.mobileRemoteController?.rightStickHorizontal = -0.5
        }
    }
    
    @IBAction func takeOff(_ sender: UIButton) {
        print("take off")
        
        if let mySpark = DJISDKManager.product() as? DJIAircraft {
            if let flightController = mySpark.flightController {
                flightController.startTakeoff(completion: { (err) in
                    print(err.debugDescription)
                })
            }
        }
    }
    
    @IBAction func stop(_ sender: UIButton) {
        print("stop")
        newSeq.clear()
        //locked = true
        
        if let mySpark = DJISDKManager.product() as? DJIAircraft {
            mySpark.mobileRemoteController?.leftStickVertical = 0.0
            mySpark.mobileRemoteController?.leftStickHorizontal = 0.0
            mySpark.mobileRemoteController?.rightStickHorizontal = 0.0
            mySpark.mobileRemoteController?.rightStickVertical = 0.0
        }
        
        //        DispatchQueue.main.async {
        //            print("kill thread")
        //            workItem.cancel()
        //        }
        
    }
    
    @IBAction func landing(_ sender: UIButton) {
        print("landing")
        if let mySpark = DJISDKManager.product() as? DJIAircraft {
            if let flightController = mySpark.flightController {
                flightController.startLanding(completion: { (err) in
                    print(err.debugDescription)
                })
            }
        }
        
    }
    
    @IBAction func upClicked(_ sender: UIButton) {
        print("up")
        if let mySpark = DJISDKManager.product() as? DJIAircraft {
            mySpark.mobileRemoteController?.leftStickVertical = 0.5
        }
        
    }
    
    @IBAction func downClicked(_ sender: UIButton) {
        print("down")
        if let mySpark = DJISDKManager.product() as? DJIAircraft {
            mySpark.mobileRemoteController?.leftStickVertical = -0.5
        }
        
    }
    
    @IBAction func launchClicked(_ sender: UIButton) {
        newSeq.moves = [Move(duration: 3.0, speed: 0.3, direction: Directions.front),
        Move(duration: 1.0, speed: 0.3, direction: Directions.right),
        Move(duration: 1.0, speed: 0.3, direction: Directions.left),
        Move(duration: 3.0, speed: 0.3, direction: Directions.back)]
        print("launch")
        
        newSeq.move()
        
        
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
