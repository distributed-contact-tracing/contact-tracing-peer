// Code for discovering connections over (i)Beacons 
// Setting up a connection over either bluetooth or MultiPeer or similar
// Transmiting random key over that connection 
// Keeping track of the severity of the interaction over beacons

// Code taken from https://developer.apple.com/documentation/corelocation/determining_the_proximity_to_an_ibeacon_device
// Unchanged
func monitorBeacons() {
    if CLLocationManager.isMonitoringAvailable(for: 
                  CLBeaconRegion.self) {
        // Match all beacons with the specified UUID
        let proximityUUID = UUID(uuidString: 
               "whatever-we_c-hoos-e_as-the_uuid0000")
        let beaconID = "distributed.contact.tracing"
            
        // Create the region and begin monitoring it.
        let region = CLBeaconRegion(proximityUUID: proximityUUID!,
               identifier: beaconID)
        self.locationManager.startMonitoring(for: region)
    }
}


// Unchanged (we can not get access 
// to major and minor in this function)
func locationManager(_ manager: CLLocationManager, 
            didEnterRegion region: CLRegion) {
    if region is CLBeaconRegion {
        // Start ranging only if the devices supports this service.
        if CLLocationManager.isRangingAvailable() {
            manager.startRangingBeacons(in: region as! CLBeaconRegion)

            // Store the beacon so that ranging can be stopped on demand.
            beaconsToRange.append(region as! CLBeaconRegion)        
        }
    }
}

// This function goes though all the devices which are monitored to see 
// if any of them have changed distance, are new or are gone. 
// It assumes the existance of the data structure nearbyUsers
// Containing all the nearby users in the last call
// A userLog contains the history of all the proximities and the random key
func locationManager(_ manager: CLLocationManager, 
            didRangeBeacons beacons: [CLBeacon], 
            in region: CLBeaconRegion) {
    for beacon in beacons {
        let beaconId = beacon.major,beacon.minor

        // Check if this is a currently connected person
        if beaconId in nearbyUsers {
            var userLog = nearbyUsers[beaconId]

            // Update proximity if it has changed
            if userLog.lastDist != beacon.proximity {
                userLog.logTimeOfMove(beacon.proximity)
                userLog.lastDist = beacon.proximity
            }
        
        // If this is a new device we need to exchange keys
        } else {

           val conn = connect(beaconId)
            if conn.isMaster { 
                let randKey = generateRandKey()
                conn.send(beaconId, randKey)
            } else { 
                let randKey = conn.receive(beaconId)
            }
            var userLog = new UserLog(randKey, beaconID, beacon.proximity)
           nearbyUsers.append(userLog) 
        }
    }

    // Go though the current nearby Users to check if anyone has left
    for log in nearbyUsers {
        var nearbyUser = log.beacon

        // If a beacon has left the monitored area
        if neabyUser not in beacons {
            let severity = computeSeverity(log)
            dataBase.save(log.randKey, severity)
            nearbyUsers.delete(nearbyUser)
        }
    }
}

// Connect with another user to send random keys
func connect(beaconID) 
// use the beaconId (major, minor) to construct the address for the connection
// return a connection over either bluetooth or MultiPeer (only iOS)

// Generate a random string of bits (about 10 bytes)
func generateRandKey()
// return the random bits

// Get an estimate of how dangerous this interaction was
func computeSeverity(log)
// Use the transmissions times between the different proximities 
// to compute how dangerous it was
// return severtity from 0 to 5 (or something alike)

// dataBase is the data base where all interactions and severity are stored



