Template.smsloginup.events({
    'click #register': function(event,template){
        $('#giverForm').data('bootstrapValidator').validate();
        if($('#giverForm').data('bootstrapValidator').isValid()){
            var phone = Phoneformat.formatE164('US', $('#phone').val());
            var email =  $('#email').val().toLowerCase();
            var password = $('#password').val()

            Meteor.call('process_SMS_registration',phone,email,password,function(error,result){
                console.log(error); console.log(result)
                if(result.error){
                    if(result.bootbox){
                        bootbox.alert(result.content);
                    }
                }else{
                    if(result.login){
                        Meteor.loginWithPassword(email,password,function(error,result){
                            if(error){
                                console.log(error)
                                bootbox.alert(error.message);
                            }else{
                                Session.set('phone',phone);
                                Session.set('code',template.data.code);
                                Router.go('/SMS/phone')
                            }
                        })
                    }
                    if(result.continue){
                        var options = {
                            email: email,
                            password: password,
                            profile: {
                                phone: phone
                            }
                        }
                        Accounts.createUser(options, function(error,success){
                            if(error){
                                console.log(error)
                                bootbox.alert(error.message);
                            }else{
                                Meteor.call('STRIPE_create_customer',Meteor.userId(),'both');
                                Session.set('phone',phone);
                                Session.set('code',template.data.code);
                                Router.go('/SMS/phone')
                            }
                        })
                    }
                }
            })

        }
    }
});
Template.smsloginup.rendered = function(){
    $('#giverForm').bootstrapValidator({
        message: 'This value is not valid',
        feedbackIcons: {
            valid: 'glyphicon glyphicon-ok',
            invalid: 'glyphicon glyphicon-remove',
            validating: 'glyphicon glyphicon-refresh'
        },
        fields: {
            email: {
                message: 'You must provide an email.',
                validators: {
                    notEmpty: {
                        message: 'Email is mandatory'
                    },
                    emailAddress: {
                        message: 'The value is not a valid email address'
                    }
                }
            },
            phone: {
                message: 'You must provide a phone number.',
                validators: {
                    notEmpty: {
                        message: 'Phone is mandatory'
                    },
                    phone: {
                        country: 'US',
                        message: 'The value is not valid US phone number'
                    }
                }
            },
            password: {
                message: 'You must provide a password.',
                validators: {
                    notEmpty: {
                        message: 'Password is mandatory'
                    }
                }
            }
        }
    });
}
