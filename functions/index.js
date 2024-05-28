const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.resetDailyTotals = functions.pubsub.schedule('0 0 * * *') // This runs at midnight every day
    .timeZone('America/Los_Angeles') // Adjust timezone as needed
    .onRun(async (context) => {
        const usersRef = admin.firestore().collection('users');
        const batch = admin.firestore().batch();

        const snapshot = await usersRef.get();
        snapshot.forEach(doc => {
            batch.update(doc.ref, {
                todayProtein: 0,
                todayCalories: 0,
                lastProteinUpdate: admin.firestore.FieldValue.serverTimestamp(),
                lastCaloriesUpdate: admin.firestore.FieldValue.serverTimestamp()
            });
        });

        return batch.commit().then(() => {
            console.log('Daily totals reset successfully.');
        }).catch(error => {
            console.error('Failed to reset daily totals:', error);
        });
    });
