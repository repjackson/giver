profilePicImage = '/icons/Logo_sm_100.png'

Template.account.helpers {}

Template.phone_editor.helpers 'newNumber': ->
	Phoneformat.formatLocal 'US', Meteor.user().profile.phone

Template.phone_editor.events
	'click .remove_phone': (event, template) ->
		Meteor.call 'UpdateMobileNo'
		return
	'click .resend_verification': (event, template) ->
		Meteor.call 'generateAuthCode', Meteor.userId(), Meteor.user().profile.phone
		bootbox.prompt 'We texted you a validation code. Enter the code below:', (result) ->
			code = result.toUpperCase()
			if Meteor.user().profile.phone_auth == code
				Meteor.call 'updatePhoneVerified', (err, res) ->
					if err
						alert err.reason
					else
						alert 'Your phone was successfully verified!'
					return
			else
				alert 'Your verification code does not match.'

	'click .update_phone': ->
		`var phone`
		phone = $('#phone').val()
		phone = Phoneformat.formatE164('US', phone)
		Meteor.call 'savePhone2', Meteor.userId(), phone, (error, result) ->
			if error
				alert 'There was an error processing your request.'
			else
				if result.error
					alert result.message
				else
					bootbox.prompt result.message, (result) ->
						code = result.toUpperCase()
						if Meteor.user().profile.phone_auth == code
							Meteor.call 'updatePhoneVerified'
							alert 'Your phone was successfully verified!'
						else
							alert 'Your verification code does not match.'

Template.account.events
	'click .addCard': ->
		$('#add_card_modal').fadeIn()
		$('#add_buttons').show()


	'change #Profile_photo': (event, template) ->
		#  $('.imageprocessing').show();
		showLoadingMask()
		$('.clsProfilePic').hide()
		uploader = new (Slingshot.Upload)('myFileUploads')
		uploader.send document.getElementById('Profile_photo').files[0], (error, downloadUrl) ->
			if error
				hideLoadingMask()
				# Log service detailed response
				console.log error
				# console.error('Error uploading', uploader.xhr.response);
				alert error.reason
			else
				hideLoadingMask()
				#  $('.imageprocessing').hide();
				$('.clsProfilePic').show()
				profilePicImage = downloadUrl
				$('.clsProfilePic').attr 'src', downloadUrl
				# ChurchCodes.update(template.data.code._id,{$set: {'customPage.header_image': downloadUrl}})

	'click .update_profile': (e, t) ->
		e.preventDefault()
		name = $('#pname').val()
		if !name
			alert 'Please enter person name'
			return false
		dataJson =
			'profile.name': $('#pname').val()
			'profile.profilePic': if profilePicImage == '/icons/Logo_sm_100.png' then '/icons/Logo_sm_100.png' else profilePicImage
		Meteor.call 'updateUserDetail', dataJson, (err, res) ->
			if err
				alert err.reason
			else
				alert 'Account Details Updated'

Template.card_holder.events
	'click .remove': (event, template) ->
		bootbox.confirm 'Are you sure you want too remove this card?', (result) ->
			if result
				Meteor.call 'STRIPE_remove_card', template.data._id, Meteor.userId()
			return
		return
	'click .make_default': (event, template) ->
		Meteor.call 'STRIPE_change_default_card', template.data._id, Meteor.userId()
#
# Template.add_card_modal.events( {
#   isMobileDevice: function(){
#     alert("isCordova = ", Meteor.isCordova);
#     return Meteor.isCordova;
#   }
# })


Template.add_card_modal.events
	'click #scanBtn': ->
		# alert("scan card called");
		CardIO.scan {
			'expiry': true
			'cvv': true
			'zip': false
			'requireCardholderName': true
			'suppressManual': false
			'suppressConfirm': false
			'hideLogo': true
			'usePaypalIcon': false
		}, ((response) ->
			alert 'card.io scan complete'
			i = 0
			len = cardIOResponseFields.length
			while i < len
				field = cardIOResponseFields[i]
				alert field + ': ' + response[field]
				i++
			#$('#name').val(response['card_name']);
			$('#card').val response['card_number']
			$('#exp').val response['expiry_month'] + '/' + response['expiry_year']
			$('#cvc').val response['cvv']
			return
		), ->
			alert 'Scan Cancelled'

	'click .save_new_card': ->
		exp = $('#exp').val().split('/')
		Stripe.card.createToken {
			number: $('#card').val()
			exp_month: exp[0]
			exp_year: exp[1]
			address_zip: $('#zip').val()
			cvc: $('#cvc').val()
		}, (status, response) ->
			#STORE THE NEWLY TOKENIZED CARD TO THE ACCOUNT
			if !response.error
				Meteor.call 'STRIPE_store_card', response.id, Meteor.userId(), (error, result) ->
					if error
						console.log error
						$('.amDanger').html(error).fadeIn().delay('5000').fadeOut()
					else
						$('.amSuccess').html('Card Added').fadeIn().delay('5000').fadeOut()
						$('#add_card_modal').fadeOut()
						$('#name').val ''
						$('#card').val ''
						$('#exp').val ''
						$('#zip').val ''
						$('#cvc').val ''
			else
				console.log status
				#console.log(response);
				$('#add_card_modal').fadeOut()
				$('.amDanger').html(response.error.message).fadeIn().delay('5000').fadeOut()

	'click .closePopup': ->
		$('#add_card_modal').fadeOut()
		$('#name').val ''
		$('#card').val ''
		$('#exp').val ''
		$('#zip').val ''
		$('#cvc').val ''
		$('#edit_buttons').hide()
		$('#add_buttons').hide()
		return

Template.add_card_modal.onRendered ->
	message: 'This value is not valid'
	feedbackIcons:
		valid: 'glyphicon glyphicon-ok'
		invalid: 'glyphicon glyphicon-remove'
		validating: 'glyphicon glyphicon-refresh'
	fields:
		card:
			message: 'You must provide a credit card number.'
			validators:
				notEmpty: message: 'The credit card number is required'
				creditCard: message: 'The credit card number is not valid'
		cvc: validators: cvv:
			creditCardField: 'card'
			message: 'The CVV number is not valid'
		exp:
			message: 'You must provide an expiration date.'
			validators:
				callback:
					message: 'Invalid Expiration Date'
					callback: (value, validator) ->
						m = new moment(value, 'MM/YY', true)
						if !m.isValid()
							return false
						true
				notEmpty: message: 'Expiration date is required MM/YY'
		zip:
			message: 'You must provide a zip code.'
			validators:
				postcode: validators: regexp:
					regexp: /^\d{5}$/
					message: 'The US zipcode must contain 5 digits'
				notEmpty: message: 'Zip code is required'



Template.account.onRendered ->
	#app.initialize();
	return

# Template.password_editor.events 'click .change_password': (event, template) ->
# 	$('#passwordUpdate').data('bootstrapValidator').validate()
# 	if $('#passwordUpdate').data('bootstrapValidator').isValid()
# 		Accounts.changePassword $('#password').val(), $('#new_password').val(), (err, res) ->
# 			if err
# 				alert err.reason
# 			else
# 				alert 'Password Changed'
# 				# $('.amSuccess').html('<p>Password Changed</p>').fadeIn().delay('5000').fadeOut();

Template.password_editor.onRendered ->
	# message: 'This value is not valid'
	# feedbackIcons:
	# 	valid: 'glyphicon glyphicon-ok'
	# 	invalid: 'glyphicon glyphicon-remove'
	# 	validating: 'glyphicon glyphicon-refresh'
	# fields:
	# 	password:
	# 		message: 'You must enter your existing password.'
	# 		validators: notEmpty: message: 'Password is mandatory'
	# 	new_password:
	# 		message: 'You must provide a new password.'
	# 		validators: notEmpty: message: 'New Password is mandatory'
