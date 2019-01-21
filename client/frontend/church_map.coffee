allMapMarkers = {}
Template.churchMap.onRendered ->
  GoogleMaps.load
    v: '3'
    key: 'AIzaSyA44_Aq1-OkLvnmDKnTlfDBCRn-aOsSnKU'

Template.churchMap.helpers churchMapOptions: ->
  latLng = Geolocation.latLng()
  # Initialize the map once we have the latLng.
  if GoogleMaps.loaded() and latLng
    #console.log(latLng)
    return {
      center: new (google.maps.LatLng)(latLng.lat, latLng.lng)
      zoom: 10
    }

Template.churchMap.onCreated ->
  GoogleMaps.ready 'churchMap', (map) ->
    latLng = Geolocation.latLng()
    markers = []
    allMapMarkers = []
    if latLng
      Meteor.call 'churchGeoSearch', latLng.lat, latLng.lng, 50000, (err, churches) ->
        churches.forEach (chrch) ->
          church =
            _id: chrch._id
            lat: chrch.profile.loc.coordinates[1]
            lng: chrch.profile.loc.coordinates[0]
            name: chrch.profile.churchName
            address: chrch.profile.address
          marker = new (google.maps.Marker)(
            position: new (google.maps.LatLng)(church.lat, church.lng)
            map: map.instance)
          infoWindow = new (google.maps.InfoWindow)(content: Blaze.toHTMLWithData(Template.churchInfoWindow, church))
          marker.addListener 'click', ->
            infoWindow.open map, marker
            return
          markers.push marker
          allMapMarkers.push
            id: chrch._id
            marker: marker
            iw: infoWindow
          return
        return
    map.instance.addListener 'zoom_changed', ->
      markers.forEach (m) ->
        m.setMap null
        return
      allMapMarkers = []
      distance = 591657550.500000 / 2 ** (map.instance.getZoom() - 1)
      Meteor.call 'churchGeoSearch', latLng.lat, latLng.lng, distance, (err, churches) ->
        churches.forEach (chrch) ->
          church =
            _id: chrch._id
            lat: chrch.profile.loc.coordinates[1]
            lng: chrch.profile.loc.coordinates[0]
            name: chrch.profile.churchName
            address: chrch.profile.address
          marker = new (google.maps.Marker)(
            position: new (google.maps.LatLng)(church.lat, church.lng)
            map: map.instance)
          infoWindow = new (google.maps.InfoWindow)(content: Blaze.toHTMLWithData(Template.churchInfoWindow, church))
          marker.addListener 'click', ->
            infoWindow.open map, marker
            return
          markers.push marker
          allMapMarkers.push
            id: chrch._id
            marker: marker
            iw: infoWindow