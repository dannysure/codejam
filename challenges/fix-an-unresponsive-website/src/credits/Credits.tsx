const Credits = () => {

    const credits = [
        {name: "John", role: "developer"},
        {name: "Jane", role: "developer"},
        {name: "Jack", role: "developer"},
        {name: "Jill", role: "developer"},
        {name: "James", role: "developer"},
        {name: "Jenny", role: "developer"},
        {name: "Jade", role: "developer"},
        {name: "Jasmine", role: "developer"},
        {name: "Jasper", role: "developer"},
        {name: "Jared", role: "developer"},
        {name: "Jocelyn", role: "developer"},
        {name: "Jude", role: "developer"},
        {name: "Jules", role: "developer"},
        {name: "Julian", role: "developer"},
        {name: "Julia", role: "developer"}]

    const DisplayCredit =  (props: {credit: {name: string, role: string}}) => {
        const start = performance.now();
        while(performance.now() -  start  < 100) {
            //do nothing - create a delay to simulate a long operation
        }
        return <p>{props.credit.name} - {props.credit.role}</p>;
    }


    const data = [];

    for (let i = 0; i < credits.length; i++) {
        data.push(<DisplayCredit key={i} credit={credits[i]} />);
    }

    return (<div>This app was written by:
        {data}
    </div>)

}

export default Credits;
