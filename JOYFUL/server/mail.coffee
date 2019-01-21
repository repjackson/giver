Future = Npm.require('fibers/future')
pdf = Npm.require('html-pdf')
Meteor.methods
    'cleanMail': ->
        users = Meteor.users.find()
        emCount = 0
        userCount = 0
        _.each users.fetch(), (userData) ->
            newEmails = []
            userCount++
            _.each userData.emails, (userEmail) ->
                newEmails.push
                    address: userEmail.address.toLowerCase()
                    verified: userEmail.verified
                emCount++
                return
            console.log newEmails
            console.log userData.emails
            #Meteor.users.update({_id: userData._id},{$unset: { emails: null }});
            Meteor.users.update { _id: userData._id }, $set: emails: newEmails
            return
        console.log emCount + ' Emails Updated'
        console.log userCount + ' Users Updated'


    'sendEmail': (userInfo) ->
        SSR.compileTemplate 'htmlEmail', Assets.getText('Signup_template.html')
        Email.send
            to: userInfo.email
            from: 'info@joyful-giver.com'
            subject: 'Joyful Giver registration greetings'
            html: SSR.render('htmlEmail', userInfo)


    'sendGiverEmail': (userInfo) ->
        SSR.compileTemplate 'htmlEmail', Assets.getText('GiverSignup_template.html')
        Email.send
            to: userInfo.email
            from: 'info@joyful-giver.com'
            subject: 'Joyful Giver registration greetings'
            html: SSR.render('htmlEmail', userInfo)


    'sendGiveReciept': (emailId, TitheId) ->
        `var attachments`
        #console.log('IMAGE PDF', img);
        #//console.log('chegou aqui', image.copies.images.key);
        TithDetail = Tithes.findOne('_id': TitheId)
        churchDet = Meteor.users.findOne('_id': TithDetail.church)
        user = Meteor.users.findOne(_id: TithDetail.userID)
        arrayPdfBuffer = []
        attachments = []
        fut = undefined
        pdfName = 'giveReceipt.pdf'
        #console.log("Before compileTemplate");
        SSR.compileTemplate 'layout', Assets.getText('Give_reciept.html')
        #console.log("Before Template.layout.helpers");
        Template.layout.helpers
            'church': ->
                churchDet
            'date': ->
                moment.unix(TithDetail.date).format 'MM/DD/YYYY, h:mm a'
            'amount': ->
                numeral(TithDetail.amount / 100).format '$0,0.00'
            'giver': ->
                if !user
                    return emailId
                if user.profile.name
                    user.profile.name
                else
                    user.profile.firstname + ' ' + user.profile.lastname
            'tithe': ->
                TithDetail
        fut = new Future
        html = SSR.render('layout')
        #console.log("After SSR.render");
        pdf.create(html).toBuffer (err, buffer) ->
            fut.return buffer
            return
        #console.log("After pdf.create");
        buffer = fut.wait()
        #console.log("After buffer");
        arrayPdfBuffer.push buffer
        #console.log("After arrayPdfBuffer");
        i = 0
        while i < arrayPdfBuffer.length
            attachments.push
                filename: pdfName
                content: arrayPdfBuffer[i]
            i++
        if !emailId
            emailId = user.emails[0].address
        else if emailId and user
            emailId = emailId + ',' + user.emails[0].address
        attachments = attachments
        data =
            to: emailId
            from: 'info@joyful-giver.com'
            subject: 'Joyful Giver give reciept'
            html: html
            attachments: attachments
        #return arrayPdfBuffer[0].toString('base64');
        Email.send data, (err) ->
            if err
                throw Meteor.error(err)
            else
                return true
            return
        true

    'bulkMailSendMethod': (emailObj) ->
        SSR.compileTemplate 'emailText', emailObj.html
        emailObj.html = SSR.render('emailText')
        emailObj['from'] = 'info@joyful-giver.com'
        Email.send emailObj

Accounts.urls.resetPassword = (token) ->
    Meteor.absoluteUrl 'reset-password/' + token
