//
//  Welcome_Dialog_Container_View.swift
//  Herd
//
//  Created by Sid Verma on 7/7/17.
//  Copyright © 2017 Herd. All rights reserved.
//

import UIKit
import Hero
import CoreLocation
import Firebase
import GeoFire
import FirebaseDatabase

class Welcome_Dialog_Container_View: UIViewController {

    @IBOutlet var CancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Cancel_Button(_ sender: Any) {
        
        print("CANCEL TAPPED")
        //Set back to welcome screen
        hero_dismissViewController()
        
        
    }
    
    @IBAction func Follow_The_Herd_Button(_ sender: Any) {
        
        let geofireRef = Database.database().reference(withPath: "user_location")
        let geoFire = GeoFire(firebaseRef: geofireRef)
        
        if let locationLat = UserDefaults.standard.value(forKey: "current_location_lat") as? Double {
            if let locationLong = UserDefaults.standard.value(forKey: "current_location_long") as? Double {
            
                //Authenticate User with Firebase
                Auth.auth().signInAnonymously() { (user, error) in
                    print(user!.uid)
                    print("User has authenicated")
                    //Add user logged in User Defaults flag below
                    //UserDefaults.standard.set(true, forKey: "user_logged_in_V1.0")
                    UserDefaults.standard.set(user!.uid, forKey: "uid")
                    
                    //Store location in db using GeoFire with callback
                    geoFire?.setLocation(CLLocation(latitude: locationLat, longitude: locationLong), forKey: user!.uid) { (error) in
                        if (error != nil) {
                            //Show an error message of some sorts
                            print("An error occured: \(error)")
                        } else {
                           self.performSegue(withIdentifier: "toPostView", sender: nil)
                        }
                    }
                }
            
            }
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
