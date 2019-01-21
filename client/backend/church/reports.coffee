Template.churchReports.onRendered ->
  Session.set 'tithesList', []
  Session.set 'SearchCriteria', {}
  $('#datepicker').datepicker autoclose: true
  $('.select2').select2()
  Tracker.autorun ->
    listData = Tithes.find(Session.get('SearchCriteria'), sort: 'date': 1).fetch()
    Session.set 'tithesList', listData
    $('#churchReportDatatable').DataTable().destroy()
    if listData.length > 0
      usefulTitheData = []
      listData.forEach (d, i) ->
        usefulTitheDataJson = {}
        usefulTitheDataJson['userID'] = d.userID
        usefulTitheDataJson['amount'] = d.amount
        usefulTitheDataJson['date'] = moment.unix(d.date).format('YYYY-MM-DD')
        usefulTitheData.push usefulTitheDataJson
        return
      UniqueNames = $.unique(usefulTitheData.map((d) ->
        d.userID
      ))
      UniquedDates = $.unique(usefulTitheData.map((d) ->
        moment(d.date, 'YYYY-MM-DD').format 'YYYY-MM-DD'
      ))
      finalArray = []
      UniquedDates.splice 0, 0, 'x'
      finalArray.push UniquedDates
      UniqueNames.forEach (d, i) ->
        usernameArray = []
        user = Meteor.users.findOne(_id: d)
        try
          if user.profile.name
            usernameArray.push user.profile.name
          else
            usernameArray.push user.profile.firstname + ' ' + user.profile.lastname
        catch err
          usernameArray.push 'Anonymous'
        UniquedDates.forEach (dd, ii) ->
          if ii != 0
            filteredData = usefulTitheData.filter((j, k) ->
              j.date == dd and j.userID == d
            )
            total = 0
            filteredData.forEach (a, b) ->
              total = +total + +a.amount
              return
            usernameArray.push numeral(total / 100).format(0)
          return
        finalArray.push usernameArray
        return
      c3.generate
        bindto: '#lineChart'
        data:
          x: 'x'
          columns: finalArray
        axis: x:
          type: 'timeseries'
          tick: format: (x) ->
            moment(x).format 'MMM, DD YYYY'
      setTimeout ->
        $('#churchReportDatatable').dataTable
          dom: '<\'row\'<\'col-sm-4\'l><\'col-sm-4 text-center\'B><\'col-sm-4\'f>>tp'
          destroy: true
          'lengthMenu': [
            [
              10
              25
              50
              -1
            ]
            [
              10
              25
              50
              'All'
            ]
          ]
          buttons: [
            {
              extend: 'copy'
              className: 'btn-sm'
              exportOptions: columns: [
                0
                1
                2
                3
              ]
            }
            {
              extend: 'csv'
              title: 'ExampleFile'
              className: 'btn-sm'
              exportOptions: columns: [
                0
                1
                2
                3
              ]
            }
            {
              extend: 'pdf'
              title: 'ExampleFile'
              className: 'btn-sm'
              exportOptions: columns: [
                0
                1
                2
                3
              ]
            }
            {
              extend: 'print'
              className: 'btn-sm'
              exportOptions: columns: [
                0
                1
                2
                3
              ]
            }
          ]
        return
    return
  return
Template.churchReports.helpers
  giverList: ->
    giverList = []
    userList = Meteor.users.find(_id: $ne: Meteor.userId()).fetch()
    if userList.length > 0
      userList.forEach (d, i) ->
        userjson = {}
        if d.profile.name
          userjson['_id'] = d._id
          userjson['text'] = d.profile.name
          giverList.push userjson
        else
          userjson['_id'] = d._id
          userjson['text'] = d.profile.firstname + ' ' + d.profile.lastname
          giverList.push userjson
        return
      giverList
    else
      []
  giveCodeList: ->
    giveCodeList = []
    churchCodesList = ChurchCodes.find(church: Meteor.userId()).fetch()
    #console.log(churchCodesList);
    if churchCodesList.length > 0
      churchCodesList.forEach (d, i) ->
        userjson = {}
        userjson['_id'] = d._id
        userjson['text'] = d.code
        giveCodeList.push userjson
        return
      giveCodeList
    else
      []
  'newDate': ->
    moment.unix(@date).format 'MM/DD/YYYY, h:mm a'
  'newAmount': ->
    numeral(@amount / 100).format '$0,0.00'
  tithes: ->
    Session.get 'tithesList'
  userName: ->
    #console.log(this);
    user = Meteor.users.findOne(_id: @userID)
    try
      if user.profile.name
        return user.profile.name
      else
        return user.profile.firstname + ' ' + user.profile.lastname
    catch err
      return 'Anonymous'
    return
Template.churchReports.events
  'submit #filterChurchReports': (e, t) ->
    e.preventDefault()
    searchCriteria = {}
    donorCode = $('#donorCode').val()
    giveCode = $('#giveCode').val()
    from = $('[name="start"]').val()
    to = $('[name="end"]').val()
    searchCriteria['church'] = Meteor.userId()
    if donorCode != '-1'
      searchCriteria['userID'] = donorCode
    if giveCode != '-1'
      searchCriteria['churchCODE'] = giveCode
    if from and to
      unixFromts = moment(from + ' 00:00', 'MM/DD/YYYY HH:mm').unix().toString()
      unixFrom = moment.unix(unixFromts)
      unixTots = moment(to + ' 00:00', 'MM/DD/YYYY HH:mm').unix().toString()
      unixTo = moment.unix(unixTots)
      searchCriteria['date'] =
        $gte: unixFromts
        $lte: unixTots
    Session.set 'SearchCriteria', searchCriteria
    return
  'click #resetFilter': (e, t) ->
    e.preventDefault()
    $('#donorCode').val('-1').change()
    $('#giveCode').val('-1').change()
    $('[name="start"]').val ''
    $('[name="end"]').val ''
    Session.set 'SearchCriteria', {}
    return

# ---
# generated by js2coffee 2.2.0