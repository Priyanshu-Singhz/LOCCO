//
//  UserDefault+Extension.swift
//  SilvaTree
//
//  Created by ZTLAB13 on 21/07/20.
//  Copyright © 2020 ZTLAB13. All rights reserved.
//

import Foundation
extension UserDefaults {
    //MARK: - UserDefault Save / Retrive Data
    static func appSetObject(_ object:Any, forKey:String){
        UserDefaults.standard.set(object, forKey: forKey)
        UserDefaults.standard.synchronize()
    }
    
    static func appObjectForKey(_ strKey:String) -> Any?{
        let strValue = UserDefaults.standard.value(forKey: strKey)
        return strValue
    }
    
    static func appRemoveObjectForKey(_ strKey:String){
        UserDefaults.standard.removeObject(forKey: strKey)
        UserDefaults.standard.synchronize()
    }
    
    static func appSetEncodedObject(_ object:Any, forKey:String){
        do{
            let data = try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
            UserDefaults.appSetObject(data, forKey: forKey)
        }catch{
            appPrint("[UserDefaults] appSetEncodedObject error", error.localizedDescription)
        }
    }
    
    static func appGetDecodedObject(forKey strKey:String) -> Any?{
        if let data = UserDefaults.appObjectForKey(strKey) as? Data {
            do{
                let result = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, NSDictionary.self, NSString.self, NSNumber.self], from: data)
                return result
            } catch {
                appPrint("[UserDefaults] appGetDecodedObject error", error.localizedDescription)
            }
            return nil
        }
        return nil
    }
}

