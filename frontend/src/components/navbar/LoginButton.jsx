
import googleIcon from '../../assets/google.svg';

export default function LoginButton({ isMobile }) {
    const buttonClass = isMobile
        ? "flex items-center px-4 py-2 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-700 rounded-md shadow-sm text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 transition duration-300 mx-2"
        : "flex items-center px-4 py-2 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-700 rounded-md shadow-sm text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 transition duration-300";

    return (
        <a href="http://localhost:5000/api/auth/google" className={buttonClass}>
            <img src={googleIcon} alt="Google logo" className="w-5 h-5 mr-2" />
            Se connecter avec Google
        </a>
    );
}