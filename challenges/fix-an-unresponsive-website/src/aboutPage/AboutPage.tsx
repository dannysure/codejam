import {useState} from "react";
import Credits from "../credits/Credits";

const AboutPage = () => {

    const [showCredits, setShowCredits] = useState(false);

    const handleClick = () => {
        setShowCredits(!showCredits);
    }

    return (
        <div>
        <h1>About Page</h1>
        <p>This is the payments app</p>
            <button onClick={handleClick}>{showCredits ? "hide" : "show"} credits</button>
            {showCredits && <Credits />}
        </div>
    );
}

export default AboutPage;
