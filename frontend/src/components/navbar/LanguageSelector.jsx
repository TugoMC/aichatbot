
import { useState, useRef, useEffect } from "react";

export default function LanguageSelector({ currentLanguage, setCurrentLanguage, isMobile }) {
    const [isDropdownOpen, setIsDropdownOpen] = useState(false);
    const dropdownRef = useRef(null);

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

    // Gérer les clics en dehors du dropdown
    useEffect(() => {
        function handleClickOutside(event) {
            if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
                setIsDropdownOpen(false);
            }
        }

        document.addEventListener("mousedown", handleClickOutside);
        return () => document.removeEventListener("mousedown", handleClickOutside);
    }, []);

    // Fonction pour changer la langue
    const changeLanguage = (lang) => {
        setCurrentLanguage(lang);
        setIsDropdownOpen(false);
    };

    if (isMobile) {
        return (
            <div className="py-3 border-t dark:border-gray-800">
                <p className="text-sm text-gray-500 dark:text-gray-400 mb-2 px-2">Langue</p>
                <div className="flex flex-col space-y-2">
                    {languages.map((language) => (
                        <button
                            key={language.code}
                            onClick={() => changeLanguage(language.name)}
                            className={`flex items-center px-2 py-2 text-left ${currentLanguage === language.name
                                ? "bg-gray-100 dark:bg-gray-800 text-green-600 dark:text-green-400"
                                : "text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-800"
                                } rounded transition duration-300`}
                        >
                            {language.flag}
                            {language.name}
                        </button>
                    ))}
                </div>
            </div>
        );
    }

    return (
        <div className="relative" ref={dropdownRef}>
            <button
                onClick={() => setIsDropdownOpen(!isDropdownOpen)}
                className="flex items-center px-3 py-2 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-700 rounded-md shadow-sm text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 transition duration-300"
            >
                {languages.find(lang => lang.name === currentLanguage)?.flag}
                {currentLanguage}
                <svg className="w-4 h-4 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M19 9l-7 7-7-7"></path>
                </svg>
            </button>

            {isDropdownOpen && (
                <div className="absolute right-0 mt-2 w-48 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-md shadow-lg z-10">
                    <ul className="py-1">
                        {languages.map((language) => (
                            <li key={language.code}>
                                <button
                                    onClick={() => changeLanguage(language.name)}
                                    className="flex items-center w-full px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700"
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
    );
}