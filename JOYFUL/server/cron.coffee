SyncedCron.add
  name: 'ProcessRecurringBiWeekly'
  schedule: (parser) ->
    # parser is a later.parse object
    parser.text 'every 1 days'
  job: ->
    lastChargeTime = moment().subtract(14, 'days').format('X')
    plans = TithePlans.find(
      status: 'active'
      recurrence: 'bi-weekly'
      lastChargeDate: $lte: lastChargeTime)
    _.each plans.fetch(), (planData) ->
      user = Meteor.users.findOne(planData.userID)
      chargeData =
        church: planData.church
        plan: planData._id
        amount: planData.amount
        userID: planData.userID
        customer: user.profile.stripe.id
        churchCODE: planData.churchCODE
        source: planData.source
      #console.log(chargeData)
      Meteor.call 'STRIPE_recurring_charge', chargeData, (error, result) ->
        `var result`
        console.log 'STRIPE RECUR RESPONSE REACHED'
        if error
          console.log error
        if result.error
          console.log 'BI WEEKLY RECUR ERROR'
          console.log result.error.message
        else
          #console.log(result)
          result = result.result
          if result.status == 'succeeded'
            id = addTithe(result)
            console.log 'BiWeekly Tithe Charged: ' + id
            TithePlans.update chargeData.plan, $set:
              lastChargeDate: moment().format('X')
              lastCharge: id

SyncedCron.add
  name: 'ProcessRecurringMonthly'
  schedule: (parser) ->
    # parser is a later.parse object
    parser.text 'every 1 days'
  job: ->
    lastChargeTime = moment().subtract(1, 'month').format('X')
    plans = TithePlans.find(
      status: 'active'
      recurrence: 'monthly'
      lastChargeDate: $lte: lastChargeTime)
    console.log plans.count()
    _.each plans.fetch(), (planData) ->
      user = Meteor.users.findOne(planData.userID)
      console.log 'STRIPE PLAN REACHED'
      chargeData =
        church: planData.church
        plan: planData._id
        amount: planData.amount
        userID: planData.userID
        customer: user.profile.stripe.id
        churchCODE: planData.churchCODE
        source: planData.source
      #console.log(chargeData)
      Meteor.call 'STRIPE_recurring_charge', chargeData, (error, result) ->
        `var result`
        console.log 'STRIPE RECUR RESPONSE REACHED'
        if error
          console.log error
        if result.error
          console.log 'MONTHLY RECUR ERROR'
          console.log result.error.message
        else
          result = result.result
          if result.status == 'succeeded'
            id = addTithe(result)
            console.log 'Monthly Tithe Charged: ' + id
            TithePlans.update chargeData.plan, $set:
              lastChargeDate: moment().format('X')
              lastCharge: id

SyncedCron.add
  name: 'ProcessRecurringWeekly'
  schedule: (parser) ->
    # parser is a later.parse object
    parser.text 'every 1 days'
  job: ->
    lastChargeTime = moment().subtract(7, 'days').format('X')
    plans = TithePlans.find(
      status: 'active'
      recurrence: 'weekly'
      lastChargeDate: $lte: lastChargeTime)
    console.log plans.count()
    _.each plans.fetch(), (planData) ->
      user = Meteor.users.findOne(planData.userID)
      console.log 'STRIPE PLAN REACHED'
      chargeData =
        church: planData.church
        plan: planData._id
        amount: planData.amount
        userID: planData.userID
        customer: user.profile.stripe.id
        churchCODE: planData.churchCODE
        source: planData.source
      #console.log(chargeData)
      Meteor.call 'STRIPE_recurring_charge', chargeData, (error, result) ->
        `var result`
        console.log 'STRIPE RECUR RESPONSE REACHED'
        if error
          console.log error
        if result.error
          console.log 'MONTHLY RECUR ERROR'
          console.log result.error.message
        else
          result = result.result
          if result.status == 'succeeded'
            id = addTithe(result)
            console.log 'Monthly Tithe Charged: ' + id
            TithePlans.update chargeData.plan, $set:
              lastChargeDate: moment().format('X')
              lastCharge: id

SyncedCron.add
  name: '30DayTrialPeriodOver'
  schedule: (parser) ->
    # parser is a later.parse object
    parser.text 'every 1 days'
  job: ->
    trialUsers = Meteor.users.find('createdAt':
      $lte: new Date((new Date).setDate((new Date).getDate() - 29))
      $gte: new Date((new Date).setDate((new Date).getDate() - 31)))
    _.each trialUsers.fetch(), (trialUserData) ->
      Meteor.users.update { _id: trialUserData._id }, $set: 'isJGFeesApply': true

# SyncedCron.add
#   name: 'autoBackupOfDBDaily'
#   schedule: (parser) ->
#     # parser is a later.parse object
#     parser.text 'every 1 days'
#   job: ->
#     Meteor.call 'downloadBackup', (err, res) ->
#       if err
#         console.log err.reason
#       else
#         Email.send
#           to: 'info@joyful-giver.com'
#           from: 'info@joyful-giver.com'
#           subject: 'Joyful Giver Auto backup'
#           html: 'Backup of Date ' + new Date
#           attachments: res
#       return
#     return
