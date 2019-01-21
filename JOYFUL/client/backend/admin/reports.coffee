Template.adminReports.helpers
  'total': ->
    amt = Tithes.find({}).sum('amount')
    numeral(amt / 100).format '$0,0'
  giverList: ->
    giverList = []
    userList = Meteor.users.find(roles: 'user').fetch()
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
    churchCodesList = ChurchCodes.find({}).fetch()
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
    user = Meteor.users.findOne(_id: @userID)
    try
      if user.profile.name
        return user.profile.name
      else
        return user.profile.firstname + ' ' + user.profile.lastname
    catch err
      return 'Anonymous'
    return
  churchName: ->
    user = Meteor.users.findOne(_id: @church)
    try
      if user.profile.churchName
        return user.profile.churchName
      else if user.profile.name
        return user.profile.name
      else
        return user.profile.firstname + ' ' + user.profile.lastname
    catch err
      return 'Anonymous'
    return
  churchList: ->
    churchList = []
    userList = Meteor.users.find(roles: 'church').fetch()
    if userList.length > 0
      userList.forEach (d, i) ->
        userjson = {}
        if d.profile.churchName
          userjson['_id'] = d._id
          userjson['text'] = d.profile.churchName
          churchList.push userjson
        else if user.profile.name
          userjson['_id'] = d._id
          userjson['text'] = d.profile.name
          churchList.push userjson
        else
          userjson['_id'] = d._id
          userjson['text'] = d.profile.firstname + ' ' + d.profile.lastname
          churchList.push userjson
        return
      churchList
    else
      []
Template.adminReports.onRendered ->
  Session.set 'tithesList', []
  Session.set 'SearchCriteria', {}
  $('#datepicker').datepicker autoclose: true
  $('.select2').select2()
  Tracker.autorun ->
    listData = Tithes.find(Session.get('SearchCriteria'), sort: 'date': 1).fetch()
    Session.set 'tithesList', listData
    $('#adminReportDatatable').DataTable().destroy()
    if listData.length > 0
      # var usefulTitheData = [];
      # listData.forEach(function(d, i) {
      #     var usefulTitheDataJson = {};
      #     usefulTitheDataJson['userID'] = d.userID;
      #     usefulTitheDataJson['amount'] = d.amount;
      #     usefulTitheDataJson['date'] = moment.unix(d.date).format("YYYY-MM-DD");
      #     usefulTitheData.push(usefulTitheDataJson);
      # });
      # var UniqueNames = $.unique(usefulTitheData.map(function(d) {
      #     return d.userID;
      # }));
      # var UniquedDates = $.unique(usefulTitheData.map(function(d) {
      #     return moment(d.date,"YYYY-MM-DD").format('YYYY-MM-DD');
      # }));
      # var finalArray = [];
      # UniquedDates.splice(0, 0, "x");
      # finalArray.push(UniquedDates);
      # UniqueNames.forEach(function(d, i) {
      #   var usernameArray = [];
      #   var user = Meteor.users.findOne({
      #       _id: d
      #   });
      #   try {
      #        if (user.profile.name) {
      #        usernameArray.push(user.profile.name);
      #        } else {
      #            usernameArray.push(user.profile.firstname + ' ' + user.profile.lastname);
      #        }
      #   } catch (err) {
      #        usernameArray.push("Anonymous");
      #   }
      #     UniquedDates.forEach(function(dd, ii) {
      #         if (ii != 0) {
      #             var filteredData = usefulTitheData.filter(function(j, k) {
      #                 return j.date == dd && j.userID == d;
      #             });
      #             var total = 0;
      #             filteredData.forEach(function(a, b) {
      #                 total = (+total) + (+a.amount);
      #             });
      #             usernameArray.push(numeral(total / 100).format(0));
      #         }
      #     });
      #     finalArray.push(usernameArray);
      # })
      # c3.generate({
      #     bindto: '#lineChart',
      #     data: {
      #         x: 'x',
      #         //        xFormat: '%Y%m%d', // 'xFormat' can be used as custom format of 'x'
      #         columns: finalArray
      #     },
      #     axis: {
      #         x: {
      #             type: 'timeseries',
      #             tick: {
      #                 format: function(x) {
      #                     return moment(x).format('MMM, DD YYYY');
      #                 }
      #             }
      #         }
      #     }
      # });
      setTimeout ->
        $('#adminReportDatatable').dataTable
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
                4
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
                4
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
                4
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
                4
              ]
            }
          ]
        return
    return
  return
Template.adminReports.events
  'submit #filterAdminReports': (e, t) ->
    e.preventDefault()
    searchCriteria = {}
    donorCode = $('#donorCode').val()
    giveCode = $('#giveCode').val()
    from = $('[name="start"]').val()
    to = $('[name="end"]').val()
    churchId = $('#churchId').val()
    if churchId != '-1'
      searchCriteria['church'] = churchId
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
    $('#churchId').val('-1').change()
    $('[name="start"]').val ''
    $('[name="end"]').val ''
    Session.set 'SearchCriteria', {}