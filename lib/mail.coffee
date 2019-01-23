Router.route '/mail', -> @render 'mail'
Router.route '/message/:id/edit', -> @render 'message_edit'
Router.route '/message/:id/view', -> @render 'message_view'


if Meteor.isClient
    Template.mail.onCreated ->
        @autorun -> Meteor.subscribe 'inbox'


    Template.mail.events
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



    Template.mail.helpers
        inbox: ->
            Docs.find
                type:'message'
                to_user_id: Meteor.userId()

    Template.mail.events


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


    Template.message_edit.onCreated ->
        @user_results = new ReactiveVar


    Template.message_edit.helpers
        user_results: ->
            user_results = Template.instance().user_results.get()
            user_results

    Template.message_edit.events
        'blur .body': (e,t)->
            body = t.$('.body').val()
            Docs.update Router.current().params.id,
                $set:body:body


        'click .clear_results': (e,t)->
            t.user_results.set null

        'keyup #multiple_user_select_input': (e,t)->
            search_value = $(e.currentTarget).closest('#multiple_user_select_input').val().trim()
            Meteor.call 'lookup_user', search_value, (err,res)=>
                if err then console.error err
                else
                    t.user_results.set res

        'click .select_user': (e,t) ->
            page_doc = Docs.findOne FlowRouter.getQueryParam('doc_id')
            Meteor.call 'assign_user', page_doc._id, @, (err,res)=>
            $('#multiple_user_select_input').val ''
            t.user_results.set null
            Docs.update page_doc._id,
                $set: assignment_timestamp:Date.now()


        'click .pull_user': ->
            context = Template.currentData(0)
            if confirm "Remove #{@username}?"
                page_doc = Docs.findOne FlowRouter.getQueryParam('doc_id')
                Meteor.call 'unassign_user', page_doc._id, @






        'click .delete_message': ->
            if confirm 'Confirm delete message'
                Docs.remove @_id
                Router.go '/inbox'



if Meteor.isServer
    Meteor.publish 'inbox', ->
        Docs.find
            type:'message'
            to_user_id: Meteor.userId()


    Meteor.methods
        lookup_user: (username_query)->
            found_users =
                Meteor.users.find({
                    username: {$regex:"#{username_query}", $options: 'i'}
                    }).fetch()
            found_users
