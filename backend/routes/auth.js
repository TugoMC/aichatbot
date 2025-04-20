import express from 'express';
import passport from 'passport';

const router = express.Router();

// Middleware pour vérifier si l'utilisateur est authentifié
const isAuthenticated = (req, res, next) => {
    if (req.isAuthenticated()) {
        return next();
    }
    res.status(401).json({ message: 'Non autorisé' });
};

// Route pour déclencher l'authentification Google
router.get('/google', passport.authenticate('google', { scope: ['profile', 'email'] }));

// Callback après authentification Google
router.get(
    '/google/callback',
    passport.authenticate('google', { failureRedirect: `${process.env.CLIENT_URL}/login` }),
    (req, res) => {
        // Rediriger vers la page de succès d'authentification avec l'ID utilisateur
        // Vous pourriez aussi générer un token JWT ici si vous préférez
        res.redirect(`${process.env.CLIENT_URL}/auth/success`);
    }
);

// Route pour obtenir l'utilisateur actuel
router.get('/user', isAuthenticated, (req, res) => {
    res.json({
        success: true,
        user: {
            id: req.user._id,
            displayName: req.user.displayName,
            email: req.user.email,
            image: req.user.image
        }
    });
});

// Route pour vérifier si l'utilisateur est authentifié
router.get('/check', (req, res) => {
    if (req.isAuthenticated()) {
        return res.json({ authenticated: true });
    }
    res.json({ authenticated: false });
});

// Route de déconnexion
router.get('/logout', (req, res, next) => {
    req.logout((err) => {
        if (err) { return next(err); }
        res.redirect(`${process.env.CLIENT_URL}/login`);
    });
});

export default router;