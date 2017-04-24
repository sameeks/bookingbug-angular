// THIS IS CRUFTY AND SHOULD BE REMOVE WITH AN API UPDATE THAT TIDIES UP THE SCEMA RESPONE
// fix the issues we have with the the sub client and question blocks being in doted notation, and
// not in child objects
angular.module('BBQueue.services').service('CheckSchema', ($q, BBModel) => {
    return function (schema) {
        for (let k in schema.properties) {
            let v = schema.properties[k];
            let vals = k.split(".");
            if ((vals[0] === "questions") && (vals.length > 1)) {
                if (!schema.properties.questions) {
                    schema.properties.questions = {type: "object", properties: {}};
                }
                if (!schema.properties.questions.properties[vals[1]]) {
                    schema.properties.questions.properties[vals[1]] = {
                        type: "object",
                        properties: {answer: v}
                    };
                }
            }
            if ((vals[0] === "client") && (vals.length > 2)) {
                if (!schema.properties.client) {
                    schema.properties.client = {
                        type: "object",
                        properties: {q: {type: "object", properties: {}}}
                    };
                }
                if (schema.properties.client.properties) {
                    if (!schema.properties.client.properties.q.properties[vals[2]]) {
                        schema.properties.client.properties.q.properties[vals[2]] = {
                            type: "object",
                            properties: {answer: v}
                        };
                    }
                }
            }
        }
        return schema;
    }
});
