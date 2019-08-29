'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.sendOutfitRequestNotification = functions.firestore
  .document('outfitRequests/{affiliateId}')
  .onCreate(async (snap, context) => {
    var newValue = snap.data();

    const affiliateId = newValue.affiliateId;
    const assistantId = newValue.assistantId;

    // Get the list of device notification token.
    const getDeviceTokensPromise = admin.firestore().collection('users')
    .doc(`${assistantId}`).get();

    // Get the affiliate profile.
    const getAffiliateProfilePromise = admin.firestore().collection('affiliates')
    .doc(`${affiliateId}`).get();

    const results = await Promise.all([getDeviceTokensPromise, getAffiliateProfilePromise]);
    const assistant = results[0].data();
    const affiliate = results[1].data();

    // Notification details.
    const payload = {
      notification: {
        title: 'Solicitud de atuendo',
        body: `${affiliate.name} necesita un atuendo.`
      }
    };

    // Send notifications to all tokens.
    let token = assistant.notificationToken;
    const response = await admin.messaging().sendToDevice(token, payload);
    
    // For each message check if there was an error.
    const tokensToRemove = [];
    response.results.forEach((result, index) => {
      const error = result.error;
      if (error) {
        console.error('Failure sending notification to', token, error);
      }
    });
    return Promise.all(tokensToRemove);
  });