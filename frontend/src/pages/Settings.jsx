import { useState } from "react";
import { useAuth } from "../context/AuthContext";
import { useTheme } from "../context/ThemeContext";

export default function Settings() {
    const { user } = useAuth();
    const { theme, toggleTheme } = useTheme();
    const [language, setLanguage] = useState("Français");
    const [notifications, setNotifications] = useState({
        email: true,
        app: true,
        summary: false
    });

    // Simuler la sauvegarde des paramètres
    const saveSettings = () => {
        alert("Paramètres sauvegardés avec succès!");
    };

    // Gérer les changements de notifications
    const handleNotificationChange = (type) => {
        setNotifications(prev => ({
            ...prev,
            [type]: !prev[type]
        }));
    };

    const languages = [
        { name: "Français", code: "fr" },
        { name: "English", code: "en" },
        { name: "Deutsch", code: "de" },
        { name: "Italiano", code: "it" }
    ];

    return (
        <div className="flex flex-col h-full bg-white dark:bg-gray-900 text-gray-800 dark:text-white pt-10">
            {/* Container avec largeur max et centrage */}
            <div className="max-w-3xl mx-auto w-full px-4 md:px-6">


                {user ? (
                    <div className="flex-1 overflow-y-auto">
                        {/* Paramètres d'affichage */}
                        <div className="mb-6">
                            <div className="px-6 py-3 text-sm text-gray-500 dark:text-gray-400 font-medium">
                                Affichage
                            </div>

                            {/* Thème */}
                            <div className="flex items-center px-6 py-3 mx-4 my-1 hover:bg-gray-100 dark:hover:bg-gray-800 cursor-pointer rounded-lg transition duration-300 border border-transparent hover:border-gray-200 dark:hover:border-gray-700">
                                <div className="flex items-center justify-center w-8 h-8 rounded-full bg-purple-800 dark:bg-purple-700 text-white">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                        {theme === 'dark' ? (
                                            <circle cx="12" cy="12" r="5" />
                                        ) : (
                                            <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z" />
                                        )}
                                    </svg>
                                </div>
                                <span className="ml-3 text-gray-700 dark:text-gray-300">Thème</span>
                                <div className="ml-auto">
                                    <button
                                        onClick={toggleTheme}
                                        className={`relative inline-flex h-6 w-11 items-center rounded-full ${theme === 'dark' ? 'bg-purple-600' : 'bg-gray-200'}`}
                                    >
                                        <span
                                            className={`inline-block h-4 w-4 transform rounded-full bg-white transition ${theme === 'dark' ? 'translate-x-6' : 'translate-x-1'}`}
                                        />
                                    </button>
                                </div>
                            </div>

                            {/* Langue */}
                            <div className="flex items-center px-6 py-3 mx-4 my-1 hover:bg-gray-100 dark:hover:bg-gray-800 cursor-pointer rounded-lg transition duration-300 border border-transparent hover:border-gray-200 dark:hover:border-gray-700">
                                <div className="flex items-center justify-center w-8 h-8 rounded-full bg-purple-800 dark:bg-purple-700 text-white">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                        <path d="M3 5h12M9 3v18M13 7l3 3-3 3M5 21h12M19 15l3 3-3 3" />
                                    </svg>
                                </div>
                                <span className="ml-3 text-gray-700 dark:text-gray-300">Langue</span>
                                <div className="ml-auto">
                                    <select
                                        value={language}
                                        onChange={(e) => setLanguage(e.target.value)}
                                        className="px-3 py-1 bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-purple-500"
                                    >
                                        {languages.map((lang) => (
                                            <option key={lang.code} value={lang.name}>
                                                {lang.name}
                                            </option>
                                        ))}
                                    </select>
                                </div>
                            </div>
                        </div>

                        {/* Notifications */}
                        <div>
                            <div className="px-6 py-3 text-sm text-gray-500 dark:text-gray-400 font-medium">
                                Notifications
                            </div>

                            {/* Email */}
                            <div className="flex items-center px-6 py-3 mx-4 my-1 hover:bg-gray-100 dark:hover:bg-gray-800 cursor-pointer rounded-lg transition duration-300 border border-transparent hover:border-gray-200 dark:hover:border-gray-700">
                                <div className="flex items-center justify-center w-8 h-8 rounded-full bg-purple-800 dark:bg-purple-700 text-white">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                        <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                                        <polyline points="22,6 12,13 2,6"></polyline>
                                    </svg>
                                </div>
                                <div className="ml-3">
                                    <p className="text-gray-700 dark:text-gray-300">Notifications par email</p>
                                    <p className="text-xs text-gray-500 dark:text-gray-400">Recevoir des mises à jour par email</p>
                                </div>
                                <div className="ml-auto">
                                    <button
                                        onClick={() => handleNotificationChange('email')}
                                        className={`relative inline-flex h-6 w-11 items-center rounded-full ${notifications.email ? 'bg-purple-600' : 'bg-gray-200 dark:bg-gray-700'}`}
                                    >
                                        <span
                                            className={`inline-block h-4 w-4 transform rounded-full bg-white transition ${notifications.email ? 'translate-x-6' : 'translate-x-1'}`}
                                        />
                                    </button>
                                </div>
                            </div>

                            {/* Notifications dans l'application */}
                            <div className="flex items-center px-6 py-3 mx-4 my-1 hover:bg-gray-100 dark:hover:bg-gray-800 cursor-pointer rounded-lg transition duration-300 border border-transparent hover:border-gray-200 dark:hover:border-gray-700">
                                <div className="flex items-center justify-center w-8 h-8 rounded-full bg-purple-800 dark:bg-purple-700 text-white">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                        <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                                        <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                                    </svg>
                                </div>
                                <div className="ml-3">
                                    <p className="text-gray-700 dark:text-gray-300">Notifications dans l'application</p>
                                    <p className="text-xs text-gray-500 dark:text-gray-400">Afficher des notifications dans l'application</p>
                                </div>
                                <div className="ml-auto">
                                    <button
                                        onClick={() => handleNotificationChange('app')}
                                        className={`relative inline-flex h-6 w-11 items-center rounded-full ${notifications.app ? 'bg-purple-600' : 'bg-gray-200 dark:bg-gray-700'}`}
                                    >
                                        <span
                                            className={`inline-block h-4 w-4 transform rounded-full bg-white transition ${notifications.app ? 'translate-x-6' : 'translate-x-1'}`}
                                        />
                                    </button>
                                </div>
                            </div>

                            {/* Rapports hebdomadaires */}
                            <div className="flex items-center px-6 py-3 mx-4 my-1 hover:bg-gray-100 dark:hover:bg-gray-800 cursor-pointer rounded-lg transition duration-300 border border-transparent hover:border-gray-200 dark:hover:border-gray-700">
                                <div className="flex items-center justify-center w-8 h-8 rounded-full bg-purple-800 dark:bg-purple-700 text-white">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                                        <polyline points="14 2 14 8 20 8"></polyline>
                                        <line x1="16" y1="13" x2="8" y2="13"></line>
                                        <line x1="16" y1="17" x2="8" y2="17"></line>
                                        <polyline points="10 9 9 9 8 9"></polyline>
                                    </svg>
                                </div>
                                <div className="ml-3">
                                    <p className="text-gray-700 dark:text-gray-300">Rapports hebdomadaires</p>
                                    <p className="text-xs text-gray-500 dark:text-gray-400">Recevoir un résumé hebdomadaire des activités</p>
                                </div>
                                <div className="ml-auto">
                                    <button
                                        onClick={() => handleNotificationChange('summary')}
                                        className={`relative inline-flex h-6 w-11 items-center rounded-full ${notifications.summary ? 'bg-purple-600' : 'bg-gray-200 dark:bg-gray-700'}`}
                                    >
                                        <span
                                            className={`inline-block h-4 w-4 transform rounded-full bg-white transition ${notifications.summary ? 'translate-x-6' : 'translate-x-1'}`}
                                        />
                                    </button>
                                </div>
                            </div>
                        </div>

                        {/* Bouton Sauvegarder */}
                        <div className="px-6 py-6 flex justify-end">
                            <button
                                onClick={saveSettings}
                                className="px-4 py-2 bg-purple-600 hover:bg-purple-700 text-white font-medium rounded-md transition-colors"
                            >
                                Sauvegarder les modifications
                            </button>
                        </div>
                    </div>
                ) : (
                    <div className="flex flex-col items-center justify-center h-full text-center text-gray-500 dark:text-gray-400 p-6">
                        <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" className="mb-3">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                            <circle cx="9" cy="7" r="4"></circle>
                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                            <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                        </svg>
                        <p>Veuillez vous connecter pour accéder aux paramètres</p>
                    </div>
                )}
            </div>
        </div>
    );
}