//
//  File.swift
//  SparkPerso
//
//  Created by Yoan Vandevelde on 09/10/2020.
//  Copyright © 2020 yvandevelde. All rights reserved.
//

import UIKit
import simd
import AVFoundation

class JoystickController: UIViewController {
    
    struct coordinates {
        var x:Double = 0
        var y:Double = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var currentAccData = [Double]()
        var currentGyroData = [Double]()
        
        SocketIOManager.instance.setup(ctx: SocketIOManager.Ctx.debugContext())
        SocketIOManager.instance.connect {
            print("Connect")
            
            SocketIOManager.instance.listenToChannel(channel: "miam")
            { (str) in
                if let s = str {
                    print(s)
                }
            }
        }
        
        SharedToyBox.instance.bolt?.sensorControl.enable(sensors: SensorMask.init(arrayLiteral: .accelerometer,.gyro))
        SharedToyBox.instance.bolt?.sensorControl.interval = 1
        SharedToyBox.instance.bolt?.setStabilization(state: SetStabilization.State.off)
        SharedToyBox.instance.bolt?.sensorControl.onDataReady = { data in
            DispatchQueue.main.async {
                
                if let acceleration = data.accelerometer?.filteredAcceleration {
                    // PAS BIEN!!!
                    currentAccData.append(contentsOf: [acceleration.x!, acceleration.y!, acceleration.z!])
                    
                    var stick = coordinates(x: 0, y: 0)
                    
                    if acceleration.x! >= 0.25 {
                        
                        stick.x = -0.5
                        
                    } else if acceleration.x! <= -0.25 {
                        
                        stick.x = 0.5
                    }
                    
                    if acceleration.y! >= 0.25 {
                        
                        stick.y = -0.5
                    } else if acceleration.y! <= -0.25 {
                        
                        stick.y = 0.5
                    }
                    
                    print(stick)
                    let stringStick = "\(stick.x) : \(stick.y)"
                    print(stick)
                    
                    SocketIOManager.instance.writeValue( stringStick, toChannel: "joystickMoved") {
                        print("Send")
                    }
                    
                    //                    SocketIOManager.instance.writeValue( String(stick), toChannel: "joystickMoved") {
                    //                        print("Send")
                    //                    }
                    
                    let sum = abs(acceleration.y!) + abs(acceleration.z!) + abs(acceleration.x!)
                    
                    if sum > 3.5 {
                        print("ohwohw")
                    }
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
