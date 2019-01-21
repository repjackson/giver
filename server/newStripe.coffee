# // /*Meteor.methods({
# //     'register_church': function(data){
# //         var Stripe = StripeAPI(SERVER_SETTINGS.stripeSecret);

# //         var account = Stripe.accounts.create(
# //             {
# //                 country: "US",
# //                 managed: true
# //             }
# //         );
# //     },
# //     'remove_stripe': function(id){
# //         Meteor.users.update(id,{$unset: {'stripe': null, 'profile.stripe': null}})
# //     },
# //     'check_stripe': function(id){
# //         var account = Meteor.users().find(id);
# //         if(account.stripe.stripeId){
# //             Meteor.users.update(id,{$set: {'profile.stripe': 1, stripe: {$ne: null}}})
# //         }else{
# //             Meteor.users.update(id,{$set: {'profile.status': 0, 'profile.stripe': 0}})
# //         }

# //     },
# //     'STRIPE_create_customer': function(userID,type){
# //         var Stripe = StripeAPI(SERVER_SETTINGS.stripeSecret);
# //         var user = Meteor.users.findOne(userID);

# //         //SETUP THE CUSTOMER data
# //         if(type=='email'){
# //             var user_email = user.emails;
# //             var userData = {
# //                 email: user_email[0]['address'],
# //                 description: user_email[0]['address']+' - '+userID,
# //                 metadata: {
# //                     userID: userID
# //                 }
# //             }
# //         }
# //         if(type=='phone'){
# //             var userData = {
# //                 description: user.profile.phone+' - '+userID,
# //                 metadata: {
# //                     userID: userID,
# //                     phone: user.profile.phone
# //                 }
# //             }
# //         }

# //         //CREATE THE CUSTOMER
# //         var createCustomer = new Future();

# //         Stripe.customers.create(userData,function(err,customer){
# //             if (err){     createCustomer.return({error: err});          }
# //             else {        createCustomer.return({result: customer});    }
# //         });

# //         var newCustomer = createCustomer.wait()
# //         if(newCustomer){
# //             Meteor.users.update(userID,{$set: {
# //                 'profile.stripe': {
# //                     data: newCustomer.result,
# //                     id: newCustomer.result.id
# //                 }}
# //             });
# //         }
# //     },
# //     'STRIPE_tokenize_card': function(data){
# //         var Stripe = StripeAPI(SERVER_SETTINGS.stripeSecret);

# //         var tokenizeCard = new Future();

# //         Stripe.tokens.create({
# //             card: {
# //                 "number": data.card,
# //                 "exp_month": data.exp_month,
# //                 "exp_year": data.exp_year,
# //                 "address_zip": data.zip
# //             }
# //         },function(err,token){
# //             if (err){     tokenizeCard.return({error: token});          }
# //             else {        tokenizeCard.return({result: token});    }
# //         });

# //         console.log(tokenizeCard);
# //     },
# //     'STRIPE_store_card': function(data,user){
# //         //var Stripe = StripeAPI(SERVER_SETTINGS.stripeSecret);
# //         Stripe.secretKey = 'sk_test_DO3qR59n9I8AzeyCkx2cItFg'
# //         var userData = Meteor.users.findOne(user);
# //         var stripeId = userData.profile.stripe.id;
# //         //ADD A CARD
# //         //console.log(data)
# //         //console.log(userData.profile)
# //         //console.log(stripeId)
# //         this.unblock();

# //         try {
# //             var result = Stripe.customers.createSource({stripeId,{
# //                 source: {
# //                     "object": 'card',
# //                     "number": data.card,
# //                     "exp_month": data.exp_month,
# //                     "exp_year": data.exp_year,
# //                     "address_zip": data.zip
# //                 }
# //             }});

# //             // do something with result, save to db maybe?
# //             console.log(result)
# //             return result;
# //         }
# //         catch(error){
# //             console.log(error)
# //             throw new Meteor.Error('payment-failed', 'The payment failed');
# //         }
# //         //console.log(newCard)
# //     },
# //     'stripeChurchAuth': function(code,user){
# //         console.log(code)
# //         var responseContent;

# //         try {
# //             // Request an access token
# //             responseContent = HTTP.post(
# //                 "https://connect.stripe.com/oauth/token", {
# //                     params: {
# //                         client_secret: SERVER_SETTINGS.stripeSecret,
# //                         code:          code,
# //                         grant_type: 	'authorization_code',
# //                         redirect_uri: Meteor.absoluteUrl("/church/dashboard")
# //                     }
# //                 }).content;

# //             } catch (err) {
# //                 throw _.extend(new Error("Failed to complete OAuth handshake with stripe. " + err.message),
# //                 {response: err.response});
# //             }
# //             // Success!  Extract the stripe access token and key
# //             // from the response
# //             var parsedResponse = JSON.parse(responseContent);

# //             var data = {
# //                 stripeResponse: parsedResponse,
# //                 stripeAccessToken: parsedResponse.access_token,
# //                 stripeId: parsedResponse.stripe_user_id,
# //                 stripePublishableKey: parsedResponse.stripe_publishable_key
# //             }
# //             console.log(data)
# //             Meteor.users.update(user,{$set: {stripe: data }});

# //             if (!parsedResponse.access_token) {
# //                 throw new Error("Failed to complete OAuth handshake with stripe " +
# //                 "-- can't find access token in HTTP response. " + responseContent);
# //             }else{
# //                 Meteor.users.update(user,{$set: {'profile.stripe': true}});
# //                 return true
# //             }
# //         },
# //         stripeTokenCard: function(data){
# //             var Stripe = StripeAPI(SERVER_SETTINGS.stripeSecret);
# //             Stripe.tokens.create({
# //                 card: {
# //                     "number": '4242424242424242',
# //                     "exp_month": 12,
# //                     "exp_year": 2016,
# //                     "zip": '90019'
# //                 }
# //             }, function(err, token) {
# //                 if(err){
# //                     console.log(err)

# //                 }else{
# //                     //console.log(token)
# //                     return token
# //                 }
# //             });
# //         },
# //         STRIPE_single_charge: function(data){
# //             var Stripe = StripeAPI(SERVER_SETTINGS.stripeSecret);
# //             var account = Meteor.users.findOne(data.church);
# //             var user_email = user.emails;
# //             console.log(data)
# //             console.log(account.stripe.stripeId)

# //             var chargeCard = new Future();

# //             Stripe.charges.create({
# //                 amount: data.amount*100, // amount in cents
# //                 currency: "usd",
# //                 source: {
# //                     "object": 'card',
# //                     "number": data.card,
# //                     "exp_month": data.exp_month,
# //                     "exp_year": data.exp_year,
# //                     "address_zip": data.zip
# //                 },
# //                 metadata: {
# //                     church: data.church,
# //                     givingCODE: data.givingCODE,
# //                     user: data.userID
# //                 },
# //                 description: "Example charge",
# //                 application_fee: 100, // amount in cents
# //                 destination: account.stripe.stripeId
# //             }, function(error, result){
# //                 if (error){
# //                     chargeCard.return({error: error});
# //                 } else {
# //                     chargeCard.return({result: result});
# //                 }
# //             });
# //             return chargeCard.wait();
# //         },
# //         SMS_OneOffCharge: function(data){
# //             var Stripe = StripeAPI(SERVER_SETTINGS.stripeSecret);
# //             var account = Meteor.users.findOne(data.church);
# //             console.log(data)
# //             console.log(account.stripe.stripeId)

# //             var chargeCard = new Future();

# //             Stripe.charges.create({
# //                 amount: data.amount*100, // amount in cents
# //                 currency: "usd",
# //                 card: data.cardToken,
# //                 metadata: {
# //                     church: data.church,
# //                     givingCODE: data.code,
# //                     user: data.user,
# //                     sms_record: data.sms_record,
# //                     method: 'SMS',
# //                     phone: data.phone
# //                 },
# //                 description: "Example charge",
# //                 application_fee: 100, // amount in cents
# //                 destination: account.stripe.stripeId
# //             }, function(error, result){
# //                 if (error){
# //                     chargeCard.return({error: error});
# //                 } else {
# //                     chargeCard.return({result: result});
# //                 }
# //             });
# //             return chargeCard.wait();
# //         },
# //         stripeCreatePlan: function(data){
# //             var Stripe = StripeAPI(SERVER_SETTINGS.stripeSecret);
# //             var account = Meteor.users.findOne(data.church);

# //             var user = Meteor.users.findOne(data.userID);
# //             var user_email = user.emails;

# //             var plan = TithePlans.insert({
# //                 userID: data.userID,
# //                 church: data.church,
# //                 givingCODE: data.givingCODE,
# //                 amount: data.amount,
# //                 recurrence: data.recurrence,
# //                 status: 'submitted'
# //             })

# //             var createCustomer = new Future();

# //             //CREATE THE CUSTOMER
# //             Stripe.customers.create({
# //                 source: {
# //                     "object": 'card',
# //                     "number": data.card,
# //                     "exp_month": data.exp_month,
# //                     "exp_year": data.exp_year,
# //                     "address_zip": data.zip
# //                 },
# //                 email: user_email[0]['address'],
# //                 description: user_email[0]['address']+' - '+data.userID,
# //                 metadata: {
# //                     userID: data.userID
# //                 }
# //             },function(err,customer){
# //                 if (err){     createCustomer.return({error: err});          }
# //                 else {        createCustomer.return({result: customer});    }
# //             });

# //             var newCustomer = createCustomer.wait()
# //             if(newCustomer.error){
# //                 return newCustomer
# //             }
# //             console.log(newCustomer)
# //             var makeCharge = new Future();

# //             Stripe.charges.create({
# //                 amount: data.amount*100, // amount in cents, again
# //                 currency: "usd",
# //                 customer: newCustomer.result.id,
# //                 application_fee: 100, // amount in cents
# //                 destination: account.stripe.stripeId,
# //                 metadata: {
# //                     church: data.church,
# //                     givingCODE: data.givingCODE,
# //                     user: data.userID,
# //                     recurring: true,
# //                     plan: plan
# //                 },
# //             },function(err,charge){
# //                 if (err){     makeCharge.return({error: err});          }
# //                 else {
# //                     makeCharge.return({result: charge});
# //                 }
# //             });

# //             return makeCharge.wait();
# //         }
# //     });
# // */
