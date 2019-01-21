# Router.configure({
# 	layoutTemplate: 'newLayout',
# 	notFoundTemplate: 'notFound',
# 	loadingTemplate: 'splash',
# 	trackPageView: true
# });
Router.map ->
  # this.route('mobileHome', {
  # 	path: '/mobileHome',
  # 	layoutTemplate: false
  # });
  @route 'mobileSearch',
    path: '/mobileSearch'
    layoutTemplate: false
  return
