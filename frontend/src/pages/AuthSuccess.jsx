import { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

export default function AuthSuccess() {
    const navigate = useNavigate();
    const { user, loading } = useAuth();

    useEffect(() => {
        if (!loading) {
            if (user) {
                // Si l'utilisateur est connecté, rediriger vers la page d'accueil
                navigate('/');
            } else {
                // Si l'authentification a échoué, rediriger vers la page d'accueil
                navigate('/');
            }
        }
    }, [user, loading, navigate]);

    return (
        <div className="flex justify-center items-center h-screen">
            <p>Authentification en cours...</p>
        </div>
    );
}