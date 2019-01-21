Template.makeAdmin.events
  'click #makeAdmin': ->
    pw = $('#password').val()
    code = $('#code').val()
    Meteor.call 'makeAdmin', pw, code, Meteor.userId(), (error, result) ->
      console.log result
      if result.error
        console.log result.error
        $('#loginError').html('<p>' + result.error + '</p>').fadeIn()
      else
        console.log result
        Router.go '/admin/dashboard'