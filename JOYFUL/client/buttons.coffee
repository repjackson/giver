Template.add_button.events
    'click .add': ->
        Docs.insert
            type: @type



Template.add_type_button.events
    'click .add': ->
        new_id = Docs.insert type: @type
        Router.go "/edit/#{new_id}"

Template.view_user_button.events
    'click .view_user': ->
        Router.go "/u/#{username}"


Template.view_button.events
    'click .view': ->
        Router.go "/view/#{@_id}"




