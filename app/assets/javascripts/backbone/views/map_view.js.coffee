class Tennis.Views.MapView extends Backbone.View
  initialize: ->
    @handler = Gmaps.build('Google', builders: { Marker: CustomMarkerBuilder })
    @geocoder = new google.maps.Geocoder()
    @listenTo(@collection, 'change', @renderMarkers) if @collection
    @externalDomListeners()

  externalDomListeners: ->
    $ => 
      $('a[data-toggle="tab"]').on 'shown.bs.tab', (e) =>
        google.maps.event.trigger(@handler.getMap(), 'resize')

      input = $('#searcher #place')[0]
      options = 
        bounds: @moscowBounds()
        type: ['geocode']
      @autocomplete = new google.maps.places.Autocomplete(input, options)


      $('[data-search-on-map]').on 'click', (e) =>
        if $('#searcher #place').val() && @autocomplete.getPlace()
          e.preventDefault()
          map.handler.getMap().panTo(map.autocomplete.getPlace().geometry.location)
        else if $('#searcher #name').val()
          e.preventDefault()
          marker = markers.where(name: $('#searcher #name').val())[0]
          @handler.getMap().addListener 'center_changed', (e) =>
            @handler.getMap().setZoom(16)
          @handler.getMap().panTo(marker.attributes.position)
        else if $('#searcher #category_id').val()
          $('#searcher').on 'ajax:success', (e, data) =>
            @renderMarkers(new Tennis.Collections.MarkerCollection(data))



  moscowCoords: ->
    lat: 55.75
    lng: 37.61

  moscowBounds: ->
    new google.maps.LatLngBounds(
      new google.maps.LatLng(56.06, 36.86),
      new google.maps.LatLng(55.53, 38.09)
    )

  coords: -> @moscowCoords()

  render: ->
    @handler.buildMap { provider: {scrollwheel: false}, internal: {id: 'map'}}, =>
      if @collection
        @markers = @handler.addMarkers(@collection.models) 
        # @handler.bounds.extendWith(@markers)
        # @handler.fitMapToBounds()
        @handler.getMap().setCenter(@moscowCoords())
        @handler.getMap().setZoom(12)
      else
        @handler.getMap().setCenter(@coords())
      if @markers.length == 1 
        @handler.getMap().setZoom(14)
        @handler.getMap().setCenter(@collection.models[0].get('position'))
      @afterMap() if @afterMap

    this

  renderMarkers: (collection) ->
    console.log 'Re-rendering marker data'
    @handler.removeMarkers(@markers)
    @markers = @handler.addMarkers collection.models
    @handler.bounds.extendWith(@markers)
    @handler.fitMapToBounds()