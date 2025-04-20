
import { useAuth } from "../context/AuthContext";
import { Navigate } from "react-router-dom";

export default function Dashboard() {
    const { user, loading, logout } = useAuth();

    if (loading) {
        return (
            <div className="flex items-center justify-center min-h-screen">
                <div className="text-center">
                    <div className="w-12 h-12 border-4 border-blue-600 border-t-transparent border-solid rounded-full animate-spin mx-auto"></div>
                    <p className="mt-3 text-lg">Chargement...</p>
                </div>
            </div>
        );
    }

    if (!user) {
        return <Navigate to="/" />;
    }

    return (
        <div className="container mx-auto px-4 py-12">
            <div className="max-w-4xl mx-auto">
                <div className="bg-white p-6 rounded-lg shadow-md mb-6">
                    <div className="flex items-center space-x-4 mb-6">
                        {user.image && (
                            <img
                                src={user.image}
                                alt={user.displayName}
                                className="w-16 h-16 rounded-full"
                            />
                        )}
                        <div>
                            <h2 className="text-2xl font-semibold">
                                Tableau de bord de {user.displayName}
                            </h2>
                            <p className="text-gray-600">{user.email}</p>
                        </div>
                    </div>

                    <button
                        onClick={logout}
                        className="bg-red-600 text-white px-4 py-2 rounded-md hover:bg-red-700 transition duration-300"
                    >
                        Se déconnecter
                    </button>
                </div>

                <div className="bg-white p-6 rounded-lg shadow-md">
                    <h3 className="text-xl font-semibold mb-4">Contenu protégé</h3>
                    <p className="text-gray-700">
                        Ce contenu n'est visible que par les utilisateurs authentifiés.
                        Vous pouvez ajouter ici toutes les fonctionnalités nécessitant une authentification.
                    </p>
                </div>
            </div>
        </div>
    );
}