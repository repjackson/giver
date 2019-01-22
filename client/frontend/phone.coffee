Template.smsaddphone.events
	'click .save_new_card': ->
		$('#addcardform').data('bootstrapValidator').validate()
		if $('#addcardform').data('bootstrapValidator').isValid()
			exp = $('#exp').val().split('/')
			Stripe.card.createToken {
				number: $('#card').val()
				exp_month: exp[0]
				exp_year: exp[1]
				cvc: $('#cvc').val()
			}, (status, response) ->
				#STORE THE NEWLY TOKENIZED CARD TO THE ACCOUNT
				if !response.error
					Meteor.call 'STRIPE_store_card', response.id, Meteor.userId(), (error, result) ->
						if error
							bootbox.alert error
						return
				else
					bootbox.alert response.error.message

Template.addSMSCardForm.rendered = ->
	$('#addcardform').bootstrapValidator
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