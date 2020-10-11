//
//  MotorController.swift
//  SparkPerso
//
//  Created by Yoan Vandevelde on 07/10/2020.
//  Copyright © 2020 yvandevelde. All rights reserved.
//

import Foundation
import UIKit


class MotorController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nbBolts = SharedToyBox.instance.bolts.count
        var boltCollisionUID = [UUID]()
        let mainSpheroUID = SharedToyBox.instance.bolts[0].identifier
        var score = 0
        
        SharedToyBox.instance.bolts.map{
            $0.setStabilization(state: SetStabilization.State.on)
            $0.setCollisionDetection(configuration: .enabled)
        }
        
        // Set default colors
        SharedToyBox.instance.bolts[0].setMainLed(color: .blue)
        SharedToyBox.instance.bolts[0].setBackLed(color: .blue)
        SharedToyBox.instance.bolts[0].setFrontLed(color: .blue)
        
        SharedToyBox.instance.bolts[1].setMainLed(color: .clear)
        SharedToyBox.instance.bolts[1].setBackLed(color: .clear)
        SharedToyBox.instance.bolts[1].setFrontLed(color: .clear)
        
        SharedToyBox.instance.bolts[2].setMainLed(color: .clear)
        SharedToyBox.instance.bolts[2].setBackLed(color: .clear)
        SharedToyBox.instance.bolts[2].setFrontLed(color: .clear)
        
        SocketIOManager.instance.setup(ctx: SocketIOManager.Ctx.debugContext())
        SocketIOManager.instance.connect {
            print("Connect")
            
            SocketIOManager.instance.listenToChannel(channel: "hello")
            { (str) in
                if let s = str {
                    print(s)
                }
            }
        }
        
        SharedToyBox.instance.bolts.map{
            var bolt = $0
            
            // Increment boltCollisionUID array with sphero identifier
            $0.onCollisionDetected = { collisionData in
                boltCollisionUID.append(bolt.identifier)
                
                DispatchQueue.main.sync {
                    // light "neutral" sphero when it collide with an other one
                    if 2 == boltCollisionUID.count {
                        for boltUID in boltCollisionUID {
                            if boltUID != mainSpheroUID {
                                print(boltUID)
                                // Todo : add isLighted property in custom sphero class
                                
                                // SperoV2Toy.swift
                                // get sphero object by identifier
                                let lightBolt = bolt.getSpheroById(testedID: boltUID, spheros: SharedToyBox.instance.bolts)
                                
                                if let lb = lightBolt {
                                    lb.setMainLed(color: .blue)
                                    lb.setBackLed(color: .blue)
                                    lb.setFrontLed(color: .blue)
                                }
                            }
                        }
                        
                    // Motor experience gameplay
                    // 1 seconde to skake each sphero
                    } else if nbBolts == boltCollisionUID.count {
    
                        score += 1
                        print("score : \(score)")
                        // send score to websocket experience channel
                        SocketIOManager.instance.writeValue( String(score), toChannel: "scoreSended") {
                            print("Send")
                        }
                        
                    } else {
                        delay(1) {
                            boltCollisionUID = []
                            
                        }
                    }
                    // Todo : Change if statement with an expManager -> Make and order experience in a sequence (Light all sphero -> then stop this listener and start the motor experience)
                }
            }
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

