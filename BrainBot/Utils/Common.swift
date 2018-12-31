//
//  Common.swift
//  BrainBot
//
//  Created by KazuyaIkoma on 2019/01/01.
//  Copyright © 2019 kaz. All rights reserved.
//

import Foundation

/* NSLocalizedStringの簡素化 */
func L(_ key : Any!) -> String {
    if let k = key as? String {
        return NSLocalizedString(k, comment: "")
    }
    return ""
}

/* JSON */

func loadJson(_ name: String) -> Any? {
    let path : String = Bundle.main.path(forResource: name, ofType: "json")!
    let fileHandle : FileHandle = FileHandle(forReadingAtPath: path)!
    let data : Data = fileHandle.readDataToEndOfFile()
    return (try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as Any?)
}

/* Dictionary */
func dictionaryKey(_ dic: [String:Any], forValue value: Any) -> String {
    for (key, val) in dic {
        if (value as AnyObject).isEqual(val) {
            return key
        }
    }
    return ""
}

/* delay */
func delay(_ interval: Double, callback: @escaping (() -> Void)) {
    let delayTime = DispatchTime.now() + Double(Int64(interval * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: delayTime, execute: callback)
}

/* File */

// 特定の拡張子をもつプロジェクト中のファイルのリストを返す
func getFileList(_ ext: String) -> [String] {
    var arr: [String] = [String]()
    let fm = FileManager()
    let path = Bundle.main.bundlePath
    if let files = (try? fm.contentsOfDirectory(atPath: path)) {
        for content in files {
            if content.hasSuffix(ext) {
                arr.append(content)
            }
        }
    }
    return arr
}

/* 時間 */
let secForMin: Int = 60
let secForHour: Int = 60 * secForMin
let secForDay: Int = 24 * secForHour
