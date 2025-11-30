export const handler = async (event) => {
    const url = process.env.APP_DOMAIN;

    if (!url) {
        return {
            statusCode: 500,
            body: JSON.stringify({ error: "APP_DOMAIN environment variable is not set" }),
        };
    }

    try {
        const response = await fetch(url);
        const data = await response.text(); // use .json() if your API returns JSON

        console.log("Response from endpoint:", data);

        return {
            statusCode: 200,
            body: data,
        };
    } catch (err) {
        console.error("Error calling endpoint:", err);

        return {
            statusCode: 500,
            body: JSON.stringify({ error: err.message }),
        };
    }
};
