#!/bin/sh

mkdir Sources/day$1
pushd Sources/day$1

touch input.txt
touch input_sample.txt

cat <<EOF >> main.swift
//
//  main.swift
//  day$1
//
//  Created by Moritz Sternemann on $1.12.21.
//

import Common

let input = try Input.loadInput(in: .module)
EOF

