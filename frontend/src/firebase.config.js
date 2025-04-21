import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';

const firebaseConfig = {
    apiKey: "AIzaSyCTGBfBZrfWBFQJWc1fhMpCvKVZtzzh-OQ",
    authDomain: "aichatbot1-a2159.firebaseapp.com",
    projectId: "aichatbot1-a2159",
    storageBucket: "aichatbot1-a2159.appspot.com",
    messagingSenderId: "401898447850",
    appId: "1:401898447850:web:57f3c283f07aa2880b4893"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);