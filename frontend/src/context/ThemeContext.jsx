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

    // Appliquer les transitions CSS au chargement
    useEffect(() => {
        // Ajouter une feuille de style pour les transitions
        const styleElement = document.createElement('style');
        styleElement.innerHTML = `
            /* Transition fluide pour tous les éléments qui changent avec le thème */
            *, *::before, *::after {
                transition-property: background-color, border-color, color, fill, stroke;
                transition-duration: 300ms;
                transition-timing-function: ease;
            }
            
            /* Exclure certains éléments des transitions, si nécessaire */
            .no-transition {
                transition: none !important;
            }
        `;
        document.head.appendChild(styleElement);

        // Appliquer immédiatement le thème initial
        applyTheme(theme);

        // Nettoyage lors du démontage du composant
        return () => {
            document.head.removeChild(styleElement);
        };
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