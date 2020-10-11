//
//  GeneratorController.swift
//  SparkPerso
//
//  Created by Yoan Vandevelde on 09/10/2020.
//  Copyright © 2020 AlbanPerli. All rights reserved.
//

import Foundation

import UIKit
import CoreMotion

class GeneratorController: UIViewController {
    
    var motionManager: CMMotionManager!
    
    
    @IBOutlet weak var DebugLabel: UILabel!
    
    var xes:[Float] = [Float]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 0.01
        
        SocketIOManager.instance.setup(ctx: SocketIOManager.Ctx.debugContext())
        SocketIOManager.instance.connect {
            print("Connect")
            
            SocketIOManager.instance.listenToChannel(channel: "generatorRotated")
            { (str) in
                if let s = str {
                    print(s)
                }
            }
            
            SocketIOManager.instance.writeValue("Hello", toChannel: "generatorRotated") {
                print("Send")
            }
        }
        
        SharedToyBox.instance.bolt?.sensorControl.enable(sensors: SensorMask.init(arrayLiteral: .accelerometer,.gyro))
        SharedToyBox.instance.bolt?.sensorControl.enable(sensors: SensorMask.init(arrayLiteral: .accelerometer,.gyro))
        SharedToyBox.instance.bolt?.sensorControl.interval = 1000
        SharedToyBox.instance.bolt?.setStabilization(state: SetStabilization.State.off)
        
        SharedToyBox.instance.bolt?.sensorControl.onDataReady = { data in
            if let d = data.accelerometer?.filteredAcceleration {
                if let dx = d.y {
                    print(dx)
                    
                    let rotationRate:SIMD3<Double> = [Double(dx),0.0,0.0] //Double(d.y),Double(d.z)]
                    
                    self.xes.append(Float(dx))
                    self.xes.append(Float(dx))
                    
                    if self.xes.count >= 16 {
                        let res = fft(self.xes).real.map{ abs($0) }
                        let sum = res.reduce(0.0,+)
                        let count = res.index(of: res.max()!)!
                        print(sum)
                        
                        DispatchQueue.main.async {
                            self.DebugLabel.text = "\(count)"
                            
                        }
                        if sum >= 1200 && count < 10{
                            print("ohoh")
                            DispatchQueue.main.async {
                                print("lol")
                                SocketIOManager.instance.writeValue(String(count), toChannel: "generatorRotated") {
                                    print("Send")
                                }
                            }
                            
                        }
                       
                        self.xes = []
                    }
                }
                
            }
        }
    }
}
