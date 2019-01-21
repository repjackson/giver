Template.register.onRendered ->
    $('body').addClass 'landing-page'
    Meta.setTitle 'Sign Up - Joyful Giver'
    Meta.set 'og:title', 'Sign Up - Joyful Giver'


Template.register.events
    'mouseenter .heartbeat': ->
        $('.heartbeat').transition('pulse')

    'mouseenter .university': ->
        $('.university').transition('pulse')


Template.register_church.events
	'click #register': (event, template) ->
		$('#churchForm').data('bootstrapValidator').validate()
		if $('#churchForm').data('bootstrapValidator').isValid()
			showLoadingMask()
			profile =
				churchName: $('#cname').val()
				phone: $('#cphone').val()
				address:
					street: $('#caddress').val()
					city: $('#ccity').val()
					state: $('#cstate').val()
					zip: $('#czip').val()
				website: $('#cwebsite').val()
				name: $('#cfirstname').val()
				isActive: true
				isJGFeesApply: false
			options =
				email: $('#cemail').val().toLowerCase()
				password: $('#cpassword').val()
				profile: profile
			Meteor.call 'createChurchAccount', options, (error) ->
				hideLoadingMask()
				if error
					FlashMessages.sendError error.reason
				else
					Meteor.loginWithPassword $('#cemail').val().toLowerCase(), $('#cpassword').val(), ->
						if Meteor.user() and Meteor.user().emails[0]
							document.cookie = 'loggedinEmailId=' + Meteor.user().emails[0].address
						Router.go '/dashboard'

	'click #tosModal': (e, t) ->
		e.preventDefault()
		$('#tosModalpopup').modal 'show'

Template.register_church.onRendered ->
	$('#churchForm').bootstrapValidator
		message: 'This value is not valid'
		feedbackIcons:
			valid: 'glyphicon glyphicon-ok'
			invalid: 'glyphicon glyphicon-remove'
			validating: 'glyphicon glyphicon-refresh'
		fields:
			name:
				message: 'You must provide a organization name.'
				validators: notEmpty: message: 'Organization Name is mandatory'
			address:
				message: 'You must provide a organization address.'
				validators: notEmpty: message: 'Organization address is mandatory'
			city:
				message: 'You must provide a city.'
				validators: notEmpty: message: 'City is mandatory'
			state:
				message: 'You must provide a State.'
				validators: notEmpty: message: 'State is mandatory'
			zip:
				message: 'You must provide a Zip Code.'
				validators:
					notEmpty: message: 'Zip Code is mandatory'
					zipCode:
						country: 'US'
						message: 'The value is not valid US zip code'
			phone:
				message: 'You must provide a phone number.'
				validators:
					notEmpty: message: 'Phone Number is mandatory'
					phone:
						country: 'US'
						message: 'The value is not valid US phone number'
			firstname:
				message: 'You must provide an account holder firstname.'
				validators: notEmpty: message: 'First Name is mandatory'
			lastname:
				message: 'You must provide an account holder lastname.'
				validators: notEmpty: message: 'Last Name is mandatory'
			email:
				message: 'You must provide an email.'
				validators:
					notEmpty: message: 'Email is mandatory'
					emailAddress: message: 'The value is not a valid email address'
			password:
				message: 'You must provide a password.'
				validators: notEmpty: message: 'Password is mandatory'
	Meta.setTitle 'Sign Up organization- Joyful Giver'
	Meta.set 'og:title', 'Sign Up organization- Joyful Giver'

Template.register_nonprofit.events
	'click #register': (event, template) ->
		$('#churchForm').data('bootstrapValidator').validate()
		if $('#churchForm').data('bootstrapValidator').isValid()
			showLoadingMask()
			profile =
				churchName: $('#nname').val()
				phone: $('#nphone').val()
				address:
					street: $('#naddress').val()
					city: $('#ncity').val()
					state: $('#nstate').val()
					zip: $('#nzip').val()
				website: $('#nwebsite').val()
				name: $('#nfirstname').val()
				isActive: true
				isJGFeesApply: false
			options =
				email: $('#nemail').val().toLowerCase()
				password: $('#npassword').val()
				profile: profile
			Meteor.call 'createChurchAccount', options, (error) ->
				hideLoadingMask()
				if error
					FlashMessages.sendError error.reason
				else
					Meteor.loginWithPassword $('#nemail').val().toLowerCase(), $('#npassword').val(), ->
						if Meteor.user() and Meteor.user().emails[0]
							document.cookie = 'loggedinEmailId=' + Meteor.user().emails[0].address
						Router.go '/dashboard'

	'click #tosModal': (e, t) ->
		e.preventDefault()
		$('#tosModalpopup').modal 'show'

Template.register_nonprofit.onRendered ->
	$('#churchForm').bootstrapValidator
		message: 'This value is not valid'
		feedbackIcons:
			valid: 'glyphicon glyphicon-ok'
			invalid: 'glyphicon glyphicon-remove'
			validating: 'glyphicon glyphicon-refresh'
		fields:
			name:
				message: 'You must provide a organization name.'
				validators: notEmpty: message: 'Organization Name is mandatory'
			address:
				message: 'You must provide a organization address.'
				validators: notEmpty: message: 'Organization address is mandatory'
			city:
				message: 'You must provide a city.'
				validators: notEmpty: message: 'City is mandatory'
			state:
				message: 'You must provide a State.'
				validators: notEmpty: message: 'State is mandatory'
			zip:
				message: 'You must provide a Zip Code.'
				validators:
					notEmpty: message: 'Zip Code is mandatory'
					zipCode:
						country: 'US'
						message: 'The value is not valid US zip code'
			phone:
				message: 'You must provide a phone number.'
				validators:
					notEmpty: message: 'Phone Number is mandatory'
					phone:
						country: 'US'
						message: 'The value is not valid US phone number'
			firstname:
				message: 'You must provide an account holder firstname.'
				validators: notEmpty: message: 'First Name is mandatory'
			lastname:
				message: 'You must provide an account holder lastname.'
				validators: notEmpty: message: 'Last Name is mandatory'
			email:
				message: 'You must provide an email.'
				validators:
					notEmpty: message: 'Email is mandatory'
					emailAddress: message: 'The value is not a valid email address'
			password:
				message: 'You must provide a password.'
				validators: notEmpty: message: 'Password is mandatory'
	Meta.setTitle 'Sign Up organization- Joyful Giver'
	Meta.set 'og:title', 'Sign Up organization- Joyful Giver'


# Template.register_giver.helpers 'titheData': ->
#   if Session.get('registerTithe')
#     Meteor.subscribe 'oneTithe', Session.get('registerTithe')


Template.register_giver.events
	'click #register': (event, template) ->
		$('#loginForm').data('bootstrapValidator').validate()
		if $('#loginForm').data('bootstrapValidator').isValid()
			showLoadingMask()
			profile =
				name: $('#lname').val()
				tour: false
				isActive: true
			if $('#phone').val()
				profile.phone = Phoneformat.formatE164('US', $('#phone').val())
			options =
				email: $('#lemail').val().toLowerCase()
				password: $('#password').val()
				profile: profile
				username: $('#lname').val()
				name: $('#lname').val()
			#console.log("options = ", options)
			if Session.get('registerTithe')
				titheData = tithe: Session.get('registerTithe')
			else
				titheData = false
			Meteor.call 'createGiverAccount', options, titheData, (error) ->
				hideLoadingMask()
				if error
					# $('#registerError').html('<p>'+error.reason+'</p>').fadeIn();
					FlashMessages.sendError error.reason
				else
					Meteor.loginWithPassword $('#lemail').val().toLowerCase(), $('#password').val(), ->
						if Meteor.user() and Meteor.user().emails[0]
							document.cookie = 'loggedinEmailId=' + Meteor.user().emails[0].address
						Router.go '/dashboard'

	'click #tosModal': (e, t) ->
		e.preventDefault()
		$('#tosModalpopup').modal 'show'

	'click #privacyPolicyModal': (e, t) ->
		e.preventDefault()
		$('#privacyPolicyDisplayModal').modal 'show'

Template.register_giver.onRendered ->
# 	message: 'This value is not valid'
# 	feedbackIcons:
# 		valid: 'glyphicon glyphicon-ok'
# 		invalid: 'glyphicon glyphicon-remove'
# 		validating: 'glyphicon glyphicon-refresh'
# 	fields:
# 		name:
# 			message: 'You must provide an account holder firstname.'
# 			validators: notEmpty: message: 'First Name is mandatory'
# 		email:
# 			message: 'You must provide an email.'
# 			validators:
# 				notEmpty: message: 'Email is mandatory'
# 				emailAddress: message: 'The value is not a valid email address'
# 		phone: validators: phone:
# 			country: 'US'
# 			message: 'The value is not valid US phone number'
# 		password:
# 			message: 'You must provide a password.'
# 			validators: notEmpty: message: 'Password is mandatory'
	Meta.setTitle 'Register Donor- Joyful Giver'
	Meta.set 'og:title', 'Register Donor- Joyful Giver'