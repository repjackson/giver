Template.userGifts.onRendered ->
  $('#userGiftsReportDatatable').dataTable
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
Template.userGifts.helpers
  'newDate': ->
    moment.unix(@date).format 'MM/DD/YYYY, h:mm a'
  'newAmount': ->
    numeral(@amount / 100).format '$0,0.00'
  tithes: ->
    Tithes.find().fetch()
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
