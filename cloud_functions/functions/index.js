'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.newOutfitNotification = functions.firestore
  .document('outfits/{outfitId}')
  .onCreate(async (snap, context) => {
    var newValue = snap.data();
    const affiliateId = newValue.affiliateId;

    // Get the list of device notification token.
    const getDeviceTokensPromise = admin.firestore().collection('users')
    .doc(`${affiliateId}`).get();

    const results = await Promise.all([getDeviceTokensPromise]);
    const affiliate = results[0].data();

    // Notification details.
    const payload = {
      notification: {
        title: 'Nuevo atuendo',
        body: 'Hay un nuevo atuendo disponible.'
      },
      data: {
        outfitId: context.params.outfitId
      }
    };

    // Send notifications to all tokens.
    let token = affiliate.notificationToken;
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
        title: 'Solicitud',
        body: `${affiliate.name} necesita un atuendo.`
      },
      data: {
        weather: newValue.weather,
        season: newValue.season,
        eventType: newValue.eventType,
        timeOfDay: newValue.timeOfDay,
        affiliateId: newValue.affiliateId
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