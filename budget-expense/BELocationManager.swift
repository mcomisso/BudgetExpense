//
//  BELocationManager.swift
//  budget-expense
//
//  Created by Matteo Comisso on 11/06/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import CoreLocation
import SQFeedbackGenerator
import PKHUD

class BELocationManager: NSObject {

    let feedbackGenerator = SQFeedbackGenerator()

    lazy var locationManager: CLLocationManager = { [weak self] in
        let l = CLLocationManager()
        l.desiredAccuracy = 2000
        l.allowsBackgroundLocationUpdates = false
        l.delegate = self
        return l
    }()

    fileprivate let geocoder = CLGeocoder()

}

extension BELocationManager: CLLocationManagerDelegate {


    func requestAuthorization() {

        if CLLocationManager.locationServicesEnabled() {

            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                // Only needs "when in use"
                self.locationManager.requestWhenInUseAuthorization()
            case .authorizedAlways, .authorizedWhenInUse:
                // OK
                print("OK")
                HUD.flash(.success, delay: 2)
            case .restricted:
                HUD.flash(.labeledError(title: "User did not allow location", subtitle: "Accessing location is needed for..."), delay: 2)
                self.feedbackGenerator.generateFeedback(type: .error)
            default:
                HUD.flash(.error, delay: 2)
                self.feedbackGenerator.generateFeedback(type: .error)
            }
        } else {
            // Present Error
            self.feedbackGenerator.generateFeedback(type: .error)
        }
    }


    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        // Did pause location
    }

    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        // Did resume location
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Did change authorization

        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            // Always or when in use
            self.locationManager.requestLocation()
        case .denied:
            // The user explicitly denied the use of location services for this app or location services are currently disabled in Settings.
            print()
        case .notDetermined:
            // The user has not yet made a choice regarding whether this app can use location services.
            print()
        case .restricted:
            // This app is not authorized to use location services. 
            // The user cannot change this app’s status, possibly due to active restrictions such as parental controls being in place.
            print()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Print out error
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // New location available
        guard let location = locations.first else { return }

        self.geocoder.reverseGeocodeLocation(location) { (placemarks: [CLPlacemark]?, error: Error?) in
            guard let placemark = placemarks?.first else {
                return
            }

            self.feedbackGenerator.generateFeedback(type: .success)
            if let country = placemark.country,
                let isoCode = placemark.isoCountryCode {
                print(country)
                print(isoCode)
            }

            if let error = error {
                print(error)
            }
        }

    }


}
