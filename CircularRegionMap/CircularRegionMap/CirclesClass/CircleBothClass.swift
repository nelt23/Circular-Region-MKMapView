//
//  CircleBothClass.swift
//  CircularRegionMap
//
//  Created by Nuno Martins on 02/02/2019.
//  Copyright © 2019 Nuno Martins. All rights reserved.
//

// Comum aos 2 circles (Intern e Extern)
// 1. -> Coordenadas do Centro do Circle (local com annotation)
// 2. -> Circle Dot
// 3. -> dashedPolyline
// 4. -> Position The Map
// 5. -> rendererFor overlay (onde estao as caracteristicas dos overlays)

import MapKit

class CircleBoth: NSObject, MKMapViewDelegate {
    
    let mapView: MKMapView!
    
    var circleCoordinate: CLLocationCoordinate2D
    var circleRadius: Double

    static var circleDot = MKCircle()
    var circleDotRadius = Double()
    var circleDotCoordinate: CLLocationCoordinate2D {
        return FuncCircleDotCoordinate(circleCoordinate: circleCoordinate, circleRadius: circleRadius)
    }

    static var dashedPolyline = MKGeodesicPolyline()
    
    init(mapView: MKMapView, circleCoordinate: CLLocationCoordinate2D, circleRadius: Double) {
        
        self.mapView = mapView
        self.mapView.isRotateEnabled = false
        self.mapView.isPitchEnabled = false
        
        self.circleCoordinate = circleCoordinate
        self.circleRadius = circleRadius
        
        super.init()
    }

    func FuncCircleDotCoordinate (circleCoordinate: CLLocationCoordinate2D, circleRadius: Double) -> CLLocationCoordinate2D {
        
        var circleTangentPoint = CGPoint()
        
        let circlePoint = MKMapPoint(circleCoordinate)
        let radiusCircleInMKMapPoint = MKMapPointsPerMeterAtLatitude(circleCoordinate.latitude)*circleRadius
        
        circleTangentPoint.x = CGFloat(circlePoint.x) + CGFloat(radiusCircleInMKMapPoint)
        circleTangentPoint.y = CGFloat(circlePoint.y)
        
        let circleTangentMKMapPoint = MKMapPoint(x: Double(circleTangentPoint.x), y: Double(circleTangentPoint.y))
        let circleDotCoordinate = circleTangentMKMapPoint.coordinate
        
        return circleDotCoordinate
    }

    func FuncCreateCircleDot (circleDotCoordinate: CLLocationCoordinate2D, circleDotRadius: Double) {
        
        FuncCreateDashedLine(circleCoordinate: circleCoordinate, circleDotCoordinate: circleDotCoordinate)
        
        mapView.removeOverlay(CircleBoth.circleDot)
        
        CircleBoth.circleDot = MKCircle(center: circleDotCoordinate, radius: circleDotRadius)
        let circleDotOverlay = mapView.mapView(mapView, rendererFor: CircleBoth.circleDot).overlay as! MKCircle
        
        mapView.addOverlay(circleDotOverlay)
    }
        
    func FuncPositionTheMap (circleCoordinate: CLLocationCoordinate2D, circleRadius: Double) {
        
        let coordinateRegion = MKCoordinateRegion(center: circleCoordinate, latitudinalMeters: circleRadius*5, longitudinalMeters: circleRadius*5)
        mapView.setRegion(coordinateRegion, animated: false)
    }
    
    func FuncCreateDashedLine (circleCoordinate: CLLocationCoordinate2D, circleDotCoordinate: CLLocationCoordinate2D) {
        
        mapView.removeOverlay(CircleBoth.dashedPolyline)

        let CoordinatesStarAndEnd = [circleCoordinate,circleDotCoordinate]
        CircleBoth.dashedPolyline = MKGeodesicPolyline(coordinates: CoordinatesStarAndEnd, count: CoordinatesStarAndEnd.count)
        let dashedPolylineOverlay = mapView.mapView(mapView, rendererFor: CircleBoth.dashedPolyline).overlay as! MKGeodesicPolyline
        
        mapView.addOverlay(dashedPolylineOverlay)
    }
    
}
