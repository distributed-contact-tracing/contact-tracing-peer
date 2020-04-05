
func computeDistances(rawData: [(rssi: Double, time: Double)]) 
                            -> [(distance: Double, time: Double)]{
    const Double txPower = 0;
    var distanceData: [(distance: Double, time: Double)]; 
    for data in rawData{
        Double rssi = data.0;
        Double time = data.1;
        Double distance = pow(10, (txPower - rssi) / (2 * 10));
        distanceData.append((distance: distance, time: time));
    }

    return distanceData;
}

func computeSeverity(rawData: [(rssi: Double, time: Double)])  -> Int {
    var distanceData = computeDistances(rawData);
    
    Double minDistance = 1000000.0;
    for data in distanceData {
        var distance = data.0;
        if (distance < minDistance) { minDistance = distance;}
    }
    if (minDistance < 2){
        return 2;
    } else if (minDistance < 8){
        return 1;
    } else {
        return 0;
    }
}
