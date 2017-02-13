angular.module('BB.Services').factory('GeolocationService', $q =>

  ({
    haversine(position1, position2) {
      let pi = Math.PI;
      let R = 6371;  //equatorial radius
      let distances = [];

      let lat1 = position1.lat;
      let lon1 = position1.long;

      let lat2 = position2.lat;
      let lon2 = position2.long;

      let chLat = lat2-lat1;
      let chLon = lon2-lon1;

      let dLat = chLat*(pi/180);
      let dLon = chLon*(pi/180);

      let rLat1 = lat1*(pi/180);
      let rLat2 = lat2*(pi/180);

      let a = (Math.sin(dLat/2) * Math.sin(dLat/2)) +
          (Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(rLat1) * Math.cos(rLat2));
      let c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
      let d = R * c;

      return d;
    },


    geocode(address, prms) {

      if (prms == null) { prms = {}; }
      let deferred = $q.defer();
      let request = {address};
      if (prms.region) { request.region = prms.region; }
      if (prms.componentRestrictions) { request.componentRestrictions = prms.componentRestrictions; }

      if (prms.bounds) {
        let sw = new google.maps.LatLng(prms.bounds.sw.x, prms.bounds.sw.y);
        let ne = new google.maps.LatLng(prms.bounds.ne.x, prms.bounds.ne.y);
        request.bounds = new google.maps.LatLngBounds(sw, ne);
      }

      new google.maps.Geocoder().geocode(request, function(results, status) {
        if (results && (status === 'OK')) {
          return deferred.resolve({results, status});
        } else {
          return deferred.reject(status);
        }
      });

      return deferred.promise;
    }
  })
);
