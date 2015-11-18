//
//  FirstViewController.swift
//  ResourceApp
//
//  Created by Mathijs Kadijk on 20-07-15.
//  Copyright (c) 2015 Mathijs Kadijk. All rights reserved.
//

import UIKit
extension String {
    
    var capitalizeFirst:String {
        var result = self
        result.replaceRange(startIndex...startIndex, with: String(self[startIndex]).capitalizedString)
        return result
    }
    
}

//extension NSObject {
//    // create a static method to get a swift class for a string name
//    class func swiftClassFromString(className: String) -> AnyClass! {
//        // get the project name
//        if  var appName: String? = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as! String? {
//            // generate the full name of your class (take a look into your "YourProject-swift.h" file)
//            let classStringName = "_TtC\(appName!.utf16count)\(appName)\(countElements(className))\(className)"
//            // return the class!
//            return NSClassFromString(classStringName)
//        }
//        return nil;
//    }
//}

class FirstViewController: UIViewController {

  @IBOutlet weak var titleLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    //  let data = NSData(contentsOfFile: "index.json")!
    let sourcePath = NSBundle.mainBundle().pathForResource("Index", ofType: "json")
      let str = try! NSString(contentsOfFile: sourcePath!, encoding: NSUTF8StringEncoding) as String
       let jsonObject = try! NSJSONSerialization.JSONObjectWithData(NSData(data: str.dataUsingEncoding(NSUTF8StringEncoding)!), options: NSJSONReadingOptions(rawValue: 0))
       print(jsonObject)
    
       print(String(Panna.Index.Data.Doctors.self))
       print(NSStringFromClass(Panna.Index.Data.Doctors.self))

       let index = self.parseJsonToObject(jsonObject, className: "Index")
   }
    
    
  
    func parseJsonToObject <T:NSObject> (json:AnyObject,className:String) -> T{
        let classObj = NSClassFromString(className.capitalizeFirst) as! T.Type
        let obj = classObj.init()
        if let jsonObj = json as? [String:AnyObject]{
            for key in jsonObj.keys{
                let value = jsonObj[key]
                if value is String || value is [String]{
                    obj.setValue(value, forKey:key)
                }else if let subJsonArray = value as? [[String:AnyObject]]{
                    var subObjectArray = [AnyObject]()
                    for subJson in subJsonArray{
                        subObjectArray.append(self.parseJsonToObject(subJson, className:key))
                    }
                    obj.setValue(subObjectArray, forKey: key)
                }else if let subJson = value as? [String:AnyObject]{
                    obj.setValue(self.parseJsonToObject(subJson, className:key), forKey: key)
                }else{
                    obj.setValue(value, forKey:key)
                    //  throw ResourceParsingError.ParsingFailed("JSON not String:AnyObject")
                }
            }
        }
        return obj
    }
}

