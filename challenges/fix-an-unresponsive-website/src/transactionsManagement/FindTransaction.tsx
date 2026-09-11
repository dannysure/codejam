import { useState } from "react";

const FindTransaction = () => {
    const [transactionId, setTransactionId] = useState("");
    const [result, setResult] = useState<string | null>(null);

    const handleSearch = () => {
        // Simulate a search operation
        if (transactionId) {
            setResult(`Transaction with ID: ${transactionId} found.`);
        } else {
            setResult("Please enter a transaction ID.");
        }
    };

    return (
        <div>
            <h1>Find a Transaction</h1>
            <input
                type="text"
                placeholder="Enter transaction ID"
                value={transactionId}
                onChange={(e) => setTransactionId(e.target.value)}
            />
            <button onClick={handleSearch}>Search</button>
            {result && <p>{result}</p>}
        </div>
    );
};

export default FindTransaction;