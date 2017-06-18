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

final class BELocationManager: NSObject {

    public static let shared = BELocationManager()

    let feedbackGenerator = SQFeedbackGenerator()

    fileprivate lazy var locationManager: CLLocationManager = { [weak self] in
        let l = CLLocationManager()
        l.desiredAccuracy = 2000
        l.allowsBackgroundLocationUpdates = false
        l.delegate = self
        return l
    }()

    fileprivate let geocoder = CLGeocoder()

}

extension BELocationManager: CLLocationManagerDelegate {


    func requestAuthorization(successCallback: ((Bool)-> Void)? = nil) {

        if CLLocationManager.locationServicesEnabled() {

            switch CLLocationManager.authorizationStatus() {

            case .notDetermined:
                // Only needs "when in use"
                self.locationManager.requestWhenInUseAuthorization()

            case .authorizedAlways, .authorizedWhenInUse:
                // OK
                print("Ok, location enabled")
                guard let callback = successCallback else { return }
                callback(true)

            case .restricted:
                DispatchQueue.main.async {
                    HUD.flash(.labeledError(title: "User did not allow location", subtitle: "Accessing location is needed for..."), delay: 2)
                }
                guard let callback = successCallback else { return }
                callback(false)
                self.feedbackGenerator.generateFeedback(type: .error)

            case .denied:

                DispatchQueue.main.async {
                    HUD.flash(.error, delay: 2)
                }
                guard let callback = successCallback else { return }
                callback(false)
                self.feedbackGenerator.generateFeedback(type: .error)
            }
        } else {
            // Present Error for Location Services disabled
            HUD.show(HUDContentType.labeledError(title: "The location services are not enabled", subtitle: "Go to settings and enable it"))
            self.feedbackGenerator.generateFeedback(type: .error)
        }
    }

    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        // Did pause location
        print("Did pause location updates")
    }

    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        // Did resume location
        print("Did resume location updates")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Did change authorization

        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            // Always or when in use
            self.locationManager.startMonitoringSignificantLocationChanges()
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
        let err = error as NSError
        print(err.code)
        print(err.localizedDescription)
        print(err.localizedFailureReason ?? "")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // New location available
        guard let location = locations.first else { return }

        self.geocoder.reverseGeocodeLocation(location) { (placemarks: [CLPlacemark]?, error: Error?) in
            guard let placemark = placemarks?.first else {
                return
            }

            if let error = error {
                print(error)
                self.feedbackGenerator.generateFeedback(type: .error)
            } else {
                self.feedbackGenerator.generateFeedback(type: .success)
            }


            if let country = placemark.country,
                let isoCode = placemark.isoCountryCode {
                print(country)
                print(isoCode)
                self.updateCurrencyFromLocation(countryCode: isoCode)
            }
        }
    }


    func requestCurrentLocation() {
        guard BESettings.automaticGeolocation.boolValue == true else { return }
        self.requestAuthorization { success in
            if success {
                self.locationManager.startMonitoringSignificantLocationChanges()
            } else {
                self.locationManager.stopMonitoringSignificantLocationChanges()
            }
        }
    }

    func updateCurrencyFromLocation(countryCode: String) {
        let restCountriesWS = BERestCountriesWebService()
        restCountriesWS.askForCurrencyFromCountryCode(countryCode) { (success, value) in
            if success {
                if let countryCode = value {
                    BERealmManager.shared.setCurrency(forActiveCurrency: true, currencyCode: countryCode)
                }
            }
        }
    }


}
