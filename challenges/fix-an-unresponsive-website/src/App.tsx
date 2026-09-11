
import './App.css'
import { BrowserRouter, Route, Routes } from 'react-router-dom'
import PageHeader from './pageHeader/PageHeader'
import HomePage from './homePage/HomePage'
import AboutPage from './aboutPage/AboutPage'
import FindTransaction from './transactionsManagement/FindTransaction'
import AddTransaction from './transactionsManagement/AddTransaction'

function App() {
  

  return (
    <BrowserRouter>
            <PageHeader/>
            <Routes>
                <Route path="/about" element={<AboutPage />} />
                <Route path = "/" element={<HomePage />} />
                <Route path="/find" element={<FindTransaction />} />
                <Route path="/add" element={<AddTransaction />} />
            </Routes>
        </BrowserRouter>
  )
}

export default App
