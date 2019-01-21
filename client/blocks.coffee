Template.comments.onCreated ->
    @autorun => Meteor.subscribe 'children', Router.current().params.id
Template.role_editor.onCreated ->
    @autorun => Meteor.subscribe 'type', 'role'

Template.comments.helpers
    doc_comments: ->
        Docs.find
            type:'comment'

Template.comments.events
    'keyup .add_comment': (e,t)->
        if e.which is 13
            parent = Docs.findOne Router.current().params.id
            comment = t.$('.add_comment').val()
            console.log comment
            Docs.insert
                parent_id: parent._id
                type:'comment'
                body:comment
            t.$('.add_comment').val('')

    'click .remove_comment': ->
        if confirm 'Confirm remove comment'
            Docs.remove @_id




Template.user_info.onCreated ->
    @autorun => Meteor.subscribe 'user', @data

Template.user_info.helpers
    user: -> Meteor.users.findOne @valueOf()


Template.user_list_info.onCreated ->
    @autorun => Meteor.subscribe 'user', @data

Template.user_list_info.helpers
    user: -> Meteor.users.findOne @valueOf()


Template.follow.helpers
    followers: ->
        Meteor.users.find
            _id: $in: @follower_ids

    following: -> @follower_ids and Meteor.userId() in @follower_ids


Template.follow.events
    'click .follow': ->
        Docs.update @_id,
            $addToSet:follower_ids:Meteor.userId()

    'click .unfollow': ->
        Docs.update @_id,
            $pull:follower_ids:Meteor.userId()

Template.bookmark_button.events
    'click .bookmark': ->
        if @bookmark_ids and Meteor.userId() in @bookmark_ids
            Docs.update @_id,
                $pull:bookmark_ids:Meteor.userId()
        else
            Docs.update @_id,
                $addToSet:bookmark_ids:Meteor.userId()

Template.bookmark_button.helpers
    bookmark_class: -> if @bookmark_ids and Meteor.userId() in @bookmark_ids then 'teal' else ''


Template.voting.helpers
    upvote_class: -> if @upvoter_ids and Meteor.userId() in @upvoter_ids then 'green' else 'outline'
    downvote_class: -> if @downvoter_ids and Meteor.userId() in @downvoter_ids then 'red' else 'outline'

    downvoters: ->
        Meteor.users.find
            _id: $in: @downvoter_ids
    upvoters: ->
        Meteor.users.find
            _id: $in: @upvoters_ids



Template.voting.events
    'click .upvote': ->
        if @downvoter_ids and Meteor.userId() in @downvoter_ids
            Docs.update @_id,
                $pull: downvoter_ids:Meteor.userId()
                $addToSet: upvoter_ids:Meteor.userId()
                $inc:points:2
        else if @upvoter_ids and Meteor.userId() in @upvoter_ids
            Docs.update @_id,
                $pull: upvoter_ids:Meteor.userId()
                $inc:points:-1
        else
            Docs.update @_id,
                $addToSet: upvoter_ids:Meteor.userId()
                $inc:points:1
        # Meteor.users.update @author_id,
        #     $inc:karma:1

    'click .downvote': ->
        if @upvoter_ids and Meteor.userId() in @upvoter_ids
            Docs.update @_id,
                $pull: upvoter_ids:Meteor.userId()
                $addToSet: downvoter_ids:Meteor.userId()
                $inc:points:-2
        else if @downvoter_ids and Meteor.userId() in @downvoter_ids
            Docs.update @_id,
                $pull: downvoter_ids:Meteor.userId()
                $inc:points:1
        else
            Docs.update @_id,
                $addToSet: downvoter_ids:Meteor.userId()
                $inc:points:-1
        # Meteor.users.update @author_id,
        #     $inc:karma:-1




Template.bookmark_button.helpers
    bookmarkers: ->
        Meteor.users.find _id:$in:@bookmarker_ids


Template.bookmark_button.events
    'click .bookmark': ->
        Docs.update @_id,
            $addToSet: bookmarker_ids:Meteor.userId()



