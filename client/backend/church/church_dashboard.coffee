Template.church_dashboard.helpers
    'total': ->
        start = moment().startOf('year').format('X')
        end = moment().endOf('month').format('X')
        amt = Tithes.find(date:
            $lte: end
            $gte: start).sum('amount')
        numeral(amt / 100).format '$0,0'
    'churchUrl': ->
        Meteor.absoluteUrl() + 'churchDetail/' + Meteor.userId()
    'JGUrl': ->
        Meteor.absoluteUrl()

Template.church_dashboard.events 'click .generate': ->
    bootbox.prompt
        title: 'Is this for a specific campaign? (leave blank for general fund donations)'
        callback: (result) ->
            if result != null
                Meteor.call 'generateNewCode', Meteor.userId(), result, (err, res) ->
                    if res
                        Router.go '/church/codes'
                    else
                        alert err.reason

Template.church_dashboard.onRendered ->
    setTimeout (->
        listData = Tithes.find({}, sort: 'date': 1).fetch()
        if listData.length > 0
            usefulTitheData = []
            listData.forEach (d, i) ->
                usefulTitheDataJson = {}
                usefulTitheDataJson['amount'] = d.amount
                usefulTitheDataJson['date'] = moment.unix(d.date).format('MM-DD-YY')
                usefulTitheData.push usefulTitheDataJson
            UniquedDates = $.unique(usefulTitheData.map((d) ->
                moment(d.date, 'MM-DD-YY').format 'MM-DD-YY'
            ))
            finalArray = [ 'Daily Gifts' ]
            UniquedDates.forEach (dd, ii) ->
                filteredData = usefulTitheData.filter((j, k) ->
                    j.date == dd
                )
                total = 0
                filteredData.forEach (a, b) ->
                    total = +total + +a.amount
                finalArray.push numeral(total / 100).format(0)
            c3.generate
                bindto: '#stocked'
                data:
                    columns: [ finalArray ]
                    colors: 'Daily Gifts': '#9c1c5a'
                    type: 'bar'
                    groups: [ [ 'data1' ] ]
                axis: x:
                    type: 'categorized'
                    categories: UniquedDates
    ), 10