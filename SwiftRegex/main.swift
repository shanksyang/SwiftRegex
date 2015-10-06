//
//  main.swift
//  SwiftRegex
//
//  Created by Gregory Todd Williams on 6/7/14.
//  Copyright (c) 2014 Gregory Todd Williams. All rights reserved.
//

let value: String = "<item>what a day</item><item>whattest</item>";
let pattern: String = "<(item)>(.+?)</item>";

print("string  : \(value)")
print("pattern : \(pattern)")

let items = value =~ pattern
print(items.captureItems)
for m in items {
    print("matched pattern: \(m)")
}

print(items.boolValue)

