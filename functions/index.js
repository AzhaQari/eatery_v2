const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.resetDailyMetrics = functions.pubsub.schedule('0 0 * * *')
  .timeZone('America/Los_Angeles') // Change this to your required timezone
  .onRun((context) => {
    return admin.firestore().collection('users').get()
      .then(snapshot => {
        const updates = {};
        snapshot.forEach(doc => {
          updates[`${doc.id}/todayProtein`] = 0;
          updates[`${doc.id}/todayCalories`] = 0;
        });
        return admin.firestore().batchCommit(updates);
      }).catch(error => console.log(error));
  });

exports.resetWeeklyMonthlyMetrics = functions.pubsub.schedule('every monday 00:00')
  .timeZone('America/Los_Angeles') // Adjust for weekly reset
  .onRun((context) => {
    return admin.firestore().collection('users').get()
      .then(snapshot => {
        const updates = {};
        snapshot.forEach(doc => {
          updates[`${doc.id}/thisWeeksSpend`] = 0;
          // Reset monthly on the first day of the month
          if (new Date().getDate() === 1) {
            updates[`${doc.id}/thisMonthsSpend`] = 0;
          }
        });
        return admin.firestore().batchCommit(updates);
      }).catch(error => console.log(error));
  });
