//
//  CircleExternClass.swift
//  CircularRegionMap
//
//  Created by Nuno Martins on 28/01/2019.
//  Copyright © 2019 Nuno Martins. All rights reserved.
//

import MapKit

class CircleExtern: NSObject, MKMapViewDelegate {
    
    let mapView: MKMapView!
    let circleBothClass: CircleBoth

    static var PolygonExtern = MKPolygon()

    static var circlePolygonExtern = MKPolygon()
    var circlePolygonExternRadius: Double
    var circlePolygonExternCoordinate: CLLocationCoordinate2D
    
    var circleDotRadius = Double()
    var circleDotCoordinate: CLLocationCoordinate2D {
        return circleBothClass.FuncCircleDotCoordinate(circleCoordinate: circlePolygonExternCoordinate, circleRadius: circlePolygonExternRadius)
    }
    
    init(mapView: MKMapView, circleBothClass: CircleBoth, circlePolygonExternCoordinate: CLLocationCoordinate2D, circlePolygonExternRadius: Double) {
        
        self.mapView = mapView
        self.circleBothClass = circleBothClass
        
        self.circlePolygonExternCoordinate = circlePolygonExternCoordinate
        self.circlePolygonExternRadius = circlePolygonExternRadius
        
        super.init()
    }

    func FuncCreateCircles (circlePolygonExternCoordinate: CLLocationCoordinate2D, circlePolygonExternRadius: Double, PositionTheMap: Bool) {
        
        mapView.removeOverlay(CircleExtern.PolygonExtern)
        mapView.removeOverlay(CircleExtern.circlePolygonExtern)

        var circlePolygonExternTangentPoint = CGPoint()
        var circlePolygonExternTangentCoordinates = [CLLocationCoordinate2D]()

        let circlePolygonExternPoint = MKMapPoint(circlePolygonExternCoordinate)
        let radiusCirclePolygonExternInMKMapPoint = MKMapPointsPerMeterAtLatitude(circlePolygonExternCoordinate.latitude)*circlePolygonExternRadius

        //coordenada nova = coordenada atual + raio * cos/sin angulo(em radianos)
        for angle in 0..<360 {
            circlePolygonExternTangentPoint.x = CGFloat(circlePolygonExternPoint.x) + (CGFloat(radiusCirclePolygonExternInMKMapPoint) * CGFloat(cos(Double(angle) * .pi / 180.0)))
            circlePolygonExternTangentPoint.y = CGFloat(circlePolygonExternPoint.y) + (CGFloat(radiusCirclePolygonExternInMKMapPoint) * CGFloat(sin(Double(angle) * .pi / 180.0)))
            
            let circlePolygonExternTangentMKMapPoint = MKMapPoint(x: Double(circlePolygonExternTangentPoint.x), y: Double(circlePolygonExternTangentPoint.y))
            circlePolygonExternTangentCoordinates.append(circlePolygonExternTangentMKMapPoint.coordinate)
        }
        
        CircleExtern.circlePolygonExtern = MKPolygon(coordinates: circlePolygonExternTangentCoordinates, count: circlePolygonExternTangentCoordinates.count)
        let circlePolygonExternOverlay = mapView.mapView(mapView, rendererFor: CircleExtern.circlePolygonExtern).overlay as! MKPolygon
        
        mapView.addOverlay(circlePolygonExternOverlay)

        // Criar o rectangulo que vai conter o hole (circle vazio)
        let Region = MKCoordinateRegion(center: circlePolygonExternCoordinate, latitudinalMeters: 2500*1000, longitudinalMeters: 2500*1000)
        let Span = Region.span
        
        let Coordinate1 = CLLocationCoordinate2DMake((circlePolygonExternCoordinate.latitude - Span.latitudeDelta), (circlePolygonExternCoordinate.longitude + Span.longitudeDelta))
        let Coordinate2 = CLLocationCoordinate2DMake((circlePolygonExternCoordinate.latitude + Span.latitudeDelta), (circlePolygonExternCoordinate.longitude + Span.longitudeDelta))
        let Coordinate3 = CLLocationCoordinate2DMake((circlePolygonExternCoordinate.latitude + Span.latitudeDelta), (circlePolygonExternCoordinate.longitude - Span.longitudeDelta))
        let Coordinate4 = CLLocationCoordinate2DMake((circlePolygonExternCoordinate.latitude - Span.latitudeDelta), (circlePolygonExternCoordinate.longitude - Span.longitudeDelta))
        
        let pointsRectangle = [Coordinate1,Coordinate2,Coordinate3,Coordinate4]
        
        CircleExtern.PolygonExtern = MKPolygon(coordinates: pointsRectangle, count: pointsRectangle.count, interiorPolygons: [CircleExtern.circlePolygonExtern])
        let circlePolygonOverlay = mapView.mapView(mapView, rendererFor: CircleExtern.PolygonExtern).overlay as! MKPolygon
        
        mapView.addOverlay(circlePolygonOverlay)
        
        if PositionTheMap == true {
            circleBothClass.FuncPositionTheMap(circleCoordinate: circlePolygonExternCoordinate, circleRadius: circlePolygonExternRadius)
        }
        
        circleDotRadius = mapView.FuncCircleDotRadiusZoom(mapView: mapView)
        circleBothClass.FuncCreateCircleDot(circleDotCoordinate: circleDotCoordinate, circleDotRadius: circleDotRadius)
    }

}
