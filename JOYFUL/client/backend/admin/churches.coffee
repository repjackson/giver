Template.admin_churches.events
  'click .login': (event, template) ->
    Meteor.call 'loginAs', Meteor.userId(), @_id, (err, data) ->
      if data
        #alert(data)
        Accounts.loginWithImpersonate data, ->
          if Meteor.user()
            document.cookie = 'loggedinEmailId=' + Meteor.user().emails[0].address
          Router.go '/dashboard'
  'click .disable_account': (event, template) ->
    self = this
    bootbox.confirm 'Are you sure! you want disable account?', (result) ->
      if result
        Meteor.call 'enable_disable_account', self._id, 'disable_account', (err, data) ->
          if data
            alert 'Organization account disabled successfully'
  'click .enable_account': (event, template) ->
    self = this
    bootbox.confirm 'Are you sure! you want enable account?', (result) ->
      if result
        Meteor.call 'enable_disable_account', self._id, 'enable_account', (err, data) ->
          if data
            alert 'Organization account enabled successfully'
  'click .disableFees': (event, template) ->
    self = this
    bootbox.confirm 'Are you sure! you want Free to Joyful Giver Fees for this account?', (result) ->
      if result
        Meteor.call 'enableDisableJGFees', self._id, 'disableFees', (err, data) ->
          if data
            alert 'Organization account Free from JG Fees successfully'
  'click .enableFees': (event, template) ->
    self = this
    bootbox.confirm 'Are you sure! you want apply JG Fees for this account?', (result) ->
      if result
        Meteor.call 'enableDisableJGFees', self._id, 'enableFees', (err, data) ->
          if data
            alert 'Organization account JG fees applicable successfully'