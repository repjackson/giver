Template.user_reports.onRendered ->
  Session.set 'tithesList', []
  Session.set 'SearchCriteria', {}
  # $('#datepicker').datepicker autoclose: true
  # $('.select2').select2()
  Tracker.autorun ->
    listData = Tithes.find(Session.get('SearchCriteria')).fetch()
    Session.set 'tithesList', listData
    $('#giveReportDatatable').DataTable().destroy()
    if listData.length > 0
      usefulTitheData = []
      listData.forEach (d, i) ->
        usefulTitheDataJson = {}
        usefulTitheDataJson['church'] = d.data.description
        usefulTitheDataJson['amount'] = d.amount
        usefulTitheDataJson['date'] = moment.unix(d.date).format('YYYY-MM-DD')
        usefulTitheData.push usefulTitheDataJson
        return
      UniqueNames = $.unique(usefulTitheData.map((d) ->
        d.church
      ))
      UniquedDates = $.unique(usefulTitheData.map((d) ->
        moment(d.date, 'YYYY-MM-DD').format 'YYYY-MM-DD'
      ))
      finalArray = []
      UniquedDates.splice 0, 0, 'x'
      finalArray.push UniquedDates
      UniqueNames.forEach (d, i) ->
        usernameArray = []
        usernameArray.push d

        ###
        var user = Meteor.users.findOne({
            _id: d
        }); console.log(d);
        if (user.profile.name) {
             usernameArray.push(user.profile.name);
        } else {
            usernameArray.push(user.profile.firstname + ' ' + user.profile.lastname);
        }
        ###

        UniquedDates.forEach (dd, ii) ->
          if ii != 0
            filteredData = usefulTitheData.filter((j, k) ->
              j.date == dd and j.church == d
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
        $('#giveReportDatatable').dataTable
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
              ]
            }
            {
              extend: 'print'
              className: 'btn-sm'
              exportOptions: columns: [
                0
                1
                2
              ]
            }
          ]
        return
    return
  return
Template.user_reports.helpers
  churchList: ->
    churchList = []
    userList = Meteor.users.find(_id: $ne: Meteor.userId()).fetch()
    if userList.length > 0
      userList.forEach (d, i) ->
        userjson = {}
        if d.profile.churchName
          userjson['_id'] = d._id
          userjson['text'] = d.profile.churchName
          churchList.push userjson
        else if d.profile.name
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
  'newDate': ->
    moment.unix(@date).format 'MM/DD/YYYY, h:mm a'
  'newAmount': ->
    numeral(@amount / 100).format '$0,0.00'
  tithes: ->
    Session.get 'tithesList'
  userName: ->

    ###
      var user =  Meteor.users.findOne({_id:this.church});
      if(user.profile.name)
      {
        return user.profile.name;
      }
      else {
        return  user.profile.firstname+' '+ user.profile.lastname;
      }
    ###

    @data.description
Template.user_reports.events
  'submit #filterGiveReports': (e, t) ->
    e.preventDefault()
    searchCriteria = {}
    churchId = $('#churchId').val()
    # var giveCode = $('#giveCode').val();
    from = $('[name="start"]').val()
    to = $('[name="end"]').val()
    searchCriteria['userID'] = Meteor.userId()
    if churchId != '-1'
      searchCriteria['church'] = churchId
    # if (giveCode != "-1") {
    #         searchCriteria['churchCODE'] =giveCode;
    #     }
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
    $('#churchId').val('-1').change()
    $('[name="start"]').val ''
    $('[name="end"]').val ''
    Session.set 'SearchCriteria', {}