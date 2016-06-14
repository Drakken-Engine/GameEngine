//
//  DKRCore.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 11/05/16.
//  Copyright © 2016 Allison Lindner. All rights reserved.
//

import Metal
import CoreGraphics

public class DKRCore {
	public static let instance: DKRCore = DKRCore()
	
	internal var device: MTLDevice
	internal var library: MTLLibrary!
	
	internal var cQueue: MTLCommandQueue
	
	internal var renderer: DKRRenderer!
	
	internal var bManager: DKRBufferManager
	internal var tManager: DKRTextureManager
	internal var trManager: DKRTransformManager
	public var sManager: DKRSceneManager
	
	internal init() {
		self.device = MTLCreateSystemDefaultDevice()!
		self.cQueue = device.newCommandQueue()
		
		self.bManager = DKRBufferManager()
		self.tManager = DKRTextureManager()
		self.trManager = DKRTransformManager()
		self.sManager = DKRSceneManager()

		self.renderer = DKRRenderer()
		
		let bundle = NSBundle.init(identifier: "drakken.DrakkenKit")
		
		if let path = bundle!.pathForResource("default", ofType: "metallib") {
			do
			{
				library = try self.device.newLibraryWithFile(path)
			}
			catch MTLLibraryError.Internal
			{
				assert(false, "Bundle identifier incorrect!")
			}
			catch MTLLibraryError.CompileFailure
			{
				assert(false, "Compile failure")
			}
			catch MTLLibraryError.CompileWarning
			{
				assert(false, "Compile warning")
			}
			catch MTLLibraryError.Unsupported
			{
				assert(false, "Unsupported")
			}
			catch
			{
				assert(false, "default.metallib error!")
			}
		}
	}
}