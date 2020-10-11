//
//  SpheroHeadingViewController.swift
//  SparkPerso
//
//  Created by AL on 01/09/2019.
//  Copyright © 2019 AlbanPerli. All rights reserved.
//

import UIKit

class SpheroAimingViewController: UIViewController {
    
    @IBOutlet weak var aimingLabel: UILabel!
    @IBOutlet weak var statusTextField: UITextView!
    var timerRSSI:Timer? = nil
    var intialRotation = 0
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        displayCurrentStatus()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        SharedToyBox.instance.bolts.map{ $0.startAiming() }
        //SharedToyBox.instance.bolt?.startAiming()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timerRSSI?.invalidate()
        timerRSSI = nil
        SharedToyBox.instance.bolts.map{ $0.stopAiming() }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        aimingLabel.text = "Aiming: \(sender.value.rounded())"
        SharedToyBox.instance.bolts.map{ $0.rotateAim(Double(sender.value)) }
    }
    
    func vibrato(bolt : BoltToy, heading: Double) {
        bolt.roll(heading: heading, speed: 0)
        
        sleep(2)
        bolt.roll(heading: 0, speed: 0)
    }
    
    func blinking(bolt: BoltToy) {
        bolt.setMainLed(color: .blue)
        bolt.setBackLed(color: .blue)
        bolt.setFrontLed(color: .blue)
        sleep(1)
        bolt.setMainLed(color: .clear)
        bolt.setBackLed(color: .clear)
        bolt.setFrontLed(color: .clear)

    }
    
    func displayCurrentStatus() {
        if let bolt = SharedToyBox.instance.bolt,
           let appVersion = bolt.appVersion {
            bolt.getPowerState()
            statusTextField.text = """
            AppVersion: \(appVersion)\n
            Battery Level: \(bolt.batteryLevel ?? -1.0)\n
            Peripheral Name: \(bolt.peripheral?.name ?? "")\n
            """
            
            timerRSSI = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (t) in
                bolt.core.peripheral.readRSSI()
            }
            timerRSSI?.fire()
            print("test")
            bolt.setMainLed(color: .clear)
            bolt.setBackLed(color: .clear)
            bolt.setFrontLed(color: .clear)
            
            bolt.setStabilization(state: SetStabilization.State.off)
            bolt.core.rssiListenerCallback = { rssiValue in
                self.statusTextField.text = """
                AppVersion: \(appVersion)\n
                Battery Level: \(bolt.batteryLevel ?? -1.0)\n
                Peripheral Name: \(bolt.peripheral?.name ?? "")\n
                RSSI:\(rssiValue)
                """
                
                print(rssiValue)
              
                self.intialRotation = self.intialRotation + ( 2 * abs(rssiValue))
                print(self.intialRotation)
                
                if self.intialRotation >= 360 {
                    self.intialRotation = 0
                    print(self.intialRotation)
                }
                
//                bolt.roll(heading: Double(self.intialRotation), speed: 0)
                
                if rssiValue >= -40 {
                    bolt.setMainLed(color: .blue)
                    bolt.setBackLed(color: .blue)
                    bolt.setFrontLed(color: .blue)

                } else if rssiValue >= -50{
                    
                    self.blinking(bolt: bolt)
                    self.vibrato(bolt: bolt, heading: 180.0)

                } else if rssiValue >= -60{

                    self.vibrato(bolt: bolt, heading: 90.0)

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
