Template.churchCustomPage.events
  'change #header_photo': (event, template) ->
    #  $('.imageprocessing').show();
    showLoadingMask()
    $('.image').hide()
    template.data.uploader.send document.getElementById('header_photo').files[0], (error, downloadUrl) ->
      if error
        hideLoadingMask()
        alert error.reason
      else
        hideLoadingMask()
        $('.image').show()
        Meteor.call 'updateHeaderImage', template.data.code._id, downloadUrl
      return
    return
  'change #campaign_name': (event, template) ->
    name = $('#campaign_name').val()
    Meteor.call 'updateCampaignName', template.data.code._id, name
    return
  'change #campaign_Goal_Donation': (event, template) ->
    Goal_Donation = parseInt($('#campaign_Goal_Donation').val())
    Meteor.call 'updateGoal_Donation', template.data.code._id, Goal_Donation
    return
  'change #campaign_code': (event, template) ->
    code = $('#campaign_code').val()
    Meteor.call 'updateCampaignCode', template.data.code._id, code.toUpperCase(), (err) ->
      if err
        alert err.reason
      return
    return

Template.churchCustomPage.onRendered ->
  data = @data
  $('#summernote').summernote
    height: 300
    onChange: (contents, $editable) ->
      id = $('#summernote').attr('name')
      Meteor.call 'updateDescription', id, contents