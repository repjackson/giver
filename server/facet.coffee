Meteor.publish 'user', (username)->
    Meteor.users.find username:username

Meteor.publish 'docs', (selected_tags, type)->
    match = {}
    if type then match.type = type
    if selected_tags.length > 0 then match.tags = $all: selected_tags
    # if selected_author_ids.length > 0 then match.author_id = $in: selected_author_ids

    Docs.find match,
        limit: 10
        sort: timestamp: -1



Meteor.publish 'tags', (selected_tags, type)->
    self = @
    match = {}
    if type then match.type = type
    if selected_tags.length > 0 then match.tags = $all: selected_tags

    cloud = Docs.aggregate [
        { $match: match }
        { $project: tags: 1 }
        { $unwind: '$tags' }
        { $group: _id: '$tags', count: $sum: 1 }
        { $match: _id: $nin: selected_tags }
        { $sort: count: -1, _id: 1 }
        { $limit: 20 }
        { $project: _id: 0, name: '$_id', count: 1 }
        ]
    cloud.forEach (tag) ->
        self.added 'Tags', Random.id(),
            name: tag.name
            count: tag.count

    self.ready()