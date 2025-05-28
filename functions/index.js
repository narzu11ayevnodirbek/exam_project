/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const { onRequest } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });


logger.initializeApp();
exports.myFunction = { onRequest }.onDocumentCreated(
    "chat/{messageId}",
    (event) => {
        const data = event.data.data();
        return admin.messaging().send({
            notification: {
                title: data["username"],
                body: data["text"],
            },
            data: {
                click_action: "FLUTTER_NOTIFICATION_CLICK",
            },
            topic: "chat",
        });
    }
);