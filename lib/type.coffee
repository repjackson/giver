Router.route '/s/:type', -> @render 'type'
Router.route '/s/:type/:id/edit', -> @render 'type_edit'
Router.route '/s/:type/:id/view', -> @render 'type_view'



if Meteor.isClient
    Template.type.onCreated ->
        @autorun -> Meteor.subscribe 'schema', Router.current().params.type
        @autorun -> Meteor.subscribe 'tags', selected_tags.array(), Router.current().params.type
        @autorun -> Meteor.subscribe 'docs', selected_tags.array(), Router.current().params.type


    Template.type.helpers
        schema: ->
            Docs.findOne
                type:'schema'
                slug: Router.current().params.type

        type_docs: ->
            Docs.find
                type:Router.current().params.type

        selected_tags: -> selected_tags.list()

        global_tags: ->
            doc_count = Docs.find().count()
            if 0 < doc_count < 3 then Tags.find { count: $lt: doc_count } else Tags.find()

        single_doc: ->
            count = Docs.find({}).count()
            if count is 1 then true else false



    Template.type.events
        'click .add_type_doc': ->
            new_doc_id = Docs.insert type:Router.current().params.type
            Router.go "/s/#{@type}/#{new_doc_id}/edit"

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


    Template.type_edit.onCreated ->
        @autorun -> Meteor.subscribe 'doc', Router.current().params.id

    Template.type_view.onCreated ->
        @autorun -> Meteor.subscribe 'doc', Router.current().params.id

    Template.type_edit.events
        'blur .body': (e,t)->
            body = t.$('.body').val()
            Docs.update Router.current().params.id,
                $set:body:body


        'click .toggle_complete': (e,t)->
            Docs.update Router.current().params.id,
                $set:complete:!@complete


        'click .delete_schema': ->
            if confirm 'Confirm delete schema'
                Docs.remove @_id
                Router.go '/schemas'

