//
//  MapViewModel.swift
//  Share Location
//
//  Created by Tiago Oliveira on 11/04/19.
//  Copyright © 2019 Tiago Oliveira. All rights reserved.
//

import Foundation
import UIKit

class MapViewModel {
    func logout(_ controller: UIViewController) {
        controller.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
