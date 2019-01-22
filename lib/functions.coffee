addTithe = (result) ->
    id = Tithes.insert(
        status: result.status
        church: result.metadata.church
        churchCODE: result.metadata.givingCODE
        userID: result.metadata.user
        chargeID: result.id
        amount: result.amount
        date: moment().format('X')
        data: result
        plan: result.metadata.plan
        churchVerified: false)
    if result.metadata.plan != null
        TithePlanObj =
            status: 'active'
            churchCODE: result.metadata.churchCODE
            source: result.source.id
            firstChargeDate: moment().format('X')
            firstCharge: id
            lastChargeDate: moment().format('X')
            lastCharge: id
        Meteor.call 'updateTithePlanObj', result.metadata.plan, TithePlanObj
    id