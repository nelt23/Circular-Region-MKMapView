//
//  CircleDotRadiusZoomExtension.swift
//  CircularRegionMap
//
//  Created by Nuno Martins on 27/01/2019.
//  Copyright © 2019 Nuno Martins. All rights reserved.
//

import MapKit

extension MKMapView: MKMapViewDelegate {
    
    func FuncCircleDotRadiusZoom (mapView: MKMapView) -> Double {
        
        let RectangleVisibleMap = mapView.visibleMapRect
        
        let LatitudeLowerMapPoint =  MKMapPoint(x: RectangleVisibleMap.minX, y: RectangleVisibleMap.minY)
        let LatitudeHighestMapPoint = MKMapPoint(x: RectangleVisibleMap.maxX, y: RectangleVisibleMap.maxY)
        
        let DistanceMeters = LatitudeLowerMapPoint.distance(to: LatitudeHighestMapPoint)
                
        return round((DistanceMeters/80)/10)*12
    }
    
    
     public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        // necessario delegar para aparecer no screen
        mapView.delegate = self
        
        if let overlayCircle = overlay as? MKCircle {

            if overlayCircle.radius == FuncCircleDotRadiusZoom(mapView: mapView) {
                
                let circleDotView = MKCircleRenderer(overlay: overlay)
                circleDotView.fillColor = UIColor.black
                
                return circleDotView
                
            } else {
                
                let circleView = MKCircleRenderer(overlay: overlay)
                circleView.fillColor = UIColor(red: 0/255, green: 109/255, blue: 255/255, alpha: 0.2)
                circleView.lineWidth = 4.0
                circleView.strokeColor = UIColor(red: 0/255, green: 109/255, blue: 255/255, alpha: 0.8)
                
                return circleView
            }
            
        } else if let overlayPolygon = overlay as? MKPolygon {
            
            if overlayPolygon.pointCount == 4 {
                let polygonView = MKPolygonRenderer(polygon: overlay as! MKPolygon)
                polygonView.fillColor = UIColor(red: 0/255, green: 109/255, blue: 255/255, alpha: 0.2)
                polygonView.lineWidth = 0.0
                return polygonView
                
            } else {
                let polygonView = MKPolygonRenderer(polygon: overlay as! MKPolygon)
                polygonView.lineWidth = 4.0
                polygonView.strokeColor = UIColor(red: 0/255, green: 109/255, blue: 255/255, alpha: 0.8)
                return polygonView
            }
            
            
        } else {
            
            let overlayPolyline = overlay as! MKGeodesicPolyline
            
            let polylineView = MKPolylineRenderer(overlay: overlayPolyline)
            polylineView.strokeColor = UIColor(red: 0/255, green: 109/255, blue: 255/255, alpha: 0.8)
            polylineView.lineWidth = 2.5
            polylineView.lineDashPattern = [1,5]
            
            return polylineView
        }
        
    }

}
