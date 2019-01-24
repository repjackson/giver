Template.login.events
    'submit #login': (e, t) ->
        username = e.target.username.value.toLowerCase()
        password = e.target.password.value
        Meteor.loginWithPassword username, password, (err) ->
            if err
                #  hideLoadingMask();
                e.target.username.value = username
                e.target.password.value = password
                alert err.reason
            else
                if Meteor.user() and Meteor.user().profile.isActive
                    if Meteor.user().roles
                        document.cookie = 'loggedinEmailId=' + username
                        Router.go '/dashboard'
                    else
                        Router.go '/select-role'
                else
                    document.cookie = 'loggedinEmailId=; expires=' + new Date + ';'
                    Meteor.logout()
                    alert 'Your account suspended please contact Joyful Giver admin on info@joyful-giver.com'
        false



Template.login.helpers
    enter_class: ->
        if Meteor.loggingIn() then 'loading disabled' else ''

    login_class: ->
        if Meteor.loggingIn() then 'disabled' else ''




Template.login.onRendered ->
    $('body').addClass 'landing-page'
    Meta.setTitle 'Log In - Joyful Giver'
    Meta.set 'og:title', 'Log In - Joyful Giver'



Template.forgot_password.onRendered ->
    $('body').addClass 'landing-page'
    Meta.setTitle 'Forgot Password - Joyful Giver'
    Meta.set 'og:title', 'Forgot Password - Joyful Giver'

Template.forgot_password.events 'submit #forgot_passwordForm': (e, t) ->
    e.preventDefault()
    username = e.target.username.value.toLowerCase()
    Meteor.call 'checkChurchUser', username, (err, res) ->
        if res.statusCode
            Accounts.forgot_password { email: username }, (error) ->
                if error
                    e.target.username.value = username
                    # FlashMessages.sendError(err.reason);
                    alert error.reason
                else
                    # FlashMessages.sendSuccess('Check your email and click the reset password link.');
                    alert 'Check your email and click the reset password link.'
                return
        else
            alert res.msg



Template.reset_password.onRendered ->
	$('body').addClass 'landing-page'

Template.reset_password.onCreated ->
	if Accounts._reset_passwordToken
		Session.set 'reset_password', Accounts._reset_passwordToken

Template.reset_password.helpers
		reset_password: ->
			Session.get 'reset_password'

Template.reset_password.events
	'submit #reset_passwordForm': (e, t) ->
		e.preventDefault()
		reset_passwordForm = $(e.currentTarget)
		password = reset_passwordForm.find('#reset_passwordPassword').val()
		passwordConfirm = reset_passwordForm.find('#reset_passwordPasswordConfirm').val()
		if password and password == passwordConfirm
			Accounts.reset_password Session.get('reset_password'), password, (err) ->
				if err
					FlashMessages.sendError err.reason
					console.log 'We are sorry but something went wrong.'
				else
					FlashMessages.sendSuccess 'Your password has been changed. Welcome back!'
					console.log 'Your password has been changed. Welcome back!'
					Session.set 'reset_password', null
					Router.go '/'
				return
		else
			FlashMessages.sendError 'Both Passwords are not match.'
		false
	'click .gotologin': (e, t) ->
		Router.go 'UserLogin'

Template.forgot_password.onRendered ->
    $('body').addClass 'landing-page'
    Meta.setTitle 'Forgot Password - Joyful Giver'
    Meta.set 'og:title', 'Forgot Password - Joyful Giver'

Template.forgot_password.events 'submit #forgot_passwordForm': (e, t) ->
    e.preventDefault()
    username = e.target.username.value.toLowerCase()
    Meteor.call 'checkChurchUser', username, (err, res) ->
        if res.statusCode
            Accounts.forgot_password { email: username }, (error) ->
                if error
                    e.target.username.value = username
                    # FlashMessages.sendError(err.reason);
                    alert error.reason
                else
                    # FlashMessages.sendSuccess('Check your email and click the reset password link.');
                    alert 'Check your email and click the reset password link.'
                return
        else
            alert res.msg



Template.select_role.events
    'click .roleSelect': (e, t) ->
        role = $(e.currentTarget).attr('data-role')
        if confirm "Confirm select role #{role}"
            Meteor.call 'select_role', role, (err, data) ->
                alert 'You are logged in', ''
                Router.go '/dashboard'