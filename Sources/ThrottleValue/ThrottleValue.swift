//
//  ThrottleValue.swift
//  
//
//  Created by hoseung Lee on 2022/11/01.
//

import Foundation

@propertyWrapper
public struct ThrottleValue<Value> {
    final class InTime {
        var inProgress = false
    }
    
    private var inTime = InTime()
    private var value: Value
    
    let interval: TimeInterval
    public var wrappedValue: Value {
        get {
            value
        }
        
        set {
            if !inTime.inProgress {
                value = newValue
                inTime.inProgress = true
                setTimer()
            }
        }
    }
    
    public init(_ value: Value, interval: TimeInterval) {
        self.value = value
        self.interval = interval
    }
    
    mutating
    private func setTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) { [weak inTime] in
            inTime?.inProgress = false
        }
    }
    
}
