//
//  CircularRegionMapViewController.swift
//  CircularRegionMap
//
//  Created by Nuno Martins on 25/01/2019.
//  Copyright © 2019 Nuno Martins. All rights reserved.
//

// Links usados para fazer isto:
// https://stackoverflow.com/questions/33826319/how-to-use-mkmapviewdelegate-methods-in-mvvm-model
// https://viblo.asia/p/draw-inverted-circle-and-calculate-zoom-level-based-on-radius-in-google-maps-Qpmleno75rd
// https://stackoverflow.com/questions/36663816/how-to-set-zoom-level-or-radius-in-map-view
// https://stackoverflow.com/questions/44934818/overlay-around-annotation
// https://stackoverflow.com/questions/5270485/convert-span-value-into-meters-on-a-mapview
// https://stackoverflow.com/questions/49518958/how-do-i-remove-a-cashapelayer-and-cabasicanimation-from-my-uiview
// https://stackoverflow.com/questions/30595933/uigesturerecognizer-on-a-rounded-view
// https://stackoverflow.com/questions/43778826/detecting-touches-on-mkoverlay
// https://stackoverflow.com/questions/3492200/combining-a-uilongpressgesturerecognizer-with-a-uipangesturerecognizer
// https://stackoverflow.com/questions/25750758/why-is-drawrect-on-mkoverlayrenderer-slow
// https://www.hackingwithswift.com/example-code/system/how-to-synchronize-code-to-drawing-using-cadisplaylink
// https://stackoverflow.com/questions/38112061/correct-handling-cleanup-etc-of-cadisplaylink-in-swift-custom-animation

import UIKit
import MapKit

class CircularRegionMapVC: UIViewController {

    @IBOutlet weak var MapView: MKMapView!
    @IBOutlet weak var SegmentControlCircle: UISegmentedControl!
    
    // FCT/UNL
    var circleCoordinate = CLLocationCoordinate2DMake(38.661074, -9.205817)
    var circleRadius: Double = 100
    
    var circleDotCoordinate = CLLocationCoordinate2D()
    var circleDotRadius: Double = 12

    // pan = drag (is the same)
    var panGesture = UIPanGestureRecognizer()
    var pressGesture = UILongPressGestureRecognizer()
    static var radiusCircleInternInMKMapPointGesture = Double()

    static var pulsatingLayer = CAShapeLayer()
    
    var displayLink: CADisplayLink?

    var radiusText : UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.textColor = UIColor(red: 0/255, green: 109/255, blue: 255/255, alpha: 0.8)
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let circleBothClass = CircleBoth(mapView: MapView, circleCoordinate: circleCoordinate, circleRadius: circleRadius)
        
        // Começar logo com o Circle Intern
        let circleInternClass = CircleIntern(mapView: MapView, circleBothClass: circleBothClass, circleInternCoordinate: circleCoordinate, circleInternRadius: circleRadius)
        circleInternClass.FuncCreateCircles(circleInternCoordinate: circleCoordinate, circleInternRadius: circleRadius, PositionTheMap: true)
       
        // Nao é necessario chamar regionWillChangeAnimated e o regionDidChangeAnimated assim que se abre a app
        
        pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(CircleDotPressGesture(_:)))
        // o tempo pressionado é tao pequeno que parece que estamos a usar o pan = drag
        pressGesture.delegate = self
        pressGesture.minimumPressDuration = 0.01
        self.MapView.addGestureRecognizer(pressGesture)
        
        // nao se usa o tap pois este so é atividado ja no final do movimento coisa que nao queremos
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(CircleDotPanGesture(_:)))
        panGesture.delegate = self
        self.MapView.addGestureRecognizer(panGesture)

        view.addSubview(radiusText)
        radiusText.isHidden = true
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = circleCoordinate
        self.MapView.addAnnotation(annotation)
    }
    
    @IBAction func SegmentedControlCircleInOut(_ sender: Any) {
        
        let circleBothClass = CircleBoth(mapView: MapView, circleCoordinate: circleCoordinate, circleRadius: circleRadius)
        MapView.removeOverlay(CircleBoth.circleDot)

        switch SegmentControlCircle.selectedSegmentIndex {
        case 0:

            MapView.removeOverlay(CircleExtern.PolygonExtern)
            MapView.removeOverlay(CircleExtern.circlePolygonExtern)

            let circleInternClass = CircleIntern(mapView: MapView, circleBothClass: circleBothClass, circleInternCoordinate: circleCoordinate, circleInternRadius: circleRadius)
            circleInternClass.FuncCreateCircles(circleInternCoordinate: circleCoordinate, circleInternRadius: circleRadius, PositionTheMap: true)
        case 1:

            MapView.removeOverlay(CircleIntern.circleIntern)
            
            let circleExternClass = CircleExtern(mapView: MapView, circleBothClass: circleBothClass, circlePolygonExternCoordinate: circleCoordinate, circlePolygonExternRadius: circleRadius)
            circleExternClass.FuncCreateCircles(circlePolygonExternCoordinate: circleCoordinate, circlePolygonExternRadius: circleRadius, PositionTheMap: true)
            
        default:
            break
        }
    }
    
}
