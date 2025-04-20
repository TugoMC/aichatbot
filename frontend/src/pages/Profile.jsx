import { useState } from "react";
import { useAuth } from "../context/AuthContext";

export default function Profile() {
    const { user } = useAuth();
    const [isEditing, setIsEditing] = useState(false);
    const [profileData, setProfileData] = useState({
        displayName: user?.displayName || "",
        bio: "Chef de projet digital passionné par l'UI/UX et l'intelligence artificielle.",
        location: "Lyon, France",
        website: "www.monsite.com",
        preferences: {
            language: "Français",
            theme: "Sombre"
        }
    });

    // Gérer les changements dans le formulaire
    const handleChange = (e) => {
        const { name, value } = e.target;

        if (name.includes('.')) {
            const [parent, child] = name.split('.');
            setProfileData({
                ...profileData,
                [parent]: {
                    ...profileData[parent],
                    [child]: value
                }
            });
        } else {
            setProfileData({
                ...profileData,
                [name]: value
            });
        }
    };

    // Sauvegarder les modifications
    const saveChanges = () => {
        // Ici vous ajouteriez la logique pour sauvegarder les données
        // vers votre backend ou service d'authentification
        setIsEditing(false);
    };

    if (!user) {
        return (
            <div className="flex flex-col h-full bg-white dark:bg-gray-900 text-gray-800 dark:text-white pt-10">
                <div className="max-w-3xl mx-auto w-full px-4 md:px-6">
                    <div className="flex flex-col items-center justify-center h-full text-center text-gray-500 dark:text-gray-400 p-6">
                        <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" className="mb-3">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                            <circle cx="9" cy="7" r="4"></circle>
                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                            <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                        </svg>
                        <p>Veuillez vous connecter pour accéder à votre profil</p>
                    </div>
                </div>
            </div>
        );
    }

    return (
        <div className="flex flex-col h-full bg-white dark:bg-gray-900 text-gray-800 dark:text-white pt-10">
            {/* Container avec largeur max et centrage */}
            <div className="max-w-3xl mx-auto w-full px-4 md:px-6">
                <div className="flex-1 overflow-y-auto">
                    {/* En-tête du profil */}
                    <div className="bg-white dark:bg-gray-800 rounded-lg shadow-sm border border-gray-200 dark:border-gray-700 p-6 mb-6">
                        <div className="flex flex-col md:flex-row md:items-center">
                            <div className="flex flex-col items-center md:items-start md:flex-row md:space-x-6">
                                {/* Photo de profil */}
                                {user.image ? (
                                    <img
                                        src={user.image}
                                        alt="Photo de profil"
                                        className="w-24 h-24 rounded-full mb-4 md:mb-0"
                                    />
                                ) : (
                                    <div className="flex items-center justify-center w-24 h-24 rounded-full bg-purple-100 dark:bg-purple-900 text-purple-700 dark:text-purple-300 text-3xl font-medium mb-4 md:mb-0">
                                        {user.displayName?.charAt(0).toUpperCase() || "U"}
                                    </div>
                                )}

                                {/* Infos principales */}
                                <div className="flex flex-col justify-center items-center md:items-start w-full md:w-auto">
                                    <h2 className="text-2xl font-semibold mb-2">{isEditing ? (
                                        <input
                                            type="text"
                                            name="displayName"
                                            value={profileData.displayName}
                                            onChange={handleChange}
                                            className="w-full bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-purple-500 px-3 py-1 text-lg"
                                        />
                                    ) : (
                                        profileData.displayName
                                    )}</h2>
                                    <p className="text-lg text-gray-600 dark:text-gray-300 font-medium">{user.email}</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    {/* Informations détaillées */}
                    <div className="bg-white dark:bg-gray-800 rounded-lg shadow-sm border border-gray-200 dark:border-gray-700 p-6 mb-6">
                        <h3 className="text-lg font-medium mb-4">Informations personnelles</h3>

                        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <p className="text-sm text-gray-500 dark:text-gray-400 mb-1">Localisation</p>
                                {isEditing ? (
                                    <input
                                        type="text"
                                        name="location"
                                        value={profileData.location}
                                        onChange={handleChange}
                                        className="w-full bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-purple-500 px-3 py-1"
                                    />
                                ) : (
                                    <p className="font-medium">{profileData.location}</p>
                                )}
                            </div>

                            <div>
                                <p className="text-sm text-gray-500 dark:text-gray-400 mb-1">Méthode de connexion</p>
                                <p className="font-medium flex items-center">
                                    <svg className="w-4 h-4 mr-1" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                        <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4" />
                                        <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853" />
                                        <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05" />
                                        <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335" />
                                    </svg>
                                    Google
                                </p>
                            </div>

                            <div>
                                <p className="text-sm text-gray-500 dark:text-gray-400 mb-1">Date d'inscription</p>
                                <p className="font-medium">15 avril 2023</p>
                            </div>
                        </div>
                    </div>

                    {/* Préférences */}
                    <div className="bg-white dark:bg-gray-800 rounded-lg shadow-sm border border-gray-200 dark:border-gray-700 p-6 mb-6">
                        <h3 className="text-lg font-medium mb-4">Préférences</h3>

                        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <p className="text-sm text-gray-500 dark:text-gray-400 mb-1">Langue préférée</p>
                                {isEditing ? (
                                    <select
                                        name="preferences.language"
                                        value={profileData.preferences.language}
                                        onChange={handleChange}
                                        className="w-full bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-purple-500 px-3 py-1"
                                    >
                                        <option value="Français">Français</option>
                                        <option value="English">English</option>
                                        <option value="Deutsch">Deutsch</option>
                                        <option value="Español">Español</option>
                                    </select>
                                ) : (
                                    <p className="font-medium">{profileData.preferences.language}</p>
                                )}
                            </div>

                            <div>
                                <p className="text-sm text-gray-500 dark:text-gray-400 mb-1">Thème préféré</p>
                                {isEditing ? (
                                    <select
                                        name="preferences.theme"
                                        value={profileData.preferences.theme}
                                        onChange={handleChange}
                                        className="w-full bg-gray-50 dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-purple-500 px-3 py-1"
                                    >
                                        <option value="Clair">Clair</option>
                                        <option value="Sombre">Sombre</option>
                                        <option value="Système">Système</option>
                                    </select>
                                ) : (
                                    <p className="font-medium">{profileData.preferences.theme}</p>
                                )}
                            </div>
                        </div>
                    </div>

                    {/* Gestion du compte */}
                    <div className="bg-white dark:bg-gray-800 rounded-lg shadow-sm border border-gray-200 dark:border-gray-700 p-6 mb-6">
                        <h3 className="text-lg font-medium mb-4">Gestion du compte</h3>

                        <div className="space-y-4">
                            <button className="text-red-600 dark:text-red-400 hover:underline flex items-center">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="mr-1">
                                    <polyline points="3 6 5 6 21 6"></polyline>
                                    <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                                </svg>
                                Supprimer toutes les conversations
                            </button>

                            <button className="text-red-600 dark:text-red-400 hover:underline flex items-center">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="mr-1">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <line x1="15" y1="9" x2="9" y2="15"></line>
                                    <line x1="9" y1="9" x2="15" y2="15"></line>
                                </svg>
                                Supprimer mon compte
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
}