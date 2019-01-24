Template.leftbar.onCreated ->
    @autorun => Meteor.subscribe 'type', 'schema'


Template.leftbar.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.context .ui.left.sidebar')
                    .sidebar({
                        context: $('.context .bottom.segment')
                        exclusive: false
                        delaySetup:false
                        dimPage: false
                        transition:  'push'
                    })
                    .sidebar('attach events', '.toggle_leftbar')
            , 1000

Template.topbar.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.context .ui.top.sidebar')
                    .sidebar({
                        context: $('.context .bottom.segment')
                        exclusive: false
                        delaySetup:false
                        dimPage: false
                        transition:  'overlay'
                    })
                    .sidebar('attach events', '.toggle_topbar')
            , 1000

# Template.bottombar.onRendered ->
#     @autorun =>
#         if @subscriptionsReady()
#             Meteor.setTimeout ->
#                 $('.context .ui.bottom.sidebar')
#                     .sidebar({
#                         context: $('.context .bottom.segment')
#                         exclusive: false
#                         delaySetup:false
#                         dimPage: false
#                         transition:  'overlay'
#                     })
#                     .sidebar('attach events', '.toggle_bottombar')
#             , 1000

Template.rightbar.onRendered ->
    if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.context .ui.right.sidebar')
                    .sidebar({
                        context: $('.context .bottom.segment')
                        exclusive: false
                        delaySetup:false
                        dimPage: false
                        transition:  'push'
                    })
                    .sidebar('attach events', '.toggle_rightbar')
            , 1000



Template.leftbar.helpers
    schemas: ->
        if Meteor.user() and Meteor.user().roles
            Docs.find {
                # view_roles: $in:Meteor.user().roles
                type:'schema'
            }, sort:title:1

Template.leftbar.events


Template.topbar.events
    'click .set_notifications': (e,t)->
        Session.set 'is_calculating', true
        Meteor.call 'set_schema', 'notification', ->
            Session.set 'is_calculating', false

    'click .set_messages': (e,t)->
        Session.set 'is_calculating', true
        Meteor.call 'set_schema', 'message', ->
            Session.set 'is_calculating', false

    'click .set_bookmarks': (e,t)->
        Session.set 'is_calculating', true
        Meteor.call 'set_schema', 'bookmark', ->
            Session.set 'is_calculating', false

    'click .set_tasks': (e,t)->
        Session.set 'is_calculating', true
        Meteor.call 'set_schema', 'task', ->
            Session.set 'is_calculating', false



Template.rightbar.onCreated ->
    @signing_out = new ReactiveVar false

Template.rightbar.events
    'click .settings': ->
        delta = Docs.findOne type:'delta'
        # console.log @
        Docs.update delta._id,
            $set:
                viewing_page:true
                page_template:'account_settings'
                viewing_delta:false


    'click .delete_delta': ->
        if confirm 'Clear Session?'
            delta = Docs.findOne type:'delta'
            Docs.remove delta._id

    'click .run_fo': ->
        delta = Docs.findOne type:'delta'
        Session.set 'is_calculating', true
        Meteor.call 'fo', (err,res)->
            if err then console.log err
            else
                Session.set 'is_calculating', false



    'click .sla': ->
        delta = Docs.findOne type:'delta'
        Docs.update delta._id,
            $set:
                viewing_page:true
                page_template:'office_sla'
                viewing_delta:false

    'click #logout': (e,t)->
        # e.preventDefault()
        t.signing_out.set true
        Meteor.logout ->
            t.signing_out.set false


Template.rightbar.helpers
    signing_out: -> Template.instance().signing_out.get()
