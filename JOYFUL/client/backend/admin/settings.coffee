Template.appSettings.events
	'click .toggle_config': (event) ->
	  setting = event.currentTarget.id
	  config = AppSettings.findOne()
	  jsonObj = {}
	  jsonObj[setting] = if config[setting] then false else true
	  Meteor.call 'saveAppSettings', config._id, jsonObj