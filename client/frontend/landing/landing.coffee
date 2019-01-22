# churchCampaignDet = new ReactiveVar
# fundNeeded = new ReactiveVar
# appStatics = new ReactiveVar
# Template.front.onCreated ->
#     Meteor.callPromise('getChurchCampaignDetail', -1).then (res) ->
#         churchCampaignDet.set res
#     Meteor.callPromise('getChurchCampaignDetail', 1).then (res) ->
#         fundNeeded.set res
#     Meteor.callPromise('appStatics').then (res) ->
#         appStatics.set res
# Template.front.onRendered ->
#     `var owl`
#     `var owl`
#     'use strict'
#     menu_list = $('.menu-ul')
#     if menu_list.length
#         menu_list.on 'click', '.pagescroll', (event) ->
#             event.stopPropagation()
#             event.preventDefault()
#             hash_tag = $(this).attr('href')
#             if $(hash_tag).length and Meteor.absoluteUrl() == Router.current().url
#                 $('html, body').animate { scrollTop: $(hash_tag).offset().top - 50 }, 2000
#             else
#                 Router.go '/'
#                 Meteor.setTimeout (->
#                     $('html, body').animate { scrollTop: $(hash_tag).offset().top - 50 }, 2000
#                     return
#                 ), 1000
#             false
#     #RESPONSIVE MENU SHOW AND HIDE FUNCTION
#     collapse = $('.navbar-collapse')
#     menu = $('.navbar-default li a')
#     if menu.length
#         menu.on 'click', (event) ->
#             collapse.slideToggle()
#             return
#     $('.navbar-default .navbar-toggle').on 'click', (e) ->
#         collapse.slideToggle()
#         return
#     #Datepicker//
#     datepicker = $('.datepicker')
#     if datepicker.length
#         $('.datepicker').datepicker(
#             autoclose: true
#             format: 'dd/mm/yyyy'
#             todayHighlight: true).datepicker()
#     #GALLERY POPUP
#     gallery = $('.popup-gallery')
#     if gallery.length
#         $('.popup-gallery').magnificPopup
#             delegate: 'a'
#             type: 'image'
#             tLoading: 'Loading image #%curr%...'
#             mainClass: 'mfp-img-mobile'
#             gallery:
#                 enabled: true
#                 navigateByImgClick: true
#                 preload: [
#                     0
#                     1
#                 ]
#             image:
#                 tError: '<a href="%url%">The image #%curr%</a> could not be loaded.'
#                 titleSrc: (item) ->
#                     item.el.attr('title') + '<small>by Marsel Van Oosten</small>'
#     #ACCORDION
#     accordion = $('.accordion-row')
#     if accordion.length
#         accordion.each ->
#             all_panels = $(this).find('.accordion-ans').hide()
#             all_titles = $(this).find('.accordion-title')
#             $(this).find('.accordion-ans.active').slideDown()
#             all_titles.on 'click', ->
#                 acc_title = $(this)
#                 acc_inner = acc_title.next()
#                 if !acc_inner.hasClass('active')
#                     all_panels.removeClass('active').slideUp()
#                     acc_inner.addClass('active').slideDown()
#                     all_titles.removeClass 'active'
#                     acc_title.addClass 'active'
#                 else
#                     all_panels.removeClass('active').slideUp()
#                     all_titles.removeClass 'active'
#         $('.resort-accordion .col-md-6 .accordion-main:first-child .accordion-ans').css 'display', 'block'
#     #Get URL parameter

#     getUrlParameter = (sParam) ->
#         sPageURL = decodeURIComponent(window.location.search.substring(1))
#         sURLVariables = sPageURL.split('&')
#         sParameterName = undefined
#         i = undefined
#         i = 0
#         while i < sURLVariables.length
#             sParameterName = sURLVariables[i].split('=')
#             if sParameterName[0] == sParam
#                 return if sParameterName[1] == undefined then true else sParameterName[1]
#             i++
#     $('#owl-demo').owlCarousel
#         autoPlay: 4000
#         items: 1
#         itemsDesktop: [
#             1920
#             1
#         ]
#         itemsDesktopSmall: [
#             900
#             1
#         ]
#         itemsTablet: [
#             600
#             1
#         ]
#         itemsMobile: [
#             380
#             1
#         ]
#     owl = $('.testimonial')
#     owl.owlCarousel
#         autoPlay: 4000
#         itemsCustom: [
#             [
#                 0
#                 1
#             ]
#             [
#                 450
#                 1
#             ]
#             [
#                 600
#                 1
#             ]
#             [
#                 700
#                 2
#             ]
#             [
#                 1000
#                 2
#             ]
#             [
#                 1200
#                 3
#             ]
#             [
#                 1400
#                 3
#             ]
#             [
#                 1600
#                 3
#             ]
#         ]
#     # Custom Navigation Events
#     $('.next').click ->
#         owl.trigger 'owl.next'
#     $('.prev').click ->
#         owl.trigger 'owl.prev'
#     $('.play').click ->
#         owl.trigger 'owl.play', 1000
#         #owl.play event accept autoPlay speed as second parameter
#     $('.stop').click ->
#         owl.trigger 'owl.stop'
#     owl = $('.client-logo')
#     owl.owlCarousel
#         loop: true
#         responsiveClass: true
#         center: true
#         smartSpeed: 2500
#         autoPlay: true
#         autoplayTimeout: 5000
#         lazyLoad: true
#         itemsCustom: [
#             [
#                 0
#                 1
#             ]
#             [
#                 450
#                 2
#             ]
#             [
#                 600
#                 3
#             ]
#             [
#                 700
#                 3
#             ]
#             [
#                 992
#                 4
#             ]
#             [
#                 1000
#                 4
#             ]
#             [
#                 1200
#                 5
#             ]
#             [
#                 1400
#                 5
#             ]
#             [
#                 1600
#                 5
#             ]
#         ]
#     # Custom Navigation Events
#     $('.next').click ->
#         owl.trigger 'owl.next'
#     $('.prev').click ->
#         owl.trigger 'owl.prev'
#     $('.play').click ->
#         owl.trigger 'owl.play', 1000
#         #owl.play event accept autoPlay speed as second parameter
#     $('.stop').click ->
#         owl.trigger 'owl.stop'
#     owl = $('.team-carousel')
#     owl.owlCarousel
#         autoPlay: 5000
#         navigation: true
#         navigationText: [
#             '<div class=\'left carousel-control\'></div>'
#             '<div class=\'right carousel-control\'></div>'
#         ]
#         itemsCustom: [
#             [
#                 0
#                 1
#             ]
#             [
#                 450
#                 1
#             ]
#             [
#                 600
#                 1
#             ]
#             [
#                 700
#                 1
#             ]
#             [
#                 1000
#                 2
#             ]
#             [
#                 1200
#                 2
#             ]
#             [
#                 1400
#                 2
#             ]
#             [
#                 1600
#                 2
#             ]
#         ]
#     # Custom Navigation Events
#     $('.next').click ->
#         owl.trigger 'owl.next'
#     $('.prev').click ->
#         owl.trigger 'owl.prev'
#     $('.play').click ->
#         owl.trigger 'owl.play', 4500
#         #owl.play event accept autoPlay speed as second parameter
#     $('.stop').click ->
#         owl.trigger 'owl.stop'
#     # return false;
#     # End of use strict
#     Meteor.Device.detectDevice()
#     # $('body').addClass('landing-page');
#     #
#     # $('body').scrollspy({
#     #     target: '.navbar-fixed-top',
#     #     offset: 80
#     # });
#     # $('#requestDemoForm').bootstrapValidator
#         message: 'This value is not valid'
#         fields:
#             phoneNo:
#                 message: 'You must provide a phone number.'
#                 validators:
#                     notEmpty: message: 'Phone Number is mandatory'
#                     phone:
#                         country: 'US'
#                         message: 'The value is not valid US phone number'
#             firstName:
#                 message: 'You must provide an account holder firstname.'
#                 validators: notEmpty: message: 'First Name is mandatory'
#             lastName:
#                 message: 'You must provide an account holder lastname.'
#                 validators: notEmpty: message: 'Last Name is mandatory'
#             emailId:
#                 message: 'You must provide an email.'
#                 validators:
#                     notEmpty: message: 'Email is mandatory'
#                     emailAddress: message: 'The value is not a valid email address'
#     # $('.datetimepicker').datetimepicker minDate: new Date
#     Meteor.setTimeout (->
#         `var owl`
#         $('.demo-pie-1').pieChart
#             barColor: '#b62169'
#             trackColor: '#bbbbbb'
#             lineCap: 'round'
#             lineWidth: 16
#             onStep: (from, to, percent) ->
#                 $(@element).find('.pie-value').text Math.round(percent) + '%'
#                 return
#         owl = $('.fund-slider')
#         owl.owlCarousel
#             autoPlay: 5000
#             navigation: true
#             navigationText: [
#                 '<div class=\'icon-left\'></div>'
#                 '<div class=\'icon-right\'></div>'
#             ]
#             itemsCustom: [
#                 [
#                     0
#                     1
#                 ]
#                 [
#                     450
#                     2
#                 ]
#                 [
#                     600
#                     2
#                 ]
#                 [
#                     700
#                     3
#                 ]
#                 [
#                     1000
#                     3
#                 ]
#                 [
#                     1200
#                     3
#                 ]
#                 [
#                     1400
#                     3
#                 ]
#                 [
#                     1600
#                     3
#                 ]
#             ]
#         # Custom Navigation Events
#         $('.next').click ->
#             owl.trigger 'owl.next'
#             return
#         $('.prev').click ->
#             owl.trigger 'owl.prev'
#             return
#         $('.play').click ->
#             owl.trigger 'owl.play', 4500
#             #owl.play event accept autoPlay speed as second parameter
#             return
#         $('.stop').click ->
#             owl.trigger 'owl.stop'
#             return
#         #COUNTER
#         counter = $('.count')
#         if counter.length
#             counter.counterUp
#                 delay: 10
#                 time: 1000
#         return
#     ), 3000
#     return
# Template.front.onDestroyed ->
#     $('body').removeClass 'landing-page'
#     return
# Template.front.helpers
#     todayDate: ->
#         moment().format 'MM/DD/YYYY'
#     'androidOS': ->
#         if Meteor.isCordova
#             devicePlatform = device.platform
#             console.log 'mobile platform: ', devicePlatform
#             if devicePlatform == 'iOS'
#                 return false
#             else
#                 # This is an android device!!!
#                 return true
#         false
#     'totalRaised': (raised) ->
#         numeral(raised / 100).format '$0,0'
#     churchCampaignDet: ->
#         churchCampaignDet.get()
#     percentDonation: (raised, goal) ->
#         start = 0
#         current = numeral(raised / 100)
#         percent = Math.round(100 * (current - start) / (goal - start))
#         if percent == 100 and current != goal
#             percent = 99
#         if percent > 100
#             percent = 100
#         if percent < 0
#             percent = 0
#         percent
#     fundNeeded: ->
#         fundNeeded.get()
#     appstatics: ->
#         appStatics.get()
# Template.front.events
#     'click #demoModal': (e, t) ->
#         e.preventDefault()
#         $('#demoModalpopup').modal 'show'
#     'click #generalPlan': (e, t) ->
#         Router.go 'register'
#     'click #generalPlan29': (e, t) ->
#         Router.go 'register'


Template.slider.onRendered ->
    Meteor.setTimeout ->
        $('.shape').shape();
    , 1000


Template.slider.events
    'click .next': ->
        $('.shape').shape('flip right');
    'click .back': ->
        $('.shape').shape('flip back');


