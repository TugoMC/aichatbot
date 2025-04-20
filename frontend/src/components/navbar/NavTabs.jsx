import { Link } from "react-router-dom";

export default function NavTabs({ tabs, isActive, isMobile, closeMenu }) {
    if (isMobile) {
        return (
            <div className="flex flex-col space-y-3 py-3">
                {tabs.map((tab) => (
                    <Link
                        key={tab.name}
                        to={tab.path}
                        onClick={closeMenu}
                        className={`px-2 py-2 transition duration-300 ${isActive(tab.path)
                            ? "text-purple-600 dark:text-purple-400 border-l-4 border-purple-600 dark:border-purple-400 pl-3"
                            : "text-gray-600 dark:text-gray-300 hover:text-gray-800 dark:hover:text-gray-100 hover:bg-gray-50 dark:hover:bg-gray-800 rounded"
                            }`}
                    >
                        {tab.name}
                    </Link>
                ))}
            </div>
        );
    }

    return (
        <div className="hidden lg:block absolute left-1/2 transform -translate-x-1/2 flex items-center space-x-8">
            {tabs.map((tab) => (
                <Link
                    key={tab.name}
                    to={tab.path}
                    className={`px-2 py-1 transition duration-300 ${isActive(tab.path)
                        ? "text-purple-600 dark:text-purple-400 border-b-2 border-purple-600 dark:border-purple-400"
                        : "text-gray-600 dark:text-gray-300 hover:text-gray-800 dark:hover:text-gray-100"
                        }`}
                >
                    {tab.name}
                </Link>
            ))}
        </div>
    );
}