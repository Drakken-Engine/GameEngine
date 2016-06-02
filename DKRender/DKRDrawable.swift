//
//  DKRDrawable.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 19/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Metal

internal protocol DKRDrawable {
	func getBuffers() -> [DKBuffer]
	func getIndicesBuffer() -> DKBuffer
}