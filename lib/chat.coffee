Router.route '/chats', -> @render 'chats'
Router.route '/chat/:id/edit', -> @render 'chat_edit'
Router.route '/chat/:id/view', -> @render 'chat_view'


if Meteor.isClient
    @selected_tags = new ReactiveArray []
    @selected_usernames = new ReactiveArray []
    @selected_status = new ReactiveArray []

    Template.chats.events
        'click .add_chat': ->
            new_chat_id = Docs.insert type:'chat'
            Router.go "/chat/#{new_chat_id}/edit"



    Template.chat_view.onCreated ->
        @autorun -> Meteor.subscribe 'children', Router.current().params.id

    Template.chat_view.helpers
        messages: ->
            Docs.find
                type:'message'
                parent_id: Router.current().params.id



    Template.chats.helpers
        chats: ->
            Docs.find
                type:'chat'


        selected_tags: -> selected_tags.list()

        global_tags: ->
            doccount = Docs.find().count()
            if 0 < doccount < 3 then Tags.find { count: $lt: doccount } else Tags.find()

        single_doc: ->
            count = Docs.find({}).count()
            if count is 1 then true else false

        global_usernames: -> Usernames.find()
        selected_usernames: -> selected_usernames.list()

    Template.chats.onCreated ->
        @autorun -> Meteor.subscribe('tags', selected_tags.array(), selected_usernames.array(), 'chat')
        @autorun -> Meteor.subscribe('docs', selected_tags.array(), selected_usernames.array(), 'chat')

    Template.chats.events
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


    Template.chat_edit.onCreated ->
        @autorun -> Meteor.subscribe 'doc', Router.current().params.id



    Template.chat_view.onCreated ->
        @autorun -> Meteor.subscribe 'doc', Router.current().params.id
        @autorun -> Meteor.subscribe 'all_users'

    Template.chat_view.events
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



    Template.chat_edit.events
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

        'click .delete_chat': ->
            if confirm 'Confirm delete chat'
                Docs.remove @_id
                Router.go '/chats'