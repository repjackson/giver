Template.auto_mail.onRendered ->
  Session.set 'attachmentFile', []
  $('.summernote').summernote()
  $('.emailList').select2
    tags: true
    createTag: (params) ->
      # Don't offset to create a tag if there is no @ symbol
      regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/
      if !regex.test(params.term)
        # Return null to disable tag creation
        return null
      {
        id: params.term
        text: params.term
      }

Template.auto_mail.helpers
  attachments: ->
    Session.get 'attachmentFile'
  fileTypeIcon: (type) ->
    fileType = type.split('/')[0]
    if fileType == 'text' or fileType == 'application'
      return 'fa-file'
    else if fileType == 'image'
      return 'fa-file-image-o'
    else if fileType == 'audio'
      return 'fa-file-audio-o'
    else if fileType == 'video'
      return 'fa-file-video-o'

Template.auto_mail.events
  'click .bulkMailSend': (e, t) ->
    showLoadingMask()
    self = this
    emailList = $('.emailList').val()
    subject = $('.mailSub').val()
    mail = $('.summernote').code()
    # var attachment = document.getElementById('fileInput').files[0]
    if emailList.length == 0
      hideLoadingMask()
      alert 'Please enter at least one email address'
      return false
    if mail.length == 0
      hideLoadingMask()
      alert 'You can not send blank mail to users.'
      return false
    if emailList.indexOf('all') > -1
      emailList.splice emailList.indexOf('all'), 1
      emailList.splice emailList.indexOf('users'), 1
      emailList.splice emailList.indexOf('org'), 1
      emailList = emailList.concat(self.orgEmailList)
      emailList = emailList.concat(self.userEmailList)
    else
      if emailList.indexOf('users') > -1
        emailList.splice emailList.indexOf('users'), 1
        emailList = emailList.concat(self.userEmailList)
      if emailList.indexOf('org') > -1
        emailList.splice emailList.indexOf('org'), 1
        emailList = emailList.concat(self.orgEmailList)
    emailObj =
      to: emailList
      subject: subject
      html: mail
      attachments: Session.get('attachmentFile')
    Meteor.call 'bulkMailSendMethod', emailObj, (err, res) ->
      hideLoadingMask()
      if res
        alert 'Bulk Email send successfully.'

  'change #fileInput': (e, t) ->
    attachmentFileArray = Session.get('attachmentFile') or []
    attachmentFile = {}
    file = document.getElementById('fileInput').files[0]
    reader = new FileReader
    reader.onload = (->
      (e) ->
        attachmentFile['path'] = e.target.result
        attachmentFile['filename'] = file.name
        attachmentFile['contentType'] = file.type
        attachmentFileArray.push attachmentFile
        Session.set 'attachmentFile', attachmentFileArray
        return
    )(file)
    reader.readAsDataURL file

  'click .closebox': (e, t) ->
    index = $(e.currentTarget).attr('data-index')
    attachmentFileArray = Session.get('attachmentFile')
    attachmentFileArray.splice index, 1
    Session.set 'attachmentFile', attachmentFileArray