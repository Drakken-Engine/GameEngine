//
//  DrakkenEngine.swift
//  DrakkenEngine
//
//  Created by Allison Lindner on 24/08/16.
//  Copyright © 2016 Drakken Studio. All rights reserved.
//

fileprivate struct dShaderRegister {
	var name: String
	var vertexFunctionName: String
	var fragmentFunctionName: String
}

public class DrakkenEngine {
	private static var _toBeRegisteredShaders: [dShaderRegister] = []
	private static var _toBeRegisteredMeshs: [dMeshDef] = []
	private static var _toBeRegisteredMaterials: [dMaterialDef] = []
	
	public static func Init() {
		DrakkenEngine.InitInternalShaders()
		DrakkenEngine.InitInternalMeshs()
		DrakkenEngine.InitInternalMaterial()
		
		DrakkenEngine.SetupShaders()
		DrakkenEngine.SetupMeshs()
		DrakkenEngine.SetupMaterials()
	}
	
	public static func Register(shader name: String, vertexFunc: String, fragmentFunc: String) {
		let register = dShaderRegister(name: name,
		                               vertexFunctionName: vertexFunc,
		                               fragmentFunctionName: fragmentFunc)
		
		DrakkenEngine._toBeRegisteredShaders.append(register)
	}
	
	public static func Register(mesh def: dMeshDef) {
		_toBeRegisteredMeshs.append(def)
	}
	
	public static func Register(material def: dMaterialDef) {
		_toBeRegisteredMaterials.append(def)
	}
	
	private static func SetupShaders() {
		for shaderToRegister in DrakkenEngine._toBeRegisteredShaders {
			dCore.instance.shManager.register(shader: shaderToRegister.name,
			                                  vertexFunc: shaderToRegister.vertexFunctionName,
			                                  fragmentFunc: shaderToRegister.fragmentFunctionName)
		}
	}
	
	private static func SetupMeshs() {
		for meshToRegister in DrakkenEngine._toBeRegisteredMeshs {
			let mesh = dMesh(meshDef: meshToRegister)
			mesh.build()
		}
	}
	
	private static func SetupMaterials() {
		for materialToRegister in DrakkenEngine._toBeRegisteredMaterials {
			let mesh = dMaterial(materialDef: materialToRegister)
			mesh.build()
		}
	}
	
	private static func InitInternalShaders() {
		DrakkenEngine.Register(shader: "diffuse",
		                       vertexFunc: "diffuse_vertex",
		                       fragmentFunc: "diffuse_fragment")
	}
	
	private static func InitInternalMeshs() {
		DrakkenEngine.Register(mesh: dQuad(name: "quad"))
	}
	
	private static func InitInternalMaterial() {
		
	}
}
