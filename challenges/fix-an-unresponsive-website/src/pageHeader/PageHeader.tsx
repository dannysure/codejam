import Menu from './Menu';
import './pageHeader.css';
import {Link} from "react-router-dom";

const PageHeader = () => {
    return (
        <div className="pageHeader">
            <h1><Link to="/">Demo Application</Link></h1>
            <Menu/>
        </div>
    );
}

export default PageHeader
