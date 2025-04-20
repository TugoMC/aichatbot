import { createContext, useContext, useState, useEffect } from "react";

// Créer le contexte
const ThemeContext = createContext();

// Hook personnalisé pour utiliser le thème
export const useTheme = () => useContext(ThemeContext);

// Provider du thème
export const ThemeProvider = ({ children }) => {
    // Récupérer le thème depuis localStorage ou utiliser 'light' par défaut
    const [theme, setTheme] = useState(() => {
        // Vérifier si le thème est déjà stocké
        const savedTheme = localStorage.getItem('theme');

        // Si un thème est stocké, l'utiliser
        if (savedTheme) {
            return savedTheme;
        }

        // Sinon, vérifier la préférence système
        if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
            return 'dark';
        }

        // Par défaut, utiliser le thème clair
        return 'light';
    });

    // Appliquer immédiatement le thème initial
    useEffect(() => {
        applyTheme(theme);
    }, []);

    // Fonction pour appliquer le thème
    const applyTheme = (newTheme) => {
        const root = window.document.documentElement;

        // Appliquer la classe dark ou la supprimer
        if (newTheme === 'dark') {
            root.classList.add('dark');
        } else {
            root.classList.remove('dark');
        }

        // Sauvegarder dans localStorage
        localStorage.setItem('theme', newTheme);
    };

    // Fonction pour basculer entre les thèmes
    const toggleTheme = () => {
        const newTheme = theme === 'light' ? 'dark' : 'light';
        setTheme(newTheme);
        applyTheme(newTheme);

        // Forcer un rafraîchissement des styles
        document.body.style.colorScheme = newTheme;

        console.log("Thème changé pour:", newTheme);
    };

    const value = {
        theme,
        toggleTheme
    };

    return (
        <ThemeContext.Provider value={value}>
            {children}
        </ThemeContext.Provider>
    );
};