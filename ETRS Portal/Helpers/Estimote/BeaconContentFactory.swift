//
//  BeaconContentFactory.swift
//  Etrs
//

protocol BeaconContentFactory {

    func contentForBeaconID(beaconID: BeaconID, completion: (content: AnyObject) -> ())

}
