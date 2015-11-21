<a name="2.0.0-alpha"></a>
# 2.0.0-alpha (2015-11-21)


### Breaking changes

* **Resource:** Change resource form being wait_for_service by default, you now need to add a wait-for-service=true to the directive
* **Models** Moved Member and Admin injector to their specific bower deps and changed them all to inject directly at run time
* **Models** Removed functions from being copied from BaseResource objects - which helps simplify all Models
* **Models ** change getxxxPromise to just $getxxx as the promise version