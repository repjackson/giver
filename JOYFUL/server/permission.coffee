Tithes.permit([
  'insert'
  'update'
  'remove'
]).apply()
TithePlans.permit([
  'insert'
  'update'
]).ifLoggedIn().apply()
MyChurches.permit([
  'insert'
  'update'
  'remove'
]).ifLoggedIn().apply()
MyChurches.permit([
  'insert'
  'update'
  'remove'
]).ifLoggedIn().apply()
ChurchCodes.permit([ 'update' ]).ifLoggedIn().apply()
AppSettings.permit([ 'update' ]).ifHasRole('admin').apply()
MyCards.permit([
  'insert'
  'update'
  'remove'
]).ifLoggedIn().apply()



Docs.allow
    insert: (userId, doc) -> doc.author_id is userId
    update: (userId, doc) -> userId
    remove: (userId, doc) -> doc.author_id is userId
