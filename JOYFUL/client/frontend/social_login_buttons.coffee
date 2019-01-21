Template.social_login_buttons.events
    'click #facebook-login': (e) ->
        e.preventDefault()
        Meteor.loginWithFacebook { requestPermissions: [
            'public_profile'
            'email'
        ] }, (e) ->
            if e
                alert e.message
            if Meteor.userId() and Meteor.user().profile.isActive
                # Meteor.call('STRIPE_create_customer',Meteor.userId(),'email', function(e,d){
                # 			Router.go('/user/dashboard')
                # 			var username = Meteor.user() && Meteor.user().emails[0].address ? Meteor.user().emails[0].address : "";
                # 			document.cookie = "loggedinEmailId="+username;
                # });
                if Meteor.user().roles
                    Router.go 'dashboard'
                    username = if Meteor.user() and Meteor.user().emails[0].address then Meteor.user().emails[0].address else ''
                    document.cookie = 'loggedinEmailId=' + username
                else
                    Router.go '/select-role'
            else
                document.cookie = 'loggedinEmailId=; expires=' + new Date + ';'
                Meteor.logout()
                alert 'Your account suspended please contact Joyful Giver admin on info@joyful-giver.com'

    'click #google-login': (e) ->
        e.preventDefault()
        Meteor.loginWithGoogle {}, (e) ->
            if e
                alert e.message
            if Meteor.userId() and Meteor.user().profile.isActive
                # Meteor.call('STRIPE_create_customer',Meteor.userId(),'email', function(e,d){
                # 			Router.go('/user/dashboard')
                # 			var username = Meteor.user() && Meteor.user().emails[0].address ? Meteor.user().emails[0].address : "";
                # 			document.cookie = "loggedinEmailId="+username;
                # });
                if Meteor.user().roles
                    Router.go 'dashboard'
                    username = if Meteor.user() and Meteor.user().emails[0].address then Meteor.user().emails[0].address else ''
                    document.cookie = 'loggedinEmailId=' + username
                else
                    Router.go '/select-role'
            else
                document.cookie = 'loggedinEmailId=; expires=' + new Date + ';'
                Meteor.logout()
                alert 'Your account suspended please contact Joyful Giver admin on info@joyful-giver.com'