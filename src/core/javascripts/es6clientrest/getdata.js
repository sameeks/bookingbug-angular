function Es6AjaxGet(url) {
    return new Promise(function(resolve, reject) {
        let req = new XMLHttpRequest();

        req.open("GET", url);
        req.setRequestHeader("App-Key", 'f0bc4f65f4fbfe7b4b3b7264b655f5eb');
        req.setRequestHeader("App-Id", 'f6b16c23');

        req.onload = () => {
            if (req.status === 200) {
                resolve(req.response);
            } else {
                reject(new Error(req.statusText));
            }
        };
        req.onerror = () => {
            reject(new Error("Network error"));
        };
        req.send();
    });
}

// Example usage

//Es6AjaxGet('https://eu1.bookingbug.com/api/v1/company/37294')
//    .then(JSON.parse).then((r) =>{console.log(r,'--------ES6PROMISE GET');})
//    .catch(function(error) { console.log(error) });
