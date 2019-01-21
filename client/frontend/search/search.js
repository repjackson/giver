// Template.search.helpers({
//     'backPath': function(){
//         return Session.get('backPath')
//     }
// })
//
// Template.churchInfoHolder.events({
//     'click .give': function(event,template){
//         Session.set('givingCode',template.data.code);
//         iosgivepageload(template.data._id)
//     },
//     'click .add': function(event,template){
//         var code = event.currentTarget.id;
//         if(code == 'name'){
//             code: null;
//         }
//         Meteor.call('addMyChurches',template.data._id,code,function(err,res){
//           if(err){
//               alert("There was an error adding this church. Please try again.");
//           }else{
//             alert("This organization has been added to your account.");
//           }
//         })
//     }
// })
//
//
// Template.campaignInfo.helpers({
//     'church': function(){
//         var church = Meteor.users.findOne(this.church);
//         return church.profile;
//     }
// })
//
// Template.campaignInfo.events({
//     'click .give': function(event,template){
//         Session.set('givingCode',template.data.code)
//         console.log('entered ioscamppageload...');
//         //Router.go('/'+template.data.code)
//         ioscamppageload(template.data.code);
//     }
// })
