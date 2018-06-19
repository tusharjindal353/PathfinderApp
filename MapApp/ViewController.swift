//
//  ViewController.swift
//  MapApp
//
//  Created by Apple on 09/06/18.
//  Copyright © 2018 Tushar. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON
class ViewController: UIViewController,UIGestureRecognizerDelegate,GetPlaceDetailDelegate{
    func GetDetails(address: String, coordinate: CLLocationCoordinate2D) {
        if(ActiveLabel == "Pick"){
            isPickChoosen = true
            PickLabel.text = address
            PickMarker?.position = coordinate
            PickMarker?.map = mapView
            PickMarker?.title = address
            mapView.animate(toLocation: coordinate)
        }
        else if(ActiveLabel == "Drop"){
            isDropChoosen = true
            DropLabel.text = address
            DropMarker?.position = coordinate
            DropMarker?.map = mapView
            DropMarker?.title = address
            mapView.animate(toLocation: coordinate)
        }
        
        if(isPickChoosen == true && isDropChoosen == true){
            getpath()
        }
        
    }
    var isPickChoosen = false
    var isDropChoosen = false
    @IBOutlet weak var mapView: GMSMapView!
    var PickMarker : GMSMarker? = GMSMarker.init()
    var DropMarker : GMSMarker? = GMSMarker.init()
    @IBOutlet weak var PickLabel: UILabel!
    @IBOutlet weak var DropLabel: UILabel!
    var ActiveLabel = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let PickTap = UITapGestureRecognizer.init(target: self, action: #selector(Picktapped))
        PickTap.delegate = self
        PickLabel.addGestureRecognizer(PickTap)
        
        let DropTaP = UITapGestureRecognizer.init(target: self, action: #selector(Droptapped))
        DropTaP.delegate = self
        DropLabel.addGestureRecognizer(DropTaP)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func Picktapped(){
        
        ActiveLabel = "Pick"
        let SuggestionVC = self.storyboard?.instantiateViewController(withIdentifier: "PlaceSuggestionViewControllerID") as! PlaceSuggestionViewController
        SuggestionVC.delegate = self
        self.navigationController?.pushViewController(SuggestionVC, animated: true)
    }
    @objc func Droptapped(){
        ActiveLabel = "Drop"
        let SuggestionVC = self.storyboard?.instantiateViewController(withIdentifier: "PlaceSuggestionViewControllerID") as! PlaceSuggestionViewController
        SuggestionVC.delegate = self
        self.navigationController?.pushViewController(SuggestionVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func getpath(){
        let origin = "\((PickMarker?.position.latitude)!),\((PickMarker?.position.longitude)!)"
        let destination = "\((DropMarker?.position.latitude)!),\((DropMarker?.position.longitude)!)"

            let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyAFaGamqy4YYKKQ1yU0LH7LA_7ltKdUH9s"

        Alamofire.request(url).responseJSON{(responseData) -> Void in
            print(responseData.request!)  // original URL request
            print(responseData.response!) // HTTP URL response
            print(responseData.data!)     // server data
            print(responseData.result.value)
            if((responseData.result.value) != nil) {
                /* read the result value */
                let swiftyJsonVar = JSON(responseData.result.value!)

                /* only get the routes object */


                if let resData = swiftyJsonVar["routes"].arrayObject {
                    let routes = resData as! [[String: AnyObject]]
                    /* loop the routes */
                    if routes.count > 0 {
                       

                        for rts in routes {
                            /* get the point */
                            let overViewPolyLine = rts["overview_polyline"]?["points"]
                            let path = GMSMutablePath(fromEncodedPath: overViewPolyLine as! String)
                            /* set up poly line */
                            let polyline = GMSPolyline.init(path: path)
                            polyline.strokeColor = UIColor.blue
                            polyline.strokeWidth = 5
                            polyline.map = self.mapView

                        }
                    }
                }
            }


        }

    }


}

