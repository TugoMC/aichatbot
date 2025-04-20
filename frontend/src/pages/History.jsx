import { useState } from "react";
import { useAuth } from "../context/AuthContext";

export default function History() {
    const { user } = useAuth();
    const [searchTerm, setSearchTerm] = useState("");
    const [isFocused, setIsFocused] = useState(false);

    // Données d'historique regroupées par date
    const historyData = {
        "Today": [
            {
                id: 1,
                title: "Erreur de configuration Tailwind",
                icon: "chat" // Représente l'icône de discussion
            },
            {
                id: 2,
                title: "SVG Logo Google",
                icon: "chat"
            },
            {
                id: 3,
                title: "AI Chatbot MERN Optimisé",
                icon: "chat"
            }
        ],
        "Yesterday": [
            {
                id: 4,
                title: "Perdur les cookies de session",
                icon: "chat"
            },
            {
                id: 5,
                title: "MongoDB Atlas IP Whitelist",
                icon: "chat"
            },
            {
                id: 6,
                title: "Erreur commande build",
                icon: "chat"
            }
        ]
    };

    // Filtrer les éléments en fonction de la recherche
    const filterItems = () => {
        const result = {};

        Object.keys(historyData).forEach(date => {
            const filteredItems = historyData[date].filter(item =>
                item.title.toLowerCase().includes(searchTerm.toLowerCase())
            );

            if (filteredItems.length > 0) {
                result[date] = filteredItems;
            }
        });

        return result;
    };

    const filteredData = searchTerm ? filterItems() : historyData;

    // Fonction pour traduire les dates en français
    const translateDate = (date) => {
        if (date === "Today") return "Aujourd'hui";
        if (date === "Yesterday") return "Hier";
        return date;
    };

    // Fonction pour rendre les icônes de chat
    const renderChatIcon = () => (
        <div className="flex items-center justify-center w-8 h-8 rounded-full bg-purple-800 dark:bg-purple-700 text-white">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"></path>
            </svg>
        </div>
    );

    return (
        <div className="flex flex-col h-full bg-white dark:bg-gray-900 text-gray-800 dark:text-white pt-10">
            {/* Container avec largeur max et centrage */}
            <div className="max-w-3xl mx-auto w-full px-4 md:px-6">
                {/* Barre de recherche */}
                <div className="p-4 border-b border-gray-200 dark:border-gray-700">
                    <div className={`bg-white dark:bg-gray-800 rounded-lg flex items-center px-4 py-2 border transition duration-300 ${isFocused
                        ? "border-purple-800 dark:border-purple-500 ring-2 ring-purple-200 dark:ring-purple-900"
                        : "border-gray-200 dark:border-gray-700"
                        }`}>
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="text-gray-500 dark:text-gray-400">
                            <circle cx="11" cy="11" r="8"></circle>
                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                        </svg>
                        <input
                            type="text"
                            placeholder="Rechercher des conversations..."
                            value={searchTerm}
                            onChange={(e) => setSearchTerm(e.target.value)}
                            onFocus={() => setIsFocused(true)}
                            onBlur={() => setIsFocused(false)}
                            className="w-full bg-transparent text-gray-800 dark:text-white py-1 px-2 focus:outline-none ml-2"
                        />
                        {searchTerm && (
                            <button
                                className="text-gray-500 dark:text-gray-400 hover:text-purple-800 dark:hover:text-purple-400 transition duration-300"
                                onClick={() => setSearchTerm("")}
                            >
                                <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                    <line x1="18" y1="6" x2="6" y2="18"></line>
                                    <line x1="6" y1="6" x2="18" y2="18"></line>
                                </svg>
                            </button>
                        )}
                    </div>
                </div>

                {/* Liste de l'historique */}
                <div className="flex-1 overflow-y-auto">
                    {Object.keys(filteredData).length > 0 ? (
                        Object.entries(filteredData).map(([date, items]) => (
                            <div key={date}>
                                <div className="px-6 py-3 text-sm text-gray-500 dark:text-gray-400 font-medium">
                                    {translateDate(date)}
                                </div>
                                {items.map(item => (
                                    <div
                                        key={item.id}
                                        className="flex items-center px-6 py-3 mx-4 my-1 hover:bg-gray-100 dark:hover:bg-gray-800 cursor-pointer rounded-lg transition duration-300 border border-transparent hover:border-gray-200 dark:hover:border-gray-700"
                                    >
                                        {renderChatIcon()}
                                        <span className="ml-3 text-gray-700 dark:text-gray-300">{item.title}</span>
                                    </div>
                                ))}
                            </div>
                        ))
                    ) : (
                        <div className="flex flex-col items-center justify-center h-full text-center text-gray-500 dark:text-gray-400 p-6">
                            <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" className="mb-3">
                                <circle cx="11" cy="11" r="8"></circle>
                                <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                            </svg>
                            <p>Aucun résultat trouvé</p>
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
}