Template.thanks.helpers({
  'date': function(){
     return moment.unix(this.tithe.date).format("MM/DD/YYYY, h:mm a");
  },
  'amount': function(){
    return numeral(this.tithe.amount/100).format('$0,0.00');
  },
  'church': function(){
    return Meteor.users.findOne(this.tithe.church)
},
'ios': function(){
    return Session.get('ios');
}
})

Template.thanks.events({
    'click .createAccount': function(event,template){
        Session.set('registerTithe',template.data.tithe._id);
        Router.go('/register/giver')
    }
})
