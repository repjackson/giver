Template.user_profile.helpers
  userDet: ->
    Meteor.users.findOne '_id': Router.current().params._id
  'titheTotalGive': ->
    tithesList = Tithes.find({}).fetch()
    totalGive = 0
    tithesList.forEach (d, i) ->
      totalGive += d.amount
      return
    if totalGive
      totalGive = totalGive / 100
    parseInt totalGive
  'TotalDonation': ->
    tithesList = Tithes.find({}).fetch()
    if tithesList then tithesList.length else 0
  'codeDetail': ->
    tithesList = Tithes.find({}, sort: 'date': -1).fetch()
    codeDetail = []
    tithesList.forEach (d, i) ->
      churchCodeDet = {}
      if d.churchCODE
        churchCodeDet = ChurchCodes.findOne('code': d.churchCODE)
      else
        churchDet = Meteor.users.findOne('_id': d.church)
        churchCodeDet['campaign'] = churchDet.profile.churchName
        churchCodeDet['customPage.header_image'] = churchDet.profile.profilePic
        churchCodeDet['code'] = 'churchDetail/' + churchDet._id
      churchCodeDet['date'] = moment(d.date, 'X').fromNow()
      churchCodeDet['giveAmount'] = d.amount / 100
      codeDetail.push churchCodeDet
      return
    codeDetail
