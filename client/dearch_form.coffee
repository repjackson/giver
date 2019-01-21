Template.searchForm.helpers churchSearch: (query, sync, callback) ->
  Meteor.call 'churchSearch', query, {}, (err, res) ->
    if err
      console.log err
      return
    callback res.map((v) ->
      {
        value: v.profile.churchName
        id: v._id
        address: v.profile.address.street + ' ' + v.profile.address.city + ', ' + v.profile.address.state + ' ' + v.profile.address.zip
      }
    )

Template.searchForm.rendered = ->
  # Creates typeahead for autocompleting search function
  Meteor.typeahead.inject()