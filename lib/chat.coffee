Router.route '/inbox', -> @render 'inbox'
Router.route '/message/:id/edit', -> @render 'message_edit'
Router.route '/message/:id/view', -> @render 'message_view'


if Meteor.isClient
    @selected_tags = new ReactiveArray []
    @selected_usernames = new ReactiveArray []
    @selected_status = new ReactiveArray []

    Template.inbox.events
        'click .add_message': ->
            new_message_id = Docs.insert type:'message'
            Router.go "/message/#{new_message_id}/edit"



    Template.message_view.onCreated ->
        @autorun -> Meteor.subscribe 'children', Router.current().params.id

    Template.message_view.helpers
        messages: ->
            Docs.find
                type:'message'
                parent_id: Router.current().params.id



    Template.inbox.helpers
        inbox: ->
            Docs.find
                type:'message'


        selected_tags: -> selected_tags.list()

        global_tags: ->
            doccount = Docs.find().count()
            if 0 < doccount < 3 then Tags.find { count: $lt: doccount } else Tags.find()

        single_doc: ->
            count = Docs.find({}).count()
            if count is 1 then true else false

        global_usernames: -> Usernames.find()
        selected_usernames: -> selected_usernames.list()

    Template.inbox.onCreated ->
        @autorun -> Meteor.subscribe('tags', selected_tags.array(), selected_usernames.array(), 'message')
        @autorun -> Meteor.subscribe('docs', selected_tags.array(), selected_usernames.array(), 'message')

    Template.inbox.events
        'click .select_tag': -> selected_tags.push @name
        'click .unselect_tag': -> selected_tags.remove @valueOf()
        'click #clear_tags': -> selected_tags.clear()
        'keyup #search': (e)->
            switch e.which
                when 13
                    if e.target.value is 'clear'
                        selected_tags.clear()
                        $('#search').val('')
                    else
                        selected_tags.push e.target.value.toLowerCase().trim()
                        $('#search').val('')
                when 8
                    if e.target.value is ''
                        selected_tags.pop()


    Template.message_edit.onCreated ->
        @autorun -> Meteor.subscribe 'doc', Router.current().params.id



    Template.message_view.onCreated ->
        @autorun -> Meteor.subscribe 'doc', Router.current().params.id

    Template.message_view.events
        'keyup .add_message': (e,t)->
            if e.which is 13
                parent = Docs.findOne Router.current().params.id
                message = t.$('.add_message').val()
                Docs.insert
                    parent_id: parent._id
                    type:'message'
                    body:message
                t.$('.add_message').val('')

        'click .remove_message': ->
            if confirm 'Confirm remove message'
                Docs.remove @_id



    Template.message_edit.events
        'blur .title': (e,t)->
            title = t.$('.title').val()
            Docs.update Router.current().params.id,
                $set:title:title

        'blur .body': (e,t)->
            body = t.$('.body').val()
            Docs.update Router.current().params.id,
                $set:body:body

        'keyup .new_tag': (e,t)->
            if e.which is 13
                tag = t.$('.new_tag').val().trim()
                Docs.update Router.current().params.id,
                    $addToSet:tags:tag
                t.$('.new_tag').val('')

        'click .remove_tag': (e,t)->
            tag = @valueOf()
            Docs.update Router.current().params.id,
                $pull:tags:tag
            t.$('.new_tag').val(tag)

        'click .delete_message': ->
            if confirm 'Confirm delete message'
                Docs.remove @_id
                Router.go '/inbox'