import React from 'react';
import { languages } from '../constants/languages';

export const LanguageSelector = ({ selectedLanguage, setSelectedLanguage, isListening }) => (
  <select
    value={selectedLanguage}
    onChange={(e) => setSelectedLanguage(e.target.value)}
    className="w-64 p-2 text-sm bg-white dark:bg-black border border-gray-300 dark:border-white rounded-md shadow-sm focus:ring-2 focus:ring-emerald-500 focus:border-transparent dark:text-gray-200"
    disabled={isListening}
  >
    {languages.map((lang) => (
      <option key={lang.code} value={lang.code}>
        {lang.name}
      </option>
    ))}
  </select>
);

