//
//  SeqManager.swift
//  SparkPerso
//
//  Created by  on 25/09/2020.
//  Copyright © 2020 AlbanPerli. All rights reserved.
//

import Foundation
import DJISDK

enum Directions {
    case left
    case right
    case front
    case back
    case up
    case down
}

struct Move {
    var duration:Double
    var speed:Float
    var direction:Directions
    
}

class SeqManager {
    
    
    
    static let instance = SeqManager()
    
    var moves = [Move]()
    
    func clear() {
        moves.removeAll()
    }
    
    func move() {
        
        print(self.moves.first?.duration)
        
        if self.moves.count > 0 {
            if let currentMove = self.moves.first {
                applyMovment(move: currentMove)
                DispatchQueue.main.asyncAfter(deadline: .now() + currentMove.duration) {
                    
                    if self.moves.count > 0{
                        self.moves.remove(at: 0)
                    }
                    
                    self.move()
                }
                
            }
            
        } else {
            print("end")
            self.stop()
        }
    }
    
    func applyMovment(move: Move){
        self.stop()
        
        
        switch move.direction {
        case .front:
            print("foward")
            if let mySpark = DJISDKManager.product() as? DJIAircraft {
                mySpark.mobileRemoteController?.rightStickVertical = move.speed
                
            }
            
        case .back:
            print("backward")
            if let mySpark = DJISDKManager.product() as? DJIAircraft {
                mySpark.mobileRemoteController?.rightStickVertical = -move.speed}
            
        case .left:
            print("left")
            if let mySpark = DJISDKManager.product() as? DJIAircraft {
                mySpark.mobileRemoteController?.rightStickHorizontal = -move.speed}
            
        case .right:
            print("right")
            if let mySpark = DJISDKManager.product() as? DJIAircraft {
                mySpark.mobileRemoteController?.rightStickHorizontal = move.speed}
            
        case .up:
            print("right")
            if let mySpark = DJISDKManager.product() as? DJIAircraft {
                mySpark.mobileRemoteController?.leftStickVertical = move.speed}
        case .down:
            print("right")
            if let mySpark = DJISDKManager.product() as? DJIAircraft {
                mySpark.mobileRemoteController?.leftStickVertical = move.speed}
        default :
            print("default")
            
            
            
        }
        
    }
    
    func stop() {
        print("stop")
        if let mySpark = DJISDKManager.product() as? DJIAircraft {
            mySpark.mobileRemoteController?.leftStickVertical = 0.0
            mySpark.mobileRemoteController?.leftStickHorizontal = 0.0
            mySpark.mobileRemoteController?.rightStickHorizontal = 0.0
            mySpark.mobileRemoteController?.rightStickVertical = 0.0
        }
    }
}
