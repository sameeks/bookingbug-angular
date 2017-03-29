function Es6AjaxPost(url,params) {

    let query = Object.keys(params)
        .map(k => encodeURIComponent(k) + '=' + encodeURIComponent(params[k]))
        .join('&');

    return new Promise(function(resolve, reject) {
        let req = new XMLHttpRequest();

        req.open("POST", url);
        req.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        req.setRequestHeader("Content-length", query.length);
        //req.setRequestHeader("App-Key", 'f0bc4f65f4fbfe7b4b3b7264b655f5eb');
        //req.setRequestHeader("App-Id", 'f6b16c23');

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

        req.send(query);

    });
}


//Example usage  //Note the Api could be inactive at time of testing. Please refer to BB booking API

//Es6AjaxPost('https://apipostget-diegomary.c9users.io/api/users',{id:'1234567',token:'This is the magic token', geo:'Location London and outskirts'})
//    .then(JSON.parse).then((r) =>{console.log(r,'--------ES6PROMISE POST');})
//    .catch(function(error) { console.log(error) });

