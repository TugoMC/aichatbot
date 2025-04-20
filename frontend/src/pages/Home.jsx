import { useState } from "react";
import { useAuth } from "../context/AuthContext";
import { Link } from "react-router-dom";

export default function Home() {
    const { user, loading } = useAuth();
    const [selectedCategory, setSelectedCategory] = useState('General');



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
            <div className="flex items-center justify-center min-h-screen">
                <div className="text-center">
                    <div className="w-12 h-12 border-4 border-purple-800 border-t-transparent border-solid rounded-full animate-spin mx-auto"></div>
                    <p className="mt-3 text-lg">Chargement...</p>
                </div>
            </div>
        );
    }

    return (
        <div className="min-h-screen bg-white flex flex-col">
            {/* Main Content */}
            <main className="flex-1 flex flex-col justify-center items-center px-4 text-center max-w-3xl mx-auto">


                {/* Headline */}
                <h1 className="text-3xl font-bold mb-4 text-gray-800 py-8">
                    How can we <span className="text-purple-800">assist</span> you today?
                </h1>





                {/* Service Cards */}
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6 w-full mb-12">
                    {serviceCards
                        .filter(card => selectedCategory === 'General' || card.category === selectedCategory)
                        .map((card, index) => (
                            <div key={index} className="bg-white p-6 rounded-lg shadow-sm border border-gray-200 text-left hover:border-purple-800 transition duration-300">
                                <h3 className="font-semibold mb-2 text-gray-800">{card.title}</h3>
                                <p className="text-gray-600 text-sm mb-4">{card.description}</p>
                                <button className="flex justify-center items-center w-8 h-8 bg-white rounded-full border border-gray-200 hover:border-green-600 hover:text-green-600 transition duration-300">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                        <path d="M5 12H19M12 5V19" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" />
                                    </svg>
                                </button>
                            </div>
                        ))}
                </div>

                {/* Input field */}
                <div className="w-full max-w-3xl relative mb-8">
                    <div className="bg-white rounded-lg flex items-center px-4 py-3 border border-gray-200">
                        <button className="text-gray-500 mr-2 hover:text-purple-800 transition duration-300">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M13.5 6H5.25A2.25 2.25 0 003 8.25v10.5A2.25 2.25 0 005.25 21h10.5A2.25 2.25 0 0018 18.75V10.5m-10.5 6L21 3m0 0h-5.25M21 3v5.25" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" />
                            </svg>
                        </button>
                        <input
                            type="text"
                            placeholder="Type here"
                            className="bg-transparent flex-1 outline-none text-gray-700 px-2"
                        />
                        <button className="text-gray-500 ml-2 hover:text-purple-800 transition duration-300">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M12 18.5c3.5 0 6.5-2.8 6.5-6.3 0-3.4-3-6.2-6.5-6.2s-6.5 2.8-6.5 6.3c0 1.2.3 2.3.9 3.2.1.2.2.3.1.5l-.7 2.1c-.1.4.3.8.7.6l2.4-1c.2-.1.4 0 .6.1.9.5 2 .7 3 .7z" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" />
                            </svg>
                        </button>
                        <button className="ml-2 bg-purple-800 text-white rounded-full w-10 h-10 flex items-center justify-center hover:bg-purple-900 transition duration-300">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M5 12h14M12 5l7 7-7 7" stroke="white" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" />
                            </svg>
                        </button>
                    </div>
                </div>
            </main>
        </div>
    );
}