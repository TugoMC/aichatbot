
import { Link, useLocation } from "react-router-dom";
import { useAuth } from "../context/AuthContext";
import { useTheme } from "../context/ThemeContext";
import { useState } from "react";
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
        { name: "History", path: "/History" },
        { name: "Settings", path: "/Settings" }
    ];

    // Fonction pour fermer le menu après un clic sur un lien
    const closeMenu = () => {
        setIsMenuOpen(false);
    };

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
                        >
                            <div className="flex flex-col justify-center space-y-2">
                                <span className="h-0.5 w-6 bg-gray-800 dark:bg-gray-200 block"></span>
                                <span className="h-0.5 w-4 bg-gray-800 dark:bg-gray-200 block"></span>
                            </div>
                        </button>
                    </div>
                </div>
            </div>

            {/* Menu mobile */}
            {isMenuOpen && (
                <div className="lg:hidden bg-white dark:bg-gray-900 border-t dark:border-gray-800 py-2">
                    <div className="container mx-auto px-4">
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
            )}
        </nav>
    );
}