import { useState } from 'react';

export default function TailwindTest() {
    const [isOpen, setIsOpen] = useState(false);

    return (
        <div className="mb-8 bg-gradient-to-r from-blue-500 to-indigo-600 p-6 rounded-lg text-white">
            <h2 className="text-xl font-bold mb-3">Test des fonctionnalités Tailwind CSS v3.3</h2>

            {/* Test de grille */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
                <div className="bg-blue-700/50 p-3 rounded">Colonne 1</div>
                <div className="bg-blue-700/50 p-3 rounded">Colonne 2</div>
                <div className="bg-blue-700/50 p-3 rounded">Colonne 3</div>
            </div>

            {/* Test d'animation */}
            <div className="flex justify-center mb-4">
                <div className="animate-bounce bg-white rounded-full p-2 w-10 h-10 flex items-center justify-center">
                    <svg className="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 14l-7 7m0 0l-7-7m7 7V3"></path>
                    </svg>
                </div>
            </div>

            {/* Test d'effets au survol */}
            <button
                className="bg-white text-blue-600 px-4 py-2 rounded transition-all hover:bg-blue-100 hover:scale-105 focus:ring-2 focus:ring-white"
                onClick={() => setIsOpen(!isOpen)}
            >
                {isOpen ? 'Masquer les détails' : 'Afficher les détails'}
            </button>

            {/* Contenu conditionnel */}
            {isOpen && (
                <div className="mt-4 bg-white/20 backdrop-blur-sm p-4 rounded animate-fade-in">
                    <p className="text-sm">
                        Ce composant démontre diverses fonctionnalités de Tailwind CSS v3.3 comme:
                    </p>
                    <ul className="list-disc pl-5 mt-2 space-y-1 text-sm">
                        <li>Les dégradés (gradients)</li>
                        <li>Les grilles responsive</li>
                        <li>Les opacités avec notation slash</li>
                        <li>Les animations</li>
                        <li>Les transformations</li>
                        <li>Les effets de flou (backdrop-blur)</li>
                    </ul>
                </div>
            )}
        </div>
    );
}