import { Link, useLocation } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { useTheme } from "../context/ThemeContext";
import { useState, useEffect } from "react";
import NavTabs from "./navbar/NavTabs";
import ThemeToggle from "./navbar/ThemeToggle";
import LanguageSelector from "./navbar/LanguageSelector";
import UserMenu from "./navbar/UserMenu";
import LoginButton from "./navbar/LoginButton";

export default function Navbar() {
    const { user, logout } = useAuth();
    const { theme, toggleTheme } = useTheme();
    const location = useLocation();
    const [isMenuOpen, setIsMenuOpen] = useState(false);
    const [currentLanguage, setCurrentLanguage] = useState("Français");

    // On détermine l'onglet actif en fonction du chemin actuel
    const isActive = (path) => {
        return location.pathname === path;
    };

    const tabs = [
        { name: "Chat", path: "/" },
        { name: "Historique", path: "/history" },
        { name: "Paramètres", path: "/settings" }
    ];



    // Fonction pour fermer le menu après un clic sur un lien
    const closeMenu = () => {
        setIsMenuOpen(false);
    };

    // Empêcher le défilement du body quand le menu est ouvert
    useEffect(() => {
        if (isMenuOpen) {
            document.body.style.overflow = 'hidden';
        } else {
            document.body.style.overflow = '';
        }

        return () => {
            document.body.style.overflow = '';
        };
    }, [isMenuOpen]);

    return (
        <nav className="bg-white dark:bg-gray-900 text-gray-800 dark:text-gray-200">
            <div className="container mx-auto px-4 relative">
                <div className="flex justify-between items-center py-3">
                    {/* Logo et toggle theme à gauche */}
                    <div className="w-1/3 flex justify-start items-center">
                        <Link to="/" className="text-xl font-bold text-purple-800 dark:text-purple-400">
                            Negotio
                        </Link>
                        <ThemeToggle theme={theme} toggleTheme={toggleTheme} isMobile={false} />
                    </div>

                    {/* Onglets au centre */}
                    <NavTabs tabs={tabs} isActive={isActive} isMobile={false} />

                    {/* À droite: Authentification + Langues */}
                    <div className="hidden lg:flex w-1/3 justify-end items-center space-x-4">
                        <LanguageSelector
                            currentLanguage={currentLanguage}
                            setCurrentLanguage={setCurrentLanguage}
                            isMobile={false}
                        />

                        {user ? (
                            <UserMenu user={user} logout={logout} isMobile={false} />
                        ) : (
                            <LoginButton isMobile={false} />
                        )}
                    </div>

                    {/* Bouton hamburger */}
                    <div className="lg:hidden flex justify-end">
                        <button
                            onClick={() => setIsMenuOpen(!isMenuOpen)}
                            className="p-2 focus:outline-none focus:ring-2 focus:ring-purple-500 rounded-md"
                            aria-label="M"
                        >
                            <div className="flex flex-col justify-center space-y-2">
                                <span className="h-0.5 w-6 bg-gray-800 dark:bg-gray-200 block"></span>
                                <span className="h-0.5 w-4 bg-gray-800 dark:bg-gray-200 block"></span>
                            </div>
                        </button>
                    </div>
                </div>
            </div>

            {/* Overlay sombre quand le menu est ouvert */}
            {isMenuOpen && (
                <div
                    className="fixed inset-0 bg-black bg-opacity-50 z-40 transition-opacity duration-300"
                    onClick={closeMenu}
                ></div>
            )}

            {/* Sidebar mobile avec animation */}
            <div
                className={`fixed top-0 right-0 bottom-0 w-64 bg-white dark:bg-gray-900 shadow-lg transform transition-transform duration-300 ease-in-out z-50 ${isMenuOpen ? 'translate-x-0' : 'translate-x-full'
                    }`}
            >
                <div className="flex justify-between items-center p-4 border-b dark:border-gray-800">
                    <h2 className="text-lg font-semibold">Menu</h2>
                    <button
                        onClick={closeMenu}
                        className="p-2 focus:outline-none rounded-full hover:bg-gray-100 dark:hover:bg-gray-800"
                    >
                        <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M6 18L18 6M6 6l12 12"></path>
                        </svg>
                    </button>
                </div>

                <div className="h-full overflow-y-auto pb-20">
                    {/* Liens de navigation */}
                    <NavTabs tabs={tabs} isActive={isActive} isMobile={true} closeMenu={closeMenu} />

                    {/* Thème */}
                    <ThemeToggle theme={theme} toggleTheme={toggleTheme} isMobile={true} />

                    {/* Sélecteur de langue */}
                    <LanguageSelector
                        currentLanguage={currentLanguage}
                        setCurrentLanguage={setCurrentLanguage}
                        isMobile={true}
                    />

                    {/* Authentification */}
                    {user ? (
                        <UserMenu user={user} logout={logout} isMobile={true} />
                    ) : (
                        <div className="py-3 border-t dark:border-gray-800">
                            <LoginButton isMobile={true} />
                        </div>
                    )}
                </div>
            </div>
        </nav>
    );
}