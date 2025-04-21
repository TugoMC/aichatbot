import { adminAuth } from './firebase.js';

// Middleware pour vérifier le token Firebase JWT
export const verifyFirebaseToken = async (req, res, next) => {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return res.status(401).json({ message: 'Non autorisé: Token manquant' });
    }

    const token = authHeader.split('Bearer ')[1];

    try {
        const decodedToken = await adminAuth.verifyIdToken(token);
        req.user = decodedToken;
        next();
    } catch (error) {
        console.error('Erreur de vérification du token:', error);
        res.status(401).json({ message: 'Non autorisé: Token invalide' });
    }
};