import express from 'express';
import mongoose from 'mongoose';
import cors from 'cors';
import dotenv from 'dotenv';
import authRoutes from './routes/auth.js';
// Import de Firebase au lieu de Passport
import './firebase.js';

dotenv.config();

// Connexion à MongoDB
mongoose.connect(process.env.MONGO_URI)
    .then(() => console.log('Connecté à MongoDB'))
    .catch(err => console.error('Erreur de connexion MongoDB:', err));

const app = express();

// Middlewares
app.use(express.json());
app.use(cors({
    origin: process.env.CLIENT_URL,
    credentials: true
}));

// Routes
app.use('/api/auth', authRoutes);

// Route de test
app.get('/', (req, res) => {
    res.send('API fonctionne !');
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`Serveur démarré sur le port ${PORT}`);
});