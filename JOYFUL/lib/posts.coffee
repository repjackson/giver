Router.route '/posts', ->
    @render 'posts'

Router.route '/post/:id/edit', ->
    @render 'post_edit'

Router.route '/post/:id/view', ->
    @render 'post_view'



if Meteor.isClient
    Template.posts.onCreated ->
        @autorun -> Meteor.subscribe 'type', 'post'

    Template.posts.events
        'click .add_post': ->
            new_post_id = Docs.insert type:'post'
            Router.go "/post/#{new_post_id}/edit"

    Template.posts.helpers
        posts: ->
            Docs.find
                type:'post'


    Template.post_edit.onCreated ->
        @autorun -> Meteor.subscribe 'doc', Router.current().params.id

    Template.post_edit.onRendered ->
        Meteor.setTimeout ->
            $('.summernote').summernote({
                height: 300
            })
        , 2000


    Template.post_view.onCreated ->
        @autorun -> Meteor.subscribe 'doc', Router.current().params.id

    Template.post_edit.events
        'click .save': (e,t)->
            console.log t.$('.summernote').summernote('code')



