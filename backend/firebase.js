import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import admin from 'firebase-admin';
import dotenv from 'dotenv';

dotenv.config();

// Configuration client Firebase
const firebaseConfig = {
    apiKey: process.env.FIREBASE_API_KEY,
    authDomain: process.env.FIREBASE_AUTH_DOMAIN,
    projectId: process.env.FIREBASE_PROJECT_ID,
    storageBucket: process.env.FIREBASE_STORAGE_BUCKET,
    messagingSenderId: process.env.FIREBASE_MESSAGING_SENDER_ID,
    appId: process.env.FIREBASE_APP_ID
};

// Initialisation Firebase pour le client
const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);

// Initialisation Firebase Admin SDK (pour le backend)
admin.initializeApp({
    credential: admin.credential.cert({
        projectId: process.env.FIREBASE_PROJECT_ID,
        clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
        privateKey: process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, '\n')
    }),
    databaseURL: process.env.FIREBASE_DATABASE_URL
});

export const adminAuth = admin.auth();
export const adminFirestore = admin.firestore();