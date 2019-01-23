Router.route '/people', -> @render 'people'
Router.route '/person/:id/view', -> @render 'person_view'


if Meteor.isClient
    @selected_user_tags = new ReactiveArray []
    @selected_usernames = new ReactiveArray []
    @selected_status = new ReactiveArray []

    Template.people.onCreated ->
        @autorun -> Meteor.subscribe('people')

    Template.people.events
        'click .add_person': ->
            new_person_id = Docs.insert type:'person'
            Router.go "/person/#{new_person_id}/edit"

    Template.people.helpers
        people: ->
            Meteor.users.find()

        selected_tags: -> selected_tags.list()

        global_tags: ->
            doccount = Docs.find().count()
            if 0 < doccount < 3 then Tags.find { count: $lt: doccount } else Tags.find()

        single_doc: ->
            count = Docs.find({}).count()
            if count is 1 then true else false

        global_usernames: -> Usernames.find()
        selected_usernames: -> selected_usernames.list()

    Template.people.events
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

    Template.person_view.onCreated ->
        @autorun -> Meteor.subscribe 'doc', Router.current().params.id


if Meteor.isServer
    Meteor.publish 'people', ->
        Meteor.users.find {},
            limit:10