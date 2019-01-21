profilePicImage = '/icons/Logo_sm_100.png'
Template.church_account.helpers 'SETTINGS': ->
    Session.get 'SETTINGS'
Template.church_account.events
    'click #removeStripe': ->
        bootbox.confirm 'Are you sure you want to disconnect stripe? This will disable payment processing entirely.', (result) ->
            if result
                Meteor.call 'remove_stripe', Meteor.userId()

    'click #dashboardStripe': ->
        window.open encodeURI('https://dashboard.stripe.com/dashboard'), '_system'


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

    'click .update_account': (event, template) ->
        showLoadingMask()
        address = encodeURIComponent($('#address').val() + ',' + $('#city').val() + ',' + $('#state').val() + ' ' + $('#zip').val())
        geoURL = 'https://maps.googleapis.com/maps/api/geocode/json?address=' + address + '&key=' + Session.get('SETTINGS').mapsApiKey
        mydata =
            'link': geoURL
            'usr': Meteor.userId()
        coord = undefined
        Meteor.call 'getGeoLoc', mydata, (err, data) ->
            if err
                hideLoadingMask()
                alert err.reason
            else
                coord = data
                #console.log(coord);
                dataJson =
                    'profile.churchName': $('#name').val()
                    'profile.phone': $('#phone').val()
                    'profile.address':
                        street: $('#address').val()
                        city: $('#city').val()
                        state: $('#state').val()
                        zip: $('#zip').val()
                    'profile.website': $('#website').val()
                    'profile.loc':
                        'type': 'Point'
                        'coordinates': coord
                    'profile.profilePic': if profilePicImage == '/icons/Logo_sm_100.png' then '/icons/Logo_sm_100.png' else profilePicImage
                Meteor.call 'updateChurchDetail', dataJson, (err, res) ->
                    hideLoadingMask()
                    if err
                        alert err.reason
                    else
                        alert 'Account Details Updated'

    'click .update_user': (event, template) ->
        Meteor.call 'checkChurchUserExist', $('#email').val(), (err, res) ->
            if res.statusCode
                emailsObj = Meteor.user().emails
                loggedinEmailId = readCookie('loggedinEmailId')
                indexofEmailID = -1
                emailsObj.forEach (d, i) ->
                    if d.address == loggedinEmailId
                        indexofEmailID = i
                    return
                Meteor.call 'addeditChurchUser', $('#email').val(), indexofEmailID, loggedinEmailId, (err, res) ->
                    alert 'Representative Info Updated'
                    Meteor.logout()
                    return
            else
                alert 'This email id already registered.'

Template.churchRepAccountEditor.helpers
    loggedinUserIDDet: (emailAddresses) ->
        loggedinEmailId = readCookie('loggedinEmailId')
        filteredEmail = emailAddresses.filter((d, i) ->
            d.address == loggedinEmailId
        )
        if filteredEmail.length > 0
            return filteredEmail[0].address

Template.churchRepAccountEditor.onRendered ->
    # $('#userInfo').bootstrapValidator
    #     message: 'This value is not valid'
    #     feedbackIcons:
    #         valid: 'glyphicon glyphicon-ok'
    #         invalid: 'glyphicon glyphicon-remove'
    #         validating: 'glyphicon glyphicon-refresh'
    #     fields:
    #         firstname:
    #             message: 'You must provide an account holder firstname.'
    #             validators: notEmpty: message: 'First Name is mandatory'
    #         lastname:
    #             message: 'You must provide an account holder lastname.'
    #             validators: notEmpty: message: 'Last Name is mandatory'
    #         email:
    #             message: 'You must provide an email.'
    #             validators:
    #                 notEmpty: message: 'Email is mandatory'
    #                 emailAddress: message: 'The value is not a valid email address'


Template.church_account_editor.onRendered ->
    # message: 'This value is not valid'
    # feedbackIcons:
    #     valid: 'glyphicon glyphicon-ok'
    #     invalid: 'glyphicon glyphicon-remove'
    #     validating: 'glyphicon glyphicon-refresh'
    # fields:
    #     name:
    #         message: 'You must provide a organization name.'
    #         validators: notEmpty: message: 'Organization Name is mandatory'
    #     address:
    #         message: 'You must provide a organization address.'
    #         validators: notEmpty: message: 'Organization address is mandatory'
    #     city:
    #         message: 'You must provide a city.'
    #         validators: notEmpty: message: 'City is mandatory'
    #     state:
    #         message: 'You must provide a State.'
    #         validators: notEmpty: message: 'State is mandatory'
    #     zip:
    #         message: 'You must provide a Zip Code.'
    #         validators:
    #             notEmpty: message: 'Zip Code is mandatory'
    #             zipCode:
    #                 country: 'US'
    #                 message: 'The value is not valid US zip code'
    #     phone:
    #         message: 'You must provide a phone number.'
    #         validators:
    #             notEmpty: message: 'Phone Number is mandatory'
    #             phone:
    #                 country: 'US'
    #                 message: 'The value is not valid US phone number'