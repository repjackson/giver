Template.demo.helpers
  androidOS: ->
    if Meteor.isCordova
      devicePlatform = device.platform
      console.log 'mobile platform: ', devicePlatform
      if devicePlatform == 'iOS'
        return false
      else
        # This is an android device!!!
        return true