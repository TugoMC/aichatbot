import { Link, useLocation } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import googleIcon from '../assets/google.svg';
import { useState, useRef, useEffect } from "react";

export default function Navbar() {
    const { user, logout } = useAuth();
    const location = useLocation();
    const [isMenuOpen, setIsMenuOpen] = useState(false);
    const [isLanguageDropdownOpen, setIsLanguageDropdownOpen] = useState(false);
    const [currentLanguage, setCurrentLanguage] = useState("Français");
    const [isUserMenuOpen, setIsUserMenuOpen] = useState(false);

    // Références pour détecter les clics en dehors
    const userMenuRef = useRef(null);
    const languageDropdownRef = useRef(null);

    // On détermine l'onglet actif en fonction du chemin actuel
    const isActive = (path) => {
        return location.pathname === path;
    };

    const tabs = [
        { name: "Chat", path: "/" },
        { name: "Settings", path: "/Settings" }
    ];

    const languages = [
        {
            name: "Français",
            code: "fr",
            flag: (
                <svg className="w-5 h-5 rounded-full me-2" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
                    <path fill="#fff" d="M0 0h512v512H0z" />
                    <path fill="#00267f" d="M0 0h170.7v512H0z" />
                    <path fill="#f31830" d="M341.3 0H512v512H341.3z" />
                </svg>
            )
        },
        {
            name: "English",
            code: "en",
            flag: (
                <svg className="w-5 h-5 rounded-full me-2" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
                    <path fill="#012169" d="M0 0h512v512H0z" />
                    <path fill="#FFF" d="M512 0v64L322 256l190 187v69h-67L254 324 68 512H0v-68l186-187L0 74V0h62l192 188L440 0z" />
                    <path fill="#C8102E" d="M184 324l11 34L42 512H0v-3l184-185zm124-12l54 8 150 147v45L308 312zM512 0L320 196l-4-44L466 0h46zM0 1l193 189-59-8L0 49V1z" />
                    <path fill="#FFF" d="M176 0v512h160V0H176zM0 176v160h512V176H0z" />
                    <path fill="#C8102E" d="M0 208v96h512v-96H0zM208 0v512h96V0h-96z" />
                </svg>
            )
        },
        {
            name: "Deutsch",
            code: "de",
            flag: (
                <svg className="w-5 h-5 rounded-full me-2" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
                    <path fill="#ffce00" d="M0 341.3h512V512H0z" />
                    <path d="M0 0h512v170.7H0z" />
                    <path fill="#d00" d="M0 170.7h512v170.6H0z" />
                </svg>
            )
        },
        {
            name: "Italiano",
            code: "it",
            flag: (
                <svg className="w-5 h-5 rounded-full me-2" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
                    <g fillRule="evenodd" strokeWidth="1pt">
                        <path fill="#fff" d="M0 0h512v512H0z" />
                        <path fill="#009246" d="M0 0h170.7v512H0z" />
                        <path fill="#ce2b37" d="M341.3 0H512v512H341.3z" />
                    </g>
                </svg>
            )
        }
    ];

    // Gestion des clics en dehors des menus déroulants
    useEffect(() => {
        function handleClickOutside(event) {
            // Pour le menu utilisateur
            if (userMenuRef.current && !userMenuRef.current.contains(event.target)) {
                setIsUserMenuOpen(false);
            }

            // Pour le menu de langues
            if (languageDropdownRef.current && !languageDropdownRef.current.contains(event.target)) {
                setIsLanguageDropdownOpen(false);
            }
        }

        // Ajouter l'écouteur d'événement au document
        document.addEventListener("mousedown", handleClickOutside);

        // Nettoyer l'écouteur d'événement lors du démontage
        return () => {
            document.removeEventListener("mousedown", handleClickOutside);
        };
    }, []);

    // Fonction pour changer la langue
    const changeLanguage = (lang) => {
        setCurrentLanguage(lang);
        setIsLanguageDropdownOpen(false);
    };

    // Fonction pour fermer le menu après un clic sur un lien
    const closeMenu = () => {
        setIsMenuOpen(false);
    };

    // Fonction pour basculer l'affichage du menu déroulant des langues
    const toggleLanguageDropdown = () => {
        setIsLanguageDropdownOpen(!isLanguageDropdownOpen);
    };

    // Fonction pour le menu utilisateur
    const toggleUserMenu = () => {
        setIsUserMenuOpen(!isUserMenuOpen);
    };

    // Fonction modifiée pour la déconnexion avec rechargement de la page
    const handleLogout = async () => {
        await logout();
        window.location.href = "/"; // Redirection et rechargement de la page
    };

    return (
        <nav className="bg-white text-gray-800">
            <div className="container mx-auto px-4 relative">
                <div className="flex justify-between items-center py-3">
                    {/* Logo à gauche */}
                    <div className="w-1/3 flex justify-start">
                        <Link to="/" className="text-xl font-bold text-purple-800">
                            Negotio
                        </Link>
                    </div>

                    {/* Onglets au centre - visible seulement sur desktop (maintenant lg au lieu de md) */}
                    <div className="hidden lg:block absolute left-1/2 transform -translate-x-1/2 flex items-center space-x-8">
                        {tabs.map((tab) => (
                            <Link
                                key={tab.name}
                                to={tab.path}
                                className={`px-2 py-1 transition duration-300 ${isActive(tab.path)
                                    ? "text-green-600 border-b-2 border-green-600"
                                    : "text-gray-600 hover:text-gray-800"
                                    }`}
                            >
                                {tab.name}
                            </Link>
                        ))}
                    </div>

                    {/* À droite: Authentification + Langues - visible seulement sur desktop (maintenant lg au lieu de md) */}
                    <div className="hidden lg:flex w-1/3 justify-end items-center space-x-4">
                        {/* Sélecteur de langue */}
                        <div className="relative" ref={languageDropdownRef}>
                            <button
                                onClick={toggleLanguageDropdown}
                                className="flex items-center px-3 py-2 bg-white border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50 transition duration-300"
                            >
                                {languages.find(lang => lang.name === currentLanguage)?.flag}
                                {currentLanguage}
                                <svg className="w-4 h-4 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 9l-7 7-7-7"></path>
                                </svg>
                            </button>

                            {/* Menu déroulant des langues */}
                            {isLanguageDropdownOpen && (
                                <div className="absolute right-0 mt-2 w-48 bg-white border border-gray-200 rounded-md shadow-lg z-10">
                                    <ul className="py-1">
                                        {languages.map((language) => (
                                            <li key={language.code}>
                                                <button
                                                    onClick={() => changeLanguage(language.name)}
                                                    className="flex items-center w-full px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                                                >
                                                    {language.flag}
                                                    {language.name}
                                                </button>
                                            </li>
                                        ))}
                                    </ul>
                                </div>
                            )}
                        </div>

                        {/* Authentification - Version harmonisée avec image Google */}
                        {user ? (
                            <div className="relative" ref={userMenuRef}>
                                <button
                                    onClick={toggleUserMenu}
                                    className="flex items-center space-x-2 px-3 py-2 bg-white border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50 transition duration-300"
                                >
                                    {/* Image de profil Google */}
                                    {user.image ? (
                                        <img
                                            src={user.image}
                                            alt="Profile"
                                            className="w-5 h-5 rounded-full"
                                        />
                                    ) : (
                                        <div className="flex items-center justify-center w-5 h-5 rounded-full bg-purple-100 text-purple-700 text-xs font-medium">
                                            {user.displayName?.charAt(0).toUpperCase() || "U"}
                                        </div>
                                    )}
                                    <span>{user.displayName}</span>
                                    <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 9l-7 7-7-7"></path>
                                    </svg>
                                </button>


                                {/* Menu utilisateur */}
                                {isUserMenuOpen && (
                                    <div className="absolute right-0 mt-2 w-64 bg-white border border-gray-200 rounded-md shadow-lg z-10">
                                        <div className="px-4 py-3 border-b border-gray-100">
                                            <div className="flex items-center">
                                                {user.image ? (
                                                    <img
                                                        src={user.image}
                                                        alt="Profile"
                                                        className="w-8 h-8 rounded-full mr-2"
                                                    />
                                                ) : (
                                                    <div className="flex items-center justify-center w-8 h-8 rounded-full bg-purple-100 text-purple-700 font-medium mr-2">
                                                        {user.displayName?.charAt(0).toUpperCase() || "U"}
                                                    </div>
                                                )}
                                                <div>
                                                    <p className="text-sm font-medium text-gray-900 truncate">{user.displayName}</p>
                                                    <p className="text-xs text-gray-500 truncate">{user.email}</p>
                                                </div>
                                            </div>
                                        </div>
                                        <div className="py-1">
                                            <Link to="/profile" className="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                                Profil
                                            </Link>
                                            <button
                                                onClick={handleLogout}
                                                className="block w-full text-left px-4 py-2 text-sm text-red-600 hover:bg-gray-100"
                                            >
                                                Déconnexion
                                            </button>
                                        </div>
                                    </div>
                                )}
                            </div>
                        ) : (
                            <a
                                href="http://localhost:5000/api/auth/google"
                                className="flex items-center px-4 py-2 bg-white border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50 transition duration-300"
                            >
                                <img src={googleIcon} alt="Google logo" className="w-5 h-5 mr-2" />
                                Se connecter avec Google
                            </a>
                        )}
                    </div>

                    {/* Bouton hamburger - maintenant visible pour les écrans lg et plus petits (au lieu de md) */}
                    <div className="lg:hidden flex justify-end">
                        <button
                            onClick={() => setIsMenuOpen(!isMenuOpen)}
                            className="p-2 focus:outline-none focus:ring-2 focus:ring-purple-500 rounded-md"
                        >
                            <div className="flex flex-col justify-center space-y-2">
                                <span className="h-0.5 w-6 bg-gray-800 block"></span>
                                <span className="h-0.5 w-4 bg-gray-800 block"></span>
                            </div>
                        </button>
                    </div>
                </div>
            </div>

            {/* Menu mobile - s'affiche uniquement quand isMenuOpen est true */}
            {isMenuOpen && (
                <div className="lg:hidden bg-white border-t py-2">
                    <div className="container mx-auto px-4">
                        {/* Liens de navigation */}
                        <div className="flex flex-col space-y-3 py-3">
                            {tabs.map((tab) => (
                                <Link
                                    key={tab.name}
                                    to={tab.path}
                                    onClick={closeMenu}
                                    className={`px-2 py-2 transition duration-300 ${isActive(tab.path)
                                        ? "text-green-600 border-l-4 border-green-600 pl-3"
                                        : "text-gray-600 hover:text-gray-800 hover:bg-gray-50 rounded"
                                        }`}
                                >
                                    {tab.name}
                                </Link>
                            ))}
                        </div>

                        {/* Sélecteur de langue dans le menu mobile */}
                        <div className="py-3 border-t">
                            <p className="text-sm text-gray-500 mb-2 px-2">Langue</p>
                            <div className="flex flex-col space-y-2">
                                {languages.map((language) => (
                                    <button
                                        key={language.code}
                                        onClick={() => changeLanguage(language.name)}
                                        className={`flex items-center px-2 py-2 text-left ${currentLanguage === language.name
                                            ? "bg-gray-100 text-green-600"
                                            : "text-gray-600 hover:bg-gray-50"
                                            } rounded transition duration-300`}
                                    >
                                        {language.flag}
                                        {language.name}
                                    </button>
                                ))}
                            </div>
                        </div>

                        {/* Authentification dans le menu mobile - Version améliorée avec image Google */}
                        <div className="py-3 border-t">
                            {user ? (
                                <div className="flex flex-col space-y-2">
                                    {/* Affichage utilisateur */}
                                    <div className="flex items-center px-2 py-3 bg-gray-50 rounded-md">
                                        {user.image ? (
                                            <img
                                                src={user.image}
                                                alt="Profile"
                                                className="w-10 h-10 rounded-full mr-3"
                                            />
                                        ) : (
                                            <div className="flex items-center justify-center w-10 h-10 rounded-full bg-purple-100 text-purple-700 font-medium mr-3">
                                                {user.displayName?.charAt(0).toUpperCase() || "U"}
                                            </div>
                                        )}
                                        <div>
                                            <p className="text-sm font-medium text-gray-800">{user.displayName}</p>
                                            <p className="text-xs text-gray-500">{user.email}</p>
                                        </div>
                                    </div>

                                    {/* Lien vers le profil */}
                                    <Link
                                        to="/profile"
                                        className="flex items-center px-4 py-2 text-gray-700 hover:bg-gray-50 rounded transition duration-200"
                                    >
                                        <svg className="w-5 h-5 mr-2 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                                        </svg>
                                        Profil
                                    </Link>

                                    {/* Bouton de déconnexion modifié */}
                                    <button
                                        onClick={handleLogout}
                                        className="flex items-center px-4 py-2 text-red-600 hover:bg-red-50 rounded transition duration-200"
                                    >
                                        Déconnexion
                                    </button>
                                </div>
                            ) : (
                                <a
                                    href="http://localhost:5000/api/auth/google"
                                    className="flex items-center px-4 py-2 bg-white border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50 transition duration-300 mx-2"
                                >
                                    <img src={googleIcon} alt="Google logo" className="w-5 h-5 mr-2" />
                                    Se connecter avec Google
                                </a>
                            )}
                        </div>
                    </div>
                </div>
            )}
        </nav>
    );
}