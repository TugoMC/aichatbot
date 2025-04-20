
import { createContext, useState, useEffect, useContext } from "react";
import axios from "axios";

const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
    const [user, setUser] = useState(null);
    const [loading, setLoading] = useState(true);

    // Fonction pour vérifier si l'utilisateur est authentifié
    const checkAuth = async () => {
        try {
            // Vérifier d'abord si l'utilisateur est authentifié en utilisant les cookies de session
            const authCheck = await axios.get("http://localhost:5000/api/auth/check", {
                withCredentials: true  // Important pour envoyer les cookies
            });

            if (authCheck.data.authenticated) {
                // Si authentifié, récupérer les données utilisateur
                const response = await axios.get("http://localhost:5000/api/auth/user", {
                    withCredentials: true
                });

                if (response.data.success) {
                    setUser(response.data.user);
                }
            }
        } catch (error) {
            console.error("Erreur de vérification d'authentification:", error);
        } finally {
            setLoading(false);
        }
    };

    // Fonction de déconnexion
    const logout = async () => {
        try {
            await axios.get("http://localhost:5000/api/auth/logout", {
                withCredentials: true
            });
            localStorage.removeItem("token");
            setUser(null);
        } catch (error) {
            console.error("Erreur de déconnexion:", error);
        }
    };

    useEffect(() => {
        checkAuth();
    }, []);

    return (
        <AuthContext.Provider value={{ user, loading, checkAuth, logout }}>
            {children}
        </AuthContext.Provider>
    );
};

export const useAuth = () => useContext(AuthContext);