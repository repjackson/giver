Template.newUserTour.events
  'click #goHome': (event, template) ->
    Meteor.call 'toggleUserTour'
    return
  'click #startTour': (event, template) ->
    $('#tourSlide0').delay(1500).addClass 'animated slideOutUp'
    $('#tourSlide1').delay(500).addClass('animated slideInUp').show ->
      $('#slide1B').delay(1000).addClass('animated bounceInLeft').show()
      return
    return
Template.newUserTour.helpers androidOS: ->
  if Meteor.isCordova
    devicePlatform = device.platform
    console.log 'mobile platform: ', devicePlatform
    if devicePlatform == 'iOS'
      return false
    else
      # This is an android device!!!
      return true
  false

Template.newUserTour.rendered = ->
  #new WOW().init()
  #  $('#letsStart').delay(2500).addClass('animated bounceInLeft').show();
  #$('#goHome').function
  return
