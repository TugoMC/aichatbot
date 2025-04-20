
import { useState, useRef, useEffect } from "react";
import { Link } from "react-router-dom";

export default function UserMenu({ user, logout, isMobile }) {
    const [isUserMenuOpen, setIsUserMenuOpen] = useState(false);
    const userMenuRef = useRef(null);

    // Gérer les clics en dehors du menu
    useEffect(() => {
        function handleClickOutside(event) {
            if (userMenuRef.current && !userMenuRef.current.contains(event.target)) {
                setIsUserMenuOpen(false);
            }
        }

        document.addEventListener("mousedown", handleClickOutside);
        return () => document.removeEventListener("mousedown", handleClickOutside);
    }, []);

    // Fonction pour la déconnexion
    const handleLogout = async () => {
        await logout();
        window.location.href = "/";
    };

    if (isMobile) {
        return (
            <div className="py-3 border-t dark:border-gray-800">
                <div className="flex flex-col space-y-2">
                    {/* Affichage utilisateur */}
                    <div className="flex items-center px-2 py-3 bg-gray-50 dark:bg-gray-800 rounded-md">
                        {user.image ? (
                            <img
                                src={user.image}
                                alt="Profile"
                                className="w-10 h-10 rounded-full mr-3"
                            />
                        ) : (
                            <div className="flex items-center justify-center w-10 h-10 rounded-full bg-purple-100 dark:bg-purple-900 text-purple-700 dark:text-purple-300 font-medium mr-3">
                                {user.displayName?.charAt(0).toUpperCase() || "U"}
                            </div>
                        )}
                        <div>
                            <p className="text-sm font-medium text-gray-800 dark:text-gray-200">{user.displayName}</p>
                            <p className="text-xs text-gray-500 dark:text-gray-400">{user.email}</p>
                        </div>
                    </div>

                    {/* Lien vers le profil */}
                    <Link
                        to="/profile"
                        className="flex items-center px-4 py-2 text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800 rounded transition duration-200"
                    >
                        <svg className="w-5 h-5 mr-2 text-gray-500 dark:text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                        </svg>
                        Profil
                    </Link>

                    {/* Bouton de déconnexion */}
                    <button
                        onClick={handleLogout}
                        className="flex items-center px-4 py-2 text-red-600 dark:text-red-400 hover:bg-red-50 dark:hover:bg-red-900 dark:hover:bg-opacity-20 rounded transition duration-200"
                    >
                        Déconnexion
                    </button>
                </div>
            </div>
        );
    }

    return (
        <div className="relative" ref={userMenuRef}>
            <button
                onClick={() => setIsUserMenuOpen(!isUserMenuOpen)}
                className="flex items-center space-x-2 px-3 py-2 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-700 rounded-md shadow-sm text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 transition duration-300"
            >
                {user.image ? (
                    <img
                        src={user.image}
                        alt="Profile"
                        className="w-5 h-5 rounded-full"
                    />
                ) : (
                    <div className="flex items-center justify-center w-5 h-5 rounded-full bg-purple-100 dark:bg-purple-900 text-purple-700 dark:text-purple-300 text-xs font-medium">
                        {user.displayName?.charAt(0).toUpperCase() || "U"}
                    </div>
                )}
                <span>{user.displayName}</span>
                <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 9l-7 7-7-7"></path>
                </svg>
            </button>

            {isUserMenuOpen && (
                <div className="absolute right-0 mt-2 w-64 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-md shadow-lg z-10">
                    <div className="px-4 py-3 border-b border-gray-100 dark:border-gray-700">
                        <div className="flex items-center">
                            {user.image ? (
                                <img
                                    src={user.image}
                                    alt="Profile"
                                    className="w-8 h-8 rounded-full mr-2"
                                />
                            ) : (
                                <div className="flex items-center justify-center w-8 h-8 rounded-full bg-purple-100 dark:bg-purple-900 text-purple-700 dark:text-purple-300 font-medium mr-2">
                                    {user.displayName?.charAt(0).toUpperCase() || "U"}
                                </div>
                            )}
                            <div>
                                <p className="text-sm font-medium text-gray-900 dark:text-gray-100 truncate">{user.displayName}</p>
                                <p className="text-xs text-gray-500 dark:text-gray-400 truncate">{user.email}</p>
                            </div>
                        </div>
                    </div>
                    <div className="py-1">
                        <Link to="/profile" className="block px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700">
                            Profil
                        </Link>
                        <button
                            onClick={handleLogout}
                            className="block w-full text-left px-4 py-2 text-sm text-red-600 dark:text-red-400 hover:bg-gray-100 dark:hover:bg-gray-700"
                        >
                            Déconnexion
                        </button>
                    </div>
                </div>
            )}
        </div>
    );
}