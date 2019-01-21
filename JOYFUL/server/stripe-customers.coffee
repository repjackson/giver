Future = Npm.require('fibers/future')
Meteor.methods
  'STRIPE_remove_card': (MyCardId, user) ->
    Stripe = StripeAPI(SERVER_SETTINGS.stripeSecret)
    cardData = MyCards.findOne(MyCardId)
    userData = Meteor.users.findOne(user)
    #REMOVE A CARD
    removeCard = new Future
    if cardData.cardid
      Stripe.customers.deleteCard userData.profile.stripe.id, cardData.cardid, (err, confirmation) ->
        if err
          removeCard.return err
        else
          removeCard.return confirmation
    else
      removeCard.return true
    confirmation = removeCard.wait()
    if !confirmation.error
      console.log confirmation
      MyCards.remove MyCardId
    else
      console.log confirmation

  'STRIPE_change_default_card': (MyCardId, user) ->
    Stripe = StripeAPI(SERVER_SETTINGS.stripeSecret)
    cardData = MyCards.findOne(MyCardId)
    userData = Meteor.users.findOne(user)
    #CHANGE DEFAULT CARD
    defaultCard = new Future
    Stripe.customers.update userData.profile.stripe.id, { default_source: cardData.cardid }, (err, confirmation) ->
      if err
        defaultCard.return err
      else
        defaultCard.return confirmation
    confirmation = defaultCard.wait()
    if !confirmation.error
      #console.log(confirmation)
      MyCards.update { user: user }, { $unset: default: null }, { multi: true }, (err, res) ->
        MyCards.update MyCardId, $set: default: true
    else
      console.log confirmation