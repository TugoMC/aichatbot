
import { Strategy as GoogleStrategy } from 'passport-google-oauth20';
import User from './models/user.js';

export default function (passport) {
    passport.use(
        new GoogleStrategy(
            {
                clientID: process.env.GOOGLE_CLIENT_ID,
                clientSecret: process.env.GOOGLE_CLIENT_SECRET,
                callbackURL: '/api/auth/google/callback',
                scope: ['profile', 'email']
            },
            async (accessToken, refreshToken, profile, done) => {
                try {
                    // Vérifier si l'utilisateur existe
                    let user = await User.findOne({ googleId: profile.id });

                    if (user) {
                        return done(null, user);
                    }

                    // Créer un nouveau utilisateur
                    user = new User({
                        googleId: profile.id,
                        displayName: profile.displayName,
                        firstName: profile.name?.givenName || '',
                        lastName: profile.name?.familyName || '',
                        email: profile.emails[0].value,
                        image: profile.photos[0].value
                    });

                    await user.save();
                    return done(null, user);
                } catch (err) {
                    console.error(err);
                    return done(err, null);
                }
            }
        )
    );

    passport.serializeUser((user, done) => {
        done(null, user.id);
    });

    passport.deserializeUser(async (id, done) => {
        try {
            const user = await User.findById(id);
            done(null, user);
        } catch (err) {
            done(err, null);
        }
    });
};