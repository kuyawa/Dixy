//
//  ViewController.swift
//  Dixy
//
//  Created by Mac Mini on 3/7/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var textView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.font = NSFont(name: "Monaco", size: 14.0)
        start()
    }

    func start() {
        // Dixy to text
        var dixy: Dixy = [
            "name": "Taylor Swift",
            "age": 27,
            "phones": ["555-SWIFT", "666-SWIFT", "800-TAYLOR"],
            "body": [
                "height": "6 ft",
                "weight": "120 lbs"
            ],
            "pets":[
                [
                    "name": "Fido",
                    "breed": "chihuahua"
                ],
                [
                    "name": "Tinkerbell",
                    "breed": "bulldog"
                ]
            ]
        ]
        
        let text = dixy.toText()
        log(text)
        
        // Save to file
        log("\nSaving to file...")
        if dixy.save(file: "test.dix") {
            log("Saved")
        } else {
            log("Could not save")
        }
        
        // Back to dixy
        //dixy = text.toDixy()
        log("\nReading file...")
        dixy = Dixy.load(file: "test.dix")
        
        log(dixy["name"]!)
        let pets = dixy["pets"] as! Dixy
        let pet = pets["0"] as! Dixy
        log(pet["breed"]!)
        log("\nDone.")
    }
    
    func log(_ text: Any) {
        print(text)
        textView.string = (textView.string ?? "") + "\(text)\n"
    }

}

