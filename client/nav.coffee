Template.topnav.events
  'click .hide-menu': (event) ->
        event.preventDefault()
        if $(window).width() < 769
            $('body').toggleClass 'show-sidebar'
        else
            $('body').toggleClass 'hide-sidebar'

  'click .right-sidebar-toggle': (event) ->
        event.preventDefault()
        $('#right-sidebar').toggleClass 'sidebar-open'


  'click .logout': ->
        Session.set 'logging_out', true
        Meteor.logout ->
            Session.set 'logging_out', false

Template.topnav.helpers
    logging_out: -> Session.get 'logging_out'

Template.topnav.events
    'click #requestDemobtn': (e, t) ->
        data = {}
        data['firstName'] = $('#firstName').val()
        data['lastName'] = $('#lastName').val()
        data['emailId'] = $('#emailId').val()
        data['phoneNo'] = $('#phoneNo').val()
        data['date'] = moment($('#demoDate').val())._d
        Meteor.call 'requestForDemo', data, (err, res) ->
            if err
                alert err.reason, ''
            else
                alert 'Your request for demo submitted successfully.', ''
                $('#firstName').val ''
                $('#lastName').val ''
                $('#emailId').val ''
                $('#phoneNo').val ''
                $('#requestDemo').modal 'hide'

    'click .feedbackSubmit': (e, t) ->
        e.preventDefault()
        JsonObject =
            experience: $('#radio_experience:checked').val()
            comments: $('#comments').val()
            name: $('#feedBack_name').val()
            email: $('#feedBack_email').val()
        if !JsonObject.experience
            alert 'Please select your experinece', ''
            return false
        if !JsonObject.comments
            alert 'Please enter comments', ''
            return false
        if !JsonObject.name
            alert 'Please enter your name', ''
            return false
        if !JsonObject.email
            alert 'Please enter your email id', ''
            return false
        Meteor.call 'sendFeedbackToAdmin', JsonObject, (err, res) ->
            alert 'Thank you for submitting your feedback.'
            $('#radio_experience').val 'checked', false
            $('#comments').val ''
            $('#feedBack_name').val ''
            $('#feedBack_email').val ''
            $('#feedbackForm').modal 'toggle'

Template.topnav.onRendered ->
    Meteor.setTimeout ->
        $('.item').popup()
    , 1000

    # $('.datetimepicker').datetimepicker minDate: new Date