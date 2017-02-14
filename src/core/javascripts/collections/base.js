// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
window.Collection = class Collection {
};

window.Collection.Base = class Base {

    constructor(res, items, params) {
        this.res = res;
        this.items = items;
        this.params = params;
        this.callbacks = [];

        let clean_params = {};
        for (let key in params) {
            let val = params[key];
            if (val != null) {
                if (val.id != null) {
                    clean_params[key + "_id"] = val.id;
                } else {
                    clean_params[key] = val;
                }
            }
        }
        this.jparams = JSON.stringify(clean_params);
        if (res) {
            for (let n in res) {
                let m = res[n];
                this[n] = m;
            }
        }
    }

    checkItem(item) {
        let call;
        if (!this.matchesParams(item)) {
            this.deleteItem(item);  //delete if it is in the collection at the moment
            return true;
        } else {
            for (let index = 0; index < this.items.length; index++) {
                let existingItem = this.items[index];
                if (item.self === existingItem.self) {
                    this.items[index] = item;
                    for (call of Array.from(this.callbacks)) {
                        call[1](item, "update");
                    }
                    return true;
                }
            }
        }

        this.items.push(item);
        return (() => {
            let result = [];
            for (call of Array.from(this.callbacks)) {
                result.push(call[1](item, "add"));
            }
            return result;
        })();
    }

    deleteItem(item) {
        let len = this.items.length;
        this.items = this.items.filter(x => x.self !== item.self);
        if (this.items.length !== len) {
            return Array.from(this.callbacks).map((call) =>
                call[1](item, "delete"));
        }
    }

    getItems() {
        return this.items;
    }

    addCallback(obj, fn) {
        for (let call of Array.from(this.callbacks)) {
            if (call[0] === obj) {
                return;
            }
        }
        return this.callbacks.push([obj, fn]);
    }

    matchesParams(item) {
        return true;
    }
};


window.BaseCollections = class BaseCollections {

    constructor() {
        this.collections = [];
    }

    count() {
        return this.collections.length;
    }

    add(col) {
        return this.collections.push(col);
    }

    checkItems(item) {
        return Array.from(this.collections).map((col) =>
            col.checkItem(item));
    }

    deleteItems(item) {
        return Array.from(this.collections).map((col) =>
            col.deleteItem(item));
    }

    find(prms) {
        let clean_params = {};
        for (let key in prms) {
            let val = prms[key];
            if (val != null) {
                if (val.id != null) {
                    clean_params[key + "_id"] = val.id;
                } else {
                    clean_params[key] = val;
                }
            }
        }
        let jprms = JSON.stringify(clean_params);
        for (let col of Array.from(this.collections)) {
            if (jprms === col.jparams) {
                return col;
            }
        }
    }

    delete(col) {
        return this.collections = _.without(this.collections, col);
    }
};

