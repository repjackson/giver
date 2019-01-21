Meteor.methods
  'generateNewCode': (church_id, campaign) ->
    code = ('0000' + (Math.random() * 36 ** 4 << 0).toString(36)).slice(-4)
    upperCode = code.toUpperCase()
    if !campaign
      campaign = 'General Fund'
    #/If generated code is already used generate another code
    if ChurchCodes.find(code: upperCode).count() > 0
      Meteor.call 'generateNewCode', church_id
    else
      return ChurchCodes.insert(
        church: church_id
        code: upperCode
        campaign: campaign
        isActive: true)

  'removeChurchCode': (id) ->
    console.log 'call hit'
    ActiveInactive = ChurchCodes.findOne(id)
    ChurchCodes.update { _id: id }, $set: isActive: !ActiveInactive.isActive

  'giveVerificationMethod': (titheId) ->
    Tithes.update {
      '_id': titheId
      'church': @userId
    }, $set: 'churchVerified': true

  'addeditChurchUser': (emailId, index, oldEmailId) ->
    if index == -1
      data =
        address: emailId
        verified: true
        role: 'churchUser'
      return Meteor.users.update({ _id: Meteor.userId() }, $push: 'emails': data)
    else
      emailsObj = Meteor.user().emails
      if emailsObj[index].address == oldEmailId
        emailsObj[index].address = emailId
        return Meteor.users.update({ _id: Meteor.userId() }, $set: 'emails': emailsObj)

  'deleteChurchUser': (data) ->
    emailsObj = Meteor.user().emails
    if emailsObj[data.index].address == data.address and emailsObj[data.index].role == data.role
      dataRemove =
        address: data.address
        verified: true
        role: 'churchUser'
      Meteor.users.update { _id: Meteor.userId() }, $pull: 'emails': dataRemove
    else
      'you can not delete this user'
  'updateChurchDetail': (data) ->
    Meteor.users.update Meteor.userId(), $set: data
  'addCustomCode': (id) -> ChurchCodes.update id, $set: custom: true
  'updateCampaignName': (id, name) -> ChurchCodes.update id, $set: 'campaign': name
  'updateGoal_Donation': (id, Goal_Donation) -> ChurchCodes.update id, $set: 'Goal_Donation': Goal_Donation
  'updateDescription': (id, contents) -> ChurchCodes.update id, $set: 'customPage.textContent': contents
  'updateHeaderImage': (id, downloadUrl) -> ChurchCodes.update id, $set: 'customPage.header_image': downloadUrl
  'updateCampaignCode': (id, code) ->
    oldCurchCode = ChurchCodes.findOne('_id': id).code
    isTithesCount = Tithes.findOne('churchCODE': oldCurchCode)
    if isTithesCount
      throw new (Meteor.Error)(500, 'Campaign get tithes so you can not change it now.')
    else
      return ChurchCodes.update(id, $set: 'code': code)
    return