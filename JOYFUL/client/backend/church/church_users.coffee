Template.churchUsers.helpers associatedUserList: ->
  if Meteor.user() and Meteor.user().emails
    userList = []
    Meteor.user().emails.forEach (d, i) ->
      if d.role == 'churchUser'
        d['index'] = i
        userList.push d
    return userList


Template.churchUsers.events
  'submit .addEditChurchUser': (e, t) ->
    e.preventDefault()
    emailId = $('.emailID').val()
    index = $('.emailID').attr('data-index')
    oldEmailId = $('.emailID').attr('data-oldEmailId')
    Meteor.call 'checkChurchUserExist', emailId, (err, res) ->
      if res.statusCode
        Meteor.call 'addeditChurchUser', emailId, index, oldEmailId, (err, res) ->
          if res
            $('.emailID').val ''
            $('.emailID').attr 'data-index', -1
            $('.emailID').attr 'data-oldEmailId', ''
            alert 'Organization user added successfully'
          else
            alert err.reason
      else
        alert 'This user is already registered'

  'click .btnEdit': (e, t) ->
    form = $('.addEditChurchUser')
    self = this
    $('.addEditChurchUser').find('.emailID').val self.address
    $('.addEditChurchUser').find('.emailID').attr 'data-index', self.index
    $('.addEditChurchUser').find('.emailID').attr 'data-oldEmailId', self.address

  'click .btnDelete': (e, t) ->
    self = this
    Meteor.call 'deleteChurchUser', self, (err, res) ->
      if res
        alert 'Organization user removed successfully'
      else
        alert err.reason