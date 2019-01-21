if Meteor.isClient
    Template.friend_list.onCreated ->
        @autorun -> Meteor.subscribe 'users'

    Template.friend_list.helpers
        users: ->
            Meteor.users.find()


    Template.assigned_tasks.onCreated ->
        @autorun => Meteor.subscribe 'assigned_tasks'
    Template.assigned_tasks.events
    Template.assigned_tasks.helpers
        assigned_tasks: ->
            Docs.find
                assigned_ids:$in:[Meteor.userId()]




    Template.following.onCreated ->
        Meteor.subscribe 'my_following'


    Template.following.helpers
        following: ->
            me = Meteor.user()
            Docs.find
                follower_ids:$in:[me._id]



if Meteor.isServer
    Meteor.publish 'type', (type)->
        Docs.find
            type:type

    Meteor.publish 'users', () ->
        Meteor.users.find {
            roles:$in:['user']},
            limit:10


    Meteor.publish 'my_following', ->
        me = Meteor.user()
        Docs.find
            follower_ids:$in:[me._id]

    Meteor.publish 'assigned_tasks', ->
        Docs.find
            assigned_ids:$in:[Meteor.userId()]

