import * as React from "react";
import * as ReactDOM from "react-dom";
import Book from "./book.jsx";

const App = () => {
  return <Book/>;
};

import { createRoot } from 'react-dom/client';
const container = document.getElementById('root');
const root = createRoot(container); 
root.render(<App tab="home" />);
