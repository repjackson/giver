Router.route '/schemas', -> @render 'schemas'
Router.route '/schema/:id/edit', -> @render 'schema_edit'
Router.route '/schema/:id/view', -> @render 'schema_view'


if Meteor.isClient
    @selected_tags = new ReactiveArray []
    @selected_usernames = new ReactiveArray []
    @selected_status = new ReactiveArray []

    Template.schemas.onCreated ->
        @autorun -> Meteor.subscribe('tags', selected_tags.array(), selected_usernames.array(), 'schema')
        @autorun -> Meteor.subscribe('docs', selected_tags.array(), selected_usernames.array(), 'schema')
    Template.schemas.events
        'click .add_schema': ->
            new_schema_id = Docs.insert type:'schema'
            Router.go "/schema/#{new_schema_id}/edit"

    Template.schemas.helpers
        schemas: ->
            Docs.find
                type:'schema'
        selected_tags: -> selected_tags.list()

        global_tags: ->
            doccount = Docs.find().count()
            if 0 < doccount < 3 then Tags.find { count: $lt: doccount } else Tags.find()

        single_doc: ->
            count = Docs.find({}).count()
            if count is 1 then true else false

        global_usernames: -> Usernames.find()
        selected_usernames: -> selected_usernames.list()


    Template.schemas.events
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


    Template.schema_edit.onCreated ->
        @autorun -> Meteor.subscribe 'doc', Router.current().params.id



    Template.schema_view.onCreated ->
        @autorun -> Meteor.subscribe 'doc', Router.current().params.id

    Template.schema_edit.events
        'blur .title': (e,t)->
            title = t.$('.title').val()
            console.log title
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

        'click .toggle_complete': (e,t)->
            Docs.update Router.current().params.id,
                $set:complete:!@complete


        'click .delete_schema': ->
            if confirm 'Confirm delete schema'
                Docs.remove @_id
                Router.go '/schemas'