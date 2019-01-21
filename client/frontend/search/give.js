          var cardIOResponseFields = [
           "card_type",
           "redacted_card_number",
           "card_number",
           "expiry_month",
           "expiry_year",
           "cvv",
           "zip"
          ];

Session.set('giveAmount','');

var onCardIOCancel = function() {
       console.log("card.io scan cancelled");
};
Template.give.onCreated(function(){
    Session.set('giveAmount','');
});


Template.give.helpers({

// "getTitle": function(){
//    console.log(this);
//
// },
// isMobileDevice: function(){
//        var devicePlatform = "";
//        try { devicePlatform = device.platform;   } catch (err) { alert("failed to detect platform");  };
//        if( (devicePlatform=="iOS") || (devicePlatform=="Android") ) {
//           return true;
//        }else{
//           return false;
//        }
// },
'monthDDL':function(){
    return [
        {text:'01',value:'01'},
        {text:'02',value:'02'},
        {text:'03',value:'03'},
        {text:'04',value:'04'},
        {text:'05',value:'05'},
        {text:'06',value:'06'},
        {text:'07',value:'07'},
        {text:'08',value:'08'},
        {text:'09',value:'09'},
        {text:'10',value:'10'},
        {text:'11',value:'11'},
        {text:'12',value:'12'},
    ]
},
'yearDDL':function(){
    var yearDDL = [];
    for(var i=0;i<10;i++)
    {
        yearDDL.push({text:moment().year() + i,value:moment().year()+i})
    }
    return yearDDL;
},
isCurrentMonth:function(month){
    if(month == moment().month()+1)
    {
        return 'selected';
    }
    else
    {
        return '';
    }
},
getProperUrl(website) {
        let protocol = website ? website.slice(0, 4) : '';
        if (protocol !== 'http') {
            return `http://${website}`;
        } else return website;
    },

});

Template.give.events({
    'click #scanBtn': function(){
              CardIO.scan({
                    "expiry": true,
                    "cvv": true,
                    "zip": false,
                    "suppressManual": false,
                    "suppressConfirm": false,
                    "hideLogo": true,
                    "usePaypalIcon": false
                },
                function(response) {
                     console.log("card.io scan complete");
                     for (var i = 0, len = cardIOResponseFields.length; i < len; i++) {
                       var field = cardIOResponseFields[i];
                       console.log(field + ": " + response[field]);
                     }
                     $('#card').val(response['card_number']);
                     $('[name="month"]').val(response['expiry_month'])
                     $('[name="year"]').val(response['expiry_year'])
                    //  $('#exp').val(response['expiry_month']+'/'+response['expiry_year']);
                     $('#cvc').val(response['cvv']);
                },
                function() {
                    console.log("card.io scan cancelled");
                }
              );
    },
    'click #repeat': function(){
        if($('#repeat').is(':checked')) {
            $('#repeat_type').fadeIn();
        }else{
            $('#repeat_type').fadeOut();
        }
    },
    "click #fbShhare":function(e,t){
    var link="https://www.facebook.com/sharer/sharer.php?u="+window.location.href;

    var windowHandle;
    if (Meteor.isCordova) {
          windowHandle = window.open(link, "_blank", "location=yes");
    } else {
      windowHandle = window.open(null, "", "height=440,width=640,scrollbars=yes");
          windowHandle.location.href = link;
    }

  },
  "click #twShhare":function(e,t){
  var link="https://twitter.com/intent/tweet?url="+window.location.href+"&amp;text=Give online through joyful giver&amp;via=Joyful Giver";

  var windowHandle;
  if (Meteor.isCordova) {
        windowHandle = window.open(link, "_blank", "location=yes");
  } else {
    windowHandle = window.open(null, "", "height=440,width=640,scrollbars=yes");
        windowHandle.location.href = link;
  }
},

    'change #amount': function(){
        Session.set('giveAmount',$('#amount').val());
        $('.total').empty().html(' $'+$('#amount').val())
    },
    'change #card_select': function(){
        if($('#card_select').val() == 'NEW'){
            $('.card_data').show();
        }else{
            $('.card_data').hide();
        }
    },
    'click #give': function(event,template){
        $(event.currentTarget).attr('disabled',true)
        var self = this;
        if(Session.get('giveAmount') == "")
        {
            $(event.currentTarget).attr('disabled',false)
            alert('Please select give amount');
            return false;
        }
        else if(Session.get('giveAmount') < 3)
        {
            $(event.currentTarget).attr('disabled',false)
            alert('Minimum give amount is $ 3');
            return false;
        }
        if($('#card_select').val() != 'NEW' && $('#card_select').val() != ''){
            // $('.giveFormNoCC').data('bootstrapValidator').validate();
        }else{
            // $('#giveForm').data('bootstrapValidator').validate();
        }
        var next = false;

        if($('#giveForm').data('bootstrapValidator').isValid() && $('#card_select').val() == 'NEW'){
            // var exp = $('#exp').val().split('/')
            var chargeData = {
                card: $('#card').val(),
                exp_month: $('[name="month"]').val(),
                exp_year: $('[name="year"]').val(),
                cvc: $('#cvc').val()
            }
            var next = true;
            var type='new card'
        }
        if($('.giveFormNoCC').data('bootstrapValidator').isValid() && $('#card_select').val() != 'NEW' && $('#card_select').val() != '' ){
            var chargeData = {
                source: $('#card_select').val()
            }
            if($('#card_select').val()!=''){
                var next = true;
            }else{
                var next = false;
                // $('#giveError').html('<p>Please select a payment card.</p>').fadeIn();
                FlashMessages.sendError('Please select a payment card.');
            }

        }

        //alert($('#repeat').is(':checked'))
        if($('#repeat').is(':checked') && $('#repeat_type').val() == 0){
            var next = false;
            FlashMessages.sendError('How often do you want to repeat this gift?');

            // $('#giveError').html('<p>How often do you want to repeat this gift?</p>').fadeIn();
        }

        //IF THE FORM IS VALID CONTINUE ON
        if(next==true){
          showLoadingMask();
//console.log(template.data);
            chargeData.church = template.data.church._id;
            chargeData.amount = parseFloat(Session.get('giveAmount'));

            if(Meteor.userId()){
                chargeData.userID = Meteor.userId();
                chargeData.customer = Meteor.user().profile.stripe.id ;
            }
            else{                chargeData.user = null                  }

            // if(Session.get('givingCode')){
            //     if(Session.get('givingCode')=='name'){    chargeData.givingCode = null;  }
            //     else{ chargeData.givingCode = Session.get('givingCode'); }
            // }
            // else{    chargeData.givingCode = null       }
            if(self.cid) chargeData.givingCODE = self.cid;
            else chargeData.givingCODE = null;

            if($('#repeat').is(':checked')){
                chargeData.recurrence = $('#repeat_type').val();
                var TithPlanObj = {
                    userID: Meteor.userId(),
                    church: chargeData.church,
                    givingCODE: chargeData.givingCODE,
                    amount: chargeData.amount,
                    recurrence: $('#repeat_type').val(),
                    status: 'submitted'
                }
                var planId = Meteor.call('addTithePlan',TithPlanObj)
                //alert(planId)
                chargeData.plan = planId;
            }else{
                chargeData.plan = null;
            }

            if($('#card_select').val() == 'NEW'){
                //console.log('new test')
                var next = false
                Stripe.card.createToken({
                    number: chargeData.card,
                    exp_month: chargeData.exp_month,
                    exp_year: chargeData.exp_year,
                    cvc: chargeData.cvc
                }, function(status,response){
                    //IF A USER IS PRESENT STORE THE NEWLY TOKENIZED CARD FIRST
                    //console.log(status); //console.log(response)
                    if(status==200){
                        if(chargeData.userID){
                            Meteor.call('STRIPE_store_card',response.id,chargeData.userID,function(error,result){
                                if(result){
                                    chargeData.source = result.id;

                                    Meteor.call('STRIPE_single_charge',chargeData,function(error,result){
                                        if(result.error){
                                            // $('#giveError').html('<p>'+result.error.message+'</p>').fadeIn();
                                            $(event.currentTarget).attr('disabled',false)
                                            FlashMessages.sendError(result.error.message);
                                            hideLoadingMask();
                                        }else{
                                            var result = result.result;
                                            if(result.status == 'succeeded'){
                                                var id = addTithe(result)

                                                if(id){
                                                    hideLoadingMask();
                                                    if($('#email').val() || result.userID)
                                                    Meteor.call('sendGiveReciept',$('#email').val(),id)

                                                    Router.go('/thanks/'+id)
                                                }
                                            }
                                        }
                                    });
                                }
                            });
                        }else{
                            //console.log("response.id = ", response.id);
                            chargeData.source = response.id;
                            Meteor.call('STRIPE_single_charge',chargeData,function(error,result){
                                if(result.error){
                                    // $('#giveError').html('<p>'+result.error.message+'</p>').fadeIn();
                                    $(event.currentTarget).attr('disabled',false)
                                    FlashMessages.sendError(result.error.message);

                                    hideLoadingMask();
                                }else{
                                    var result = result.result;
                                    if(result.status == 'succeeded'){
                                        var id = addTithe(result)

                                        if(id){
                                            hideLoadingMask();
                                            if($('#email').val() || result.userID)
                                            Meteor.call('sendGiveReciept',$('#email').val(),id)

                                            Router.go('/thanks/'+id)
                                        }
                                    }
                                }
                            });
                        }
                    }else{
                        //console.log(response.error)
                        // $('#giveError').html(response.error.message).fadeIn();
                        $(event.currentTarget).attr('disabled',false)
                        FlashMessages.sendError(response.error.message);
                        hideLoadingMask();
                    }
                });
            }
            else if(chargeData.source && Meteor.userId())
            {
              Meteor.call('STRIPE_single_charge',chargeData,function(error,result){
              //console.log("result = ", result);
                  if(result.error){
                      // $('#giveError').html('<p>'+result.error.message+'</p>').fadeIn();
                      $(event.currentTarget).attr('disabled',false)
                      FlashMessages.sendError(result.error.message);

                      hideLoadingMask();
                  }else{
                      var result = result.result;
                      if(result.status == 'succeeded'){
                          var id = addTithe(result)

                          if(id){
                              hideLoadingMask();
                              if($('#email').val() || result.userID)
                              Meteor.call('sendGiveReciept',$('#email').val(),id)

                              Router.go('/thanks/'+id)
                          }
                      }
                  }
              });
            }

            //CHARGE THE CARD
            else{
                // var exp = $('#exp').val().split('/')
                chargeData.card = $('#card').val(),
                chargeData.exp_month = $('[name="month"]').val();
                chargeData.exp_year = $('[name="year"]').val()
                chargeData.cvc = $('#cvc').val();
                Stripe.card.createToken({
                    number: chargeData.card,
                    exp_month: chargeData.exp_month,
                    exp_year: chargeData.exp_year,
                    cvc: chargeData.cvc
                }, function(status,response){
                    //IF A USER IS PRESENT STORE THE NEWLY TOKENIZED CARD FIRST
                    //console.log(status); //console.log(response)
                    if(status==200){
                        if(chargeData.userID){
                            Meteor.call('STRIPE_store_card',response.id,chargeData.userID,function(error,result){
                                if(result){
                                    chargeData.source = result.id;

                                    Meteor.call('STRIPE_single_charge',chargeData,function(error,result){
                                        if(result.error){
                                            // $('#giveError').html('<p>'+result.error.message+'</p>').fadeIn();
                                            $(event.currentTarget).attr('disabled',false)
                                            FlashMessages.sendError(result.error.message);
                                            hideLoadingMask();
                                        }else{
                                            var result = result.result;
                                            if(result.status == 'succeeded'){
                                                var id = addTithe(result)

                                                if(id){
                                                    hideLoadingMask();
                                                    if($('#email').val() || result.userID)
                                                    Meteor.call('sendGiveReciept',$('#email').val(),id)

                                                    Router.go('/thanks/'+id)
                                                }
                                            }
                                        }
                                    });
                                }
                            });
                        }else{
                            console.log("response.id = ", response.id);
                             chargeData.source = response.id;
                            Meteor.call('STRIPE_single_charge',chargeData,function(error,result){
                            //console.log("result = ", result);
                                if(result.error){
                                    // $('#giveError').html('<p>'+result.error.message+'</p>').fadeIn();
                                    $(event.currentTarget).attr('disabled',false)
                                    FlashMessages.sendError(result.error.message);

                                    hideLoadingMask();
                                }else{
                                    var result = result.result;
                                    if(result.status == 'succeeded'){
                                        var id = addTithe(result)

                                        if(id){
                                            hideLoadingMask();
                                            if($('#email').val() || result.userID)
                                            Meteor.call('sendGiveReciept',$('#email').val(),id)

                                            Router.go('/thanks/'+id)
                                        }
                                    }
                                }
                            });
                        }
                    }else{
                        //console.log(response.error)
                        // $('#giveError').html(response.error.message).fadeIn();
                        $(event.currentTarget).attr('disabled',false)
                        FlashMessages.sendError(response.error.message);
                        hideLoadingMask();
                    }
                });

 /*
                Meteor.call('STRIPE_single_charge',chargeData,function(error,result){
                    console.log(error); console.log(result)
                  if(error){

                        FlashMessages.sendError(error.message);
                        hideLoadingMask();
                    }
                  if(result.error){
                        FlashMessages.sendError(result.error.message);
                        hideLoadingMask();
                    }else{
                        var result = result.result;
                        if(result.status == 'succeeded'){
                            var id = addTithe(result)

                            if(id){
                                hideLoadingMask();
                                Router.go('/thanks/'+id)
                            }
                        }
                    }
                }); */
            }
        }
        else $(event.currentTarget).attr('disabled',false)
    },
    'click .btnBlockAmount':function(e,t){
        var amount = $(e.currentTarget).attr('data-value');
        $('.btnBlockAmount').addClass('btn-outline');
        $(e.currentTarget).removeClass('btn-outline')
        if(amount == 'other')
        {
            $('.inputAmount').show();
            $('.btnBlockAmount').hide();
            Session.set('giveAmount','');
            $('.total').empty()
        }
        else{
            Session.set('giveAmount',amount);
            $('.total').empty().html(' $'+amount)
        }
    },
    'click .editable-clear-x':function(e,t){
        $('.inputAmount').hide();
        Session.set('giveAmount','');
        $('.total').empty()
        $('.btnBlockAmount').show();
    }
})


Template.give.rendered = function(event,template){
    if(this.data.cardCount > 0){
        $('.card_data').hide();
        $('#card_select').show();
    }else{
        $('.card_data').show();
        $('#card_select').hide();
    }
    $('#giveForm').bootstrapValidator({
        message: 'This value is not valid',
        feedbackIcons: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
            // amount: {
            //     message: 'You must provide a gift amount.',
            //     validators: {
            //         greaterThan: {
            //             inclusive: true,
            //             value: 3,
            //             message: 'Your tithe must be at least $3.'
            //         },
            //         notEmpty: {
            //             message: 'You must select a donation amount.'
            //         },
            //     }
            // },
            card: {
                message: 'You must provide a credit card number.',
                validators: {
                    notEmpty: {
                        message: 'The credit card number is required'
                    },
                    creditCard: {
                        message: 'The credit card number is not valid'
                    }
                }
            },
            exp: {
                message: 'You must provide a valid expiration date MM/YY.',
                validators: {
                    callback: {
                        message: 'You must provide a valid expiration date MM/YY',
                        callback: function (value, validator) {
                            var m = new moment(value, 'MM/YY', true);
                            if (!m.isValid()) {
                                return false;
                            }
                            return true
                        }
                    },
                    notEmpty: {
                        message: 'Expiration date is required MM/YY'
                    },
                }
            },
            cvc: {
                validators: {
                    cvv: {
                        creditCardField: 'card',
                        message: 'The CVC / security number is not valid'
                    },
                    notEmpty: {
                        message: 'The CVC / security number is required'
                    },
                }
            },
              email: {
                validators: {
                  emailAddress: {
                        message: 'The value is not a valid email address'
                    }
                }
            },
        }
    });

    $('.giveFormNoCC').bootstrapValidator({
        message: 'This value is not valid',
        feedbackIcons: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
            amount: {
                message: 'You must provide a gift amount.',
                validators: {
                    greaterThan: {
                        inclusive: true,
                        value: 3,
                        message: 'Your tithe must be at least $3.'
                    },
                    notEmpty: {
                        message: 'You must select a donation amount.'
                    },
                }
            },
            card_select: {
                message: 'You must select a credit card.',
                validators: {
                    notEmpty: {
                        message: 'The credit card number is required'
                    }
                }
            },
        }
    });

    $('.inputAmount').hide();

if(this.data.code && this.data.code.Goal_Donation)
{
    var start = 0;
	var goal = this.data.code.Goal_Donation;
	var current = this.data.titheTotalGive;

    var percent = Math.round( 100 * (( current - start ) / ( goal - start )) );

    if ( percent == 100 && current != goal ) {
			percent = 99;
		}
		if ( percent > 100 ) {
			percent = 100;
		}
		if ( percent < 0 ) {
			percent = 0;
		}

		if ( percent >= 100 ) {
			tooltip = '$'+current + " - goal achieved!";
		}
		else {
			tooltip = '$'+current + " / " + percent + "% towards goal";
		}

var html = '<div class="dollartimes-pb" style="font-family: arial; width: 300px; box-sizing: border-box; clear:both;">'+
'<div class="dollartimes-pb-title" style="font-size:16px; overflow: hidden;">Total Donations to campaign</div>'+
	'<div class="dollartimes-pb-title" style="font-size:12px; overflow: hidden;">'+tooltip+'</div>'+
	'<div><div class="dollartimes-pb-frame" title="'+tooltip+'" style="border-radius: 5px; background-color: #ffffff;padding: 0px;border: 1px solid #000; height: 30px; margin: 2px 0 1px;">'+
			'<div class="dollartimes-pb-fill" style="width:'+percent+'%; height: 100%; margin-top: 0px; background: repeating-linear-gradient(-45deg, rgba(156,28,90,1), rgba(156,28,90,1) 8px, rgba(156,28,90,0.8) 8px, rgba(156,28,90,0.8) 16px);">&nbsp;</div></div>'+
            '<span class="dollartimes-pb-caption" style="float: left; font-size: 12px;">$'+start+'</span>'+
		'<span class="dollartimes-pb-caption" style="float: right; font-size: 12px;">$'+goal+'</span></div>'+
	'<div style="clear: both;"></div><div style="margin: 2px 0 0 0; text-align: right;">'+
		'<a href="http://www.dollartimes.com/on-your-site/progress-bar.htm?name=My%20Savings&start=0&goal='+goal+'&current='+current+'&color=9c1c5a&unit=%24&unitposition=left&size=300" style="font-size: 10px;text-decoration:none;color:#bbb"></a></div></div>'

        $(".donationTracker").html(html);
}

}
