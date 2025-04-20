import { useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";

export default function AuthSuccess() {
    const navigate = useNavigate();
    const { checkAuth } = useAuth();

    useEffect(() => {
        // Vérifier l'authentification et rediriger si réussi
        checkAuth().then(() => {
            navigate("/");
        });
    }, [navigate, checkAuth]);

    return (
        <div className="flex items-center justify-center min-h-screen bg-white dark:bg-gray-900">
            <div className="text-center">
                <div className="w-12 h-12 border-4 border-blue-600 dark:border-blue-500 border-t-transparent border-solid rounded-full animate-spin mx-auto"></div>
                <p className="mt-3 text-lg text-gray-800 dark:text-gray-200">Authentification réussie, redirection en cours...</p>
            </div>
        </div>
    );
}