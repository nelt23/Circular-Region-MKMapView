//
//  CircleInternClass.swift
//  CircularRegionMap
//
//  Created by Nuno Martins on 23/01/2019.
//  Copyright © 2019 Nuno Martins. All rights reserved.
//

import MapKit

class CircleIntern: NSObject, MKMapViewDelegate {
    
    let mapView: MKMapView!
    let circleBothClass: CircleBoth

    static var circleIntern = MKCircle()
    var circleInternRadius: Double
    var circleInternCoordinate: CLLocationCoordinate2D

    var circleDotRadius = Double()
    var circleDotCoordinate: CLLocationCoordinate2D {
        return circleBothClass.FuncCircleDotCoordinate(circleCoordinate: circleInternCoordinate, circleRadius: circleInternRadius)
    }
    
    init(mapView: MKMapView, circleBothClass: CircleBoth, circleInternCoordinate: CLLocationCoordinate2D, circleInternRadius: Double) {
        
        self.mapView = mapView
        self.circleBothClass = circleBothClass

        self.circleInternCoordinate = circleInternCoordinate
        self.circleInternRadius = circleInternRadius

        super.init()
    }
    
    func FuncCreateCircles (circleInternCoordinate: CLLocationCoordinate2D, circleInternRadius: Double, PositionTheMap: Bool) {
        
        mapView.removeOverlay(CircleIntern.circleIntern)

        CircleIntern.circleIntern = MKCircle(center: circleInternCoordinate, radius: circleInternRadius)
        let circleInternOverlay = mapView.mapView(mapView, rendererFor: CircleIntern.circleIntern).overlay as! MKCircle
        
        mapView.addOverlay(circleInternOverlay)
        
        if PositionTheMap == true {
            circleBothClass.FuncPositionTheMap(circleCoordinate: circleInternCoordinate, circleRadius: circleInternRadius)
        }
        
        circleDotRadius = mapView.FuncCircleDotRadiusZoom(mapView: mapView)
        circleBothClass.FuncCreateCircleDot(circleDotCoordinate: circleDotCoordinate, circleDotRadius: circleDotRadius)
    }
    
}
