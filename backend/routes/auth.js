import express from 'express';
import { adminAuth } from '../firebase.js';
import User from '../models/user.js';
import { verifyFirebaseToken } from '../middleware.js';

const router = express.Router();

// Route pour obtenir les informations utilisateur après authentification
router.get('/user', verifyFirebaseToken, async (req, res) => {
    try {
        // Trouver ou créer l'utilisateur dans MongoDB
        let user = await User.findOne({ firebaseUid: req.user.uid });

        if (!user) {
            // Si l'utilisateur n'existe pas encore dans notre base de données
            // On crée un nouvel enregistrement avec les informations de Firebase
            user = new User({
                firebaseUid: req.user.uid,
                displayName: req.user.name || '',
                email: req.user.email,
                image: req.user.picture || '',
                firstName: req.user.name ? req.user.name.split(' ')[0] : '',
                lastName: req.user.name ? req.user.name.split(' ').slice(1).join(' ') : ''
            });

            await user.save();
        }

        res.json({
            success: true,
            user: {
                id: user._id,
                firebaseUid: user.firebaseUid,
                displayName: user.displayName,
                email: user.email,
                image: user.image
            }
        });
    } catch (error) {
        console.error('Erreur lors de la récupération des données utilisateur:', error);
        res.status(500).json({ success: false, message: 'Erreur serveur' });
    }
});

router.get('/google', (req, res) => {
    res.status(400).json({ success: false, message: 'Cette route n\'est pas utilisée avec Firebase Auth' });
});

// Route pour vérifier si l'utilisateur est authentifié
router.get('/check', verifyFirebaseToken, (req, res) => {
    res.json({ authenticated: true });
});

export default router;