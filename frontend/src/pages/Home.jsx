import { useState } from "react";
import { useAuth } from "../context/AuthContext";
import { Link } from "react-router-dom";

export default function Home() {
    const { user, loading } = useAuth();
    const [selectedCategory, setSelectedCategory] = useState('General');
    const [isFocused, setIsFocused] = useState(false);

    // Cartes de services
    const serviceCards = [
        {
            title: 'Sales Strategies',
            description: 'Get tailored advice on increasing company visibility and driving sales.',
            category: 'Sales'
        },
        {
            title: 'Negotiation Tactics',
            description: 'Learn expert negotiation tips to close deals efficiently.',
            category: 'Negotiation'
        },
        {
            title: 'Marketing Insights',
            description: 'Discover the best marketing strategies to showcase your products.',
            category: 'Marketing'
        },
        {
            title: 'General Support',
            description: 'Need help with something else? Ask here and we\'ll guide you.',
            category: 'General'
        }
    ];

    if (loading) {
        return (
            <div className="flex items-center justify-center min-h-screen bg-white dark:bg-gray-900">
                <div className="text-center">
                    <div className="w-12 h-12 border-4 border-purple-800 dark:border-purple-500 border-t-transparent border-solid rounded-full animate-spin mx-auto"></div>
                    <p className="mt-3 text-lg text-gray-800 dark:text-gray-200">Chargement...</p>
                </div>
            </div>
        );
    }

    return (
        <div className="min-h-screen bg-white dark:bg-gray-900 flex flex-col">
            {/* Main Content */}
            <main className="flex-1 flex flex-col justify-center items-center px-4 text-center max-w-3xl mx-auto">
                {/* Headline - Now centered vertically */}
                <h1 className="text-3xl font-bold mb-4 text-gray-800 dark:text-gray-100 py-8">
                    How can we <span className="text-purple-800 dark:text-purple-400">assist</span> you today?
                </h1>

                {/* Service Cards - Hidden on mobile (sm) screens, visible on md and above */}
                <div className="hidden md:grid grid-cols-1 md:grid-cols-2 gap-6 w-full mb-12">
                    {serviceCards
                        .filter(card => selectedCategory === 'General' || card.category === selectedCategory)
                        .map((card, index) => (
                            <div key={index} className="bg-white dark:bg-gray-800 p-6 rounded-lg shadow-sm border border-gray-200 dark:border-gray-700 text-left hover:border-purple-800 dark:hover:border-purple-500 transition duration-300">
                                <h3 className="font-semibold mb-2 text-gray-800 dark:text-gray-100">{card.title}</h3>
                                <p className="text-gray-600 dark:text-gray-300 text-sm mb-4">{card.description}</p>
                                <button className="flex justify-center items-center w-8 h-8 bg-white dark:bg-gray-700 rounded-full border border-gray-200 dark:border-gray-600 hover:border-purple-800 dark:hover:border-purple-500 hover:text-purple-600 dark:hover:text-purple-500 transition duration-300">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                        <path d="M5 12H19M12 5V19" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" />
                                    </svg>
                                </button>
                            </div>
                        ))}
                </div>

                {/* Input field for desktop */}
                <div className="w-full max-w-3xl relative mb-8 hidden md:block">
                    <div className={`bg-white dark:bg-gray-800 rounded-lg flex items-center px-4 py-3 border transition duration-300 ${isFocused
                        ? "border-purple-800 dark:border-purple-500 ring-2 ring-purple-200 dark:ring-purple-900"
                        : "border-gray-200 dark:border-gray-700"
                        }`}>
                        <button className="text-gray-500 dark:text-gray-400 mr-2 hover:text-purple-800 dark:hover:text-purple-400 transition duration-300">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M13.5 6H5.25A2.25 2.25 0 003 8.25v10.5A2.25 2.25 0 005.25 21h10.5A2.25 2.25 0 0018 18.75V10.5m-10.5 6L21 3m0 0h-5.25M21 3v5.25" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" />
                            </svg>
                        </button>
                        <input
                            type="text"
                            placeholder="Type here"
                            className="bg-transparent flex-1 outline-none text-gray-700 dark:text-gray-300 px-2"
                            onFocus={() => setIsFocused(true)}
                            onBlur={() => setIsFocused(false)}
                        />
                        <button className="text-gray-500 dark:text-gray-400 ml-2 hover:text-purple-800 dark:hover:text-purple-400 transition duration-300">
                            {/* Icône de microphone remplaçant la bulle de chat */}
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M12 1a3 3 0 00-3 3v8a3 3 0 006 0V4a3 3 0 00-3-3z" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" />
                                <path d="M19 10v2a7 7 0 01-14 0v-2M12 19v4M8 23h8" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" />
                            </svg>
                        </button>
                        <button className="ml-2 bg-purple-800 dark:bg-purple-700 text-white rounded-full w-10 h-10 flex items-center justify-center hover:bg-purple-900 dark:hover:bg-purple-800 transition duration-300">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M5 12h14M12 5l7 7-7 7" stroke="white" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" />
                            </svg>
                        </button>
                    </div>
                </div>
            </main>

            {/* Fixed input field at bottom of screen for mobile */}
            <div className="md:hidden fixed bottom-0 left-0 right-0 bg-white dark:bg-gray-900 p-4">
                <div className={`bg-white dark:bg-gray-800 rounded-lg flex items-center px-4 py-3 border transition duration-300 ${isFocused
                    ? "border-purple-800 dark:border-purple-500 ring-2 ring-purple-200 dark:ring-purple-900"
                    : "border-gray-200 dark:border-gray-700"
                    }`}>
                    <button className="text-gray-500 dark:text-gray-400 mr-2 hover:text-purple-800 dark:hover:text-purple-400 transition duration-300">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M13.5 6H5.25A2.25 2.25 0 003 8.25v10.5A2.25 2.25 0 005.25 21h10.5A2.25 2.25 0 0018 18.75V10.5m-10.5 6L21 3m0 0h-5.25M21 3v5.25" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" />
                        </svg>
                    </button>
                    <input
                        type="text"
                        placeholder="Type here"
                        className="bg-transparent flex-1 outline-none text-gray-700 dark:text-gray-300 px-2"
                        onFocus={() => setIsFocused(true)}
                        onBlur={() => setIsFocused(false)}
                    />
                    <button className="text-gray-500 dark:text-gray-400 ml-2 hover:text-purple-800 dark:hover:text-purple-400 transition duration-300">
                        {/* Icône de microphone remplaçant la bulle de chat */}
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M12 1a3 3 0 00-3 3v8a3 3 0 006 0V4a3 3 0 00-3-3z" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" />
                            <path d="M19 10v2a7 7 0 01-14 0v-2M12 19v4M8 23h8" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" />
                        </svg>
                    </button>
                    <button className="ml-2 bg-purple-800 dark:bg-purple-700 text-white rounded-full w-10 h-10 flex items-center justify-center hover:bg-purple-900 dark:hover:bg-purple-800 transition duration-300">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M5 12h14M12 5l7 7-7 7" stroke="white" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" />
                        </svg>
                    </button>
                </div>
            </div>

            {/* Add padding at the bottom on mobile to prevent content from being hidden behind the fixed input */}
            <div className="md:hidden h-24"></div>
        </div>
    );
}