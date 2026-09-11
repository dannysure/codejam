import { useState } from "react";

const AddTransaction = () => {
    const [transactionDetails, setTransactionDetails] = useState({
        description: "",
        amount: "",
    });
    const [message, setMessage] = useState<string | null>(null);

    const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const { name, value } = e.target;
        setTransactionDetails((prevDetails) => ({
            ...prevDetails,
            [name]: value,
        }));
    };

    const handleAddTransaction = () => {
        const { description, amount } = transactionDetails;
        if (description && amount) {
            setMessage(`Transaction "${description}" with amount $${amount} added successfully.`);
            setTransactionDetails({ description: "", amount: "" });
        } else {
            setMessage("Please fill in all fields.");
        }
    };

    return (
        <div>
            <h1>Add a New Transaction</h1>
            <input
                type="text"
                name="description"
                placeholder="Transaction Description"
                value={transactionDetails.description}
                onChange={handleInputChange}
            />
            <input
                type="number"
                name="amount"
                placeholder="Transaction Amount"
                value={transactionDetails.amount}
                onChange={handleInputChange}
            />
            <button onClick={handleAddTransaction}>Add Transaction</button>
            {message && <p>{message}</p>}
        </div>
    );
};

export default AddTransaction;