// var TEMP_LIFETIME, connect, database, dbConn, exec, filePrefix, fs, host, mongodbUri, port, rmDir, staticDir, staticEndpoint, targz, temp;

// fs = Npm.require('fs');

// exec = Npm.require('child_process').exec;

// mongodbUri = Npm.require('mongodb-uri');

// targz = Npm.require('tar.gz2');

// connect = Npm.require("connect");

// temp = Npm.require('temp');

// TEMP_LIFETIME = 1 * 60 * 60 * 1000;

// staticDir = process.env.PWD + "/backupDB_MongoDump";
//  //staticDir = "/Volumes/Drive D/screenshots/backuprestore_tmp";

// staticEndpoint = "/download-backup";

// dbConn = mongodbUri.parse(process.env.MONGO_URL);

// port = dbConn.hosts[0].port;

// host = dbConn.hosts[0].host;

// database = dbConn.database;

// // RoutePolicy.declare(staticEndpoint, "network");
// // console.log('connect',connect)
// // WebApp.connectHandlers.use(staticEndpoint, connect["static"](staticDir));

// filePrefix = function() {
//   var now;
//   now = new Date();
//   return "meteor-mongodump-" + (now.getFullYear()) + "-" + (now.getMonth() + 1) + "-" + (now.getDate()) + "-";
// };

// Meteor.generateMongoDump = function(callback) {
//   return temp.mkdir({}, function(err, tempDir) {
//     var dumpCommand, outPath, tempFile;
//     if (err != null) {
//       callback(err);
//     }
//     tempFile = temp.path({
//       dir: staticDir,
//       prefix: filePrefix(),
//       suffix: ".tar.gz"
//     });
//     outPath = tempDir;
//     dumpCommand = "mongodump --db " + database + " --host " + host + " --port " + port + " --out " + outPath;
//     return exec(dumpCommand, function(err, res) {
//       return new targz().compress(tempDir + "/" + database, tempFile, function(err) {
//         return callback(err, tempFile);
//       });
//     });
//   });
// };

// // Meteor.parseMongoDump = function(tmpRestoreFile, callback) {
// //   return temp.mkdir({}, function(err, tempDir) {
// //     return new targz().extract(tmpRestoreFile, tempDir, function(e, location) {
// //       var restoreCommand;
// //       restoreCommand = "mongorestore --drop --db " + database + " --host " + host + " --port " + port + " " + tempDir + "/" + database + ";";
// //       return exec(restoreCommand, function(err, res) {
// //         if (callback != null) {
// //           return callback(err, res);
// //         }
// //       });
// //     });
// //   });
// // };

// Meteor.methods({
//   'downloadBackup': function() {
//     var file, filePath, filePathArr;
//     filePath = Meteor.wrapAsync(Meteor.generateMongoDump)();
//     filePathArr = filePath.split('/');
//     file = filePathArr[filePathArr.length - 1];
//     // Meteor.setTimeout(function() {
//     //   return fs.unlinkSync(filePath);
//     // }, TEMP_LIFETIME);


//     return [{
//             fileName: file,
//             path: filePath
//             }];
//   },
// //   'uploadBackup': function(fileData) {
// //     var complete;
// //     complete = Meteor._wrapAsync(function(done) {
// //       var tmpRestoreFile;
// //       tmpRestoreFile = temp.path();
// //       return fs.writeFile(tmpRestoreFile, fileData, 'binary', function() {
// //         return Meteor.parseMongoDump(tmpRestoreFile, function() {
// //           return done(null, true);
// //         });
// //       });
// //     })();
// //     return complete;
// //   }
// });

// rmDir = function(dirPath) {
//   var e, filePath, files, i;
//   try {
//     files = fs.readdirSync(dirPath);
//   } catch (_error) {
//     e = _error;
//     return;
//   }
//   if (files.length > 0) {
//     i = 0;
//     while (i < files.length) {
//       filePath = dirPath + "/" + files[i];
//       if (fs.statSync(filePath).isFile()) {
//         fs.unlinkSync(filePath);
//       } else {
//         rmDir(filePath);
//       }
//       i++;
//     }
//   }
//   fs.rmdirSync(dirPath);
// };

// Meteor.startup(function() {
//   rmDir(staticDir);
//   // console.log(staticDir)
//   return fs.mkdirSync(staticDir);
// });
