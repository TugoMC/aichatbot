import { createContext, useState, useEffect, useContext } from "react";
import { getAuth, signInWithPopup, GoogleAuthProvider, signOut, onAuthStateChanged } from "firebase/auth";
import axios from "axios";
import { auth } from '../firebase.config';

const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
    const [user, setUser] = useState(null);
    const [loading, setLoading] = useState(true);
    const auth = getAuth();

    // Fonction pour s'authentifier avec Google
    const loginWithGoogle = async () => {
        try {
            const provider = new GoogleAuthProvider();
            const result = await signInWithPopup(auth, provider);

            // Récupérer le token Firebase
            const token = await result.user.getIdToken();

            // Stocker le token pour les requêtes API
            localStorage.setItem("token", token);

            // Mettre à jour l'état utilisateur
            await fetchUserData(token);
        } catch (error) {
            console.error("Erreur d'authentification Google:", error);
        }
    };

    // Récupérer les données utilisateur depuis votre backend
    const fetchUserData = async (token) => {
        try {
            const response = await axios.get("http://localhost:5000/api/auth/user", {
                headers: {
                    Authorization: `Bearer ${token}`
                }
            });

            if (response.data.success) {
                setUser(response.data.user);
            }
        } catch (error) {
            console.error("Erreur de récupération des données utilisateur:", error);
        }
    };

    // Fonction de déconnexion
    const logout = async () => {
        try {
            await signOut(auth);
            localStorage.removeItem("token");
            setUser(null);
        } catch (error) {
            console.error("Erreur de déconnexion:", error);
        }
    };

    useEffect(() => {
        const unsubscribe = onAuthStateChanged(auth, async (firebaseUser) => {
            if (firebaseUser) {
                // L'utilisateur est connecté
                const token = await firebaseUser.getIdToken();
                localStorage.setItem("token", token);
                await fetchUserData(token);
            } else {
                // L'utilisateur est déconnecté
                setUser(null);
            }
            setLoading(false);
        });

        // Nettoyer l'abonnement lors du démontage du composant
        return () => unsubscribe();
    }, [auth]);

    return (
        <AuthContext.Provider value={{ user, loading, loginWithGoogle, logout }}>
            {children}
        </AuthContext.Provider>
    );
};

export const useAuth = () => useContext(AuthContext);