//
//  Dixy.swift
//  Dixy
//
//  Created by Mac Mini on 3/7/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import Foundation

/*
 
 Use:
 
    // Dixy to text
    let dixy = ["name": "Taylor Swift", "age": 27]
    let text = dixy.toText()
    print(text)
 
    // Back to dixy
    let dixy2 = text.toDixy()
 
    // Dixy read from file
    let dixy3 = Dixy.load(file: "test.dix")
 
    // Dixy write to file
    let ok = dixy3.save(file: "test.dix")
 
 */


typealias Dixy = Dictionary<String, Any>

extension Dictionary {

    func toText() -> String {

        func parse(_ key: String, _ value: Any, _ indent: Int=0) -> String {
            var text = ""
            let tab  = String(repeating: " ", count: indent*4)
            let type = type(of: value)
            let kind = String(describing: type)
            
            if kind.hasPrefix("Array") {
                let list = value as! Array<Any>
                text += "\(tab)\(key):\n"
                text += walkTheList(list, indent+1)
            } else if kind.hasPrefix("Dictionary") {
                let dixy = value as! Dictionary
                text += "\(tab)\(key):\n"
                text += walkTheDixy(dixy, indent+1)
            } else {
                text += "\(tab)\(key): \(value)\n"
            }

            return text
        }

        func walkTheList(_ list: Array<Any>, _ indent: Int) -> String {
            var text = ""
            
            for (key, value) in list.enumerated() {
                text += parse(String(key), value, indent)
            }
            
            return text
        }
        
        func walkTheDixy(_ dixy: Dictionary, _ indent: Int) -> String {
            var text = ""

            for (key, value) in dixy {
                text += parse(key as! String, value, indent)
            }
            
            return text
        }
        
        var text = "# Dixy 1.0"
        text += "\n\n"
        text += walkTheDixy(self, 0)
        
        return text
    }
    
    func save(file: String) -> Bool {
        let text = self.toText()
        do {
            try text.write(toFile: file, atomically: false, encoding: .utf8)
            return true
        } catch {
            return false
        }
    }
    
    func save(url: URL) -> Bool {
        return self.save(file: url.path)
    }
    
    static func load(file: String) -> Dixy {
        var text = ""
        do {
            text = try String(contentsOfFile: file)
        } catch {
            text = "error: File not loaded"
        }
        
        let dixy = text.toDixy()
        
        return dixy
    }

    static func load(url: URL) -> Dixy {
        return Dixy.load(file: url.path)
    }
}

extension String {
    
    func getIndent() -> Int {
        var indent = 0
        
        for char in self.characters {
            if char == " " {
                indent += 1
            } else if char == "\t" {
                indent += 4
            } else {
                break
            }
        }
        
        return indent
    }

    func toDixy() -> Dixy {
        let lines = self.components(separatedBy: "\n")
        var index = 0

        func walkTheLines(_ indent: Int) -> Dixy {
            var dixy: [String: Any] = [:]
            let prevIndent = indent
            
            while index < lines.count {
                let line = lines[index]
                let indent = line.getIndent()
                
                if indent <= prevIndent {
                    return dixy
                }
                
                let parts = line.components(separatedBy: ":")
                let key = parts[0].trimmingCharacters(in: .whitespaces)
                var val = ""
                
                if key.isEmpty { /* blank line */
                    index += 1
                    continue
                }
                
                if key.characters.first == "#" { /* comment */
                    index += 1
                    continue
                }
                
                // TODO: if key is numeric, parse as Array
                
                if parts.count > 1 { /* has value */
                    val = parts[1].trimmingCharacters(in: .whitespaces)
                }
                
                if val.isEmpty { /* is dixy */
                    index += 1
                    dixy[key] = walkTheLines(indent)
                } else { /* is value */
                    dixy[key] = val
                    index += 1
                }
                
            }
            
            return dixy
        }
        
        var dixy: [String: Any] = [:]
        dixy = walkTheLines(-1)

        return dixy
    }
    
}

extension Array {
    
    func toDixy() -> Dixy {
        var dixy: Dixy = [:]
        
        for (key, value) in self.enumerated() {
            dixy["\(key)"] = value
        }
        
        return dixy
    }

}


// End
