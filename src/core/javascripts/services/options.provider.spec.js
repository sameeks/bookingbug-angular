describe('bbOptionsProvider.setValue method', function () {

    let _bbOptionsProvider = null;

    let testOptions = {
        testBoolean: true,
        testString: 'string',
        testArray: ['a', 'b'],
        testObject: {
            internalObject: {
                someBoolean: true,
                someString: 'some string',
                someArray: ['c', 'd']
            },
            internalBoolean: true,
            internalString: 'internal string',
            internalArray: ['e', 'f']
        }
    };

    beforeEach(function () {
        module('BB');

        module(function (bbOptionsProvider) {
            _bbOptionsProvider = bbOptionsProvider;
        });

        inject(function () {
        });
    });

    it('allows to override testBoolean', function () {
        let testBoolean = false;
        let newOptions = _bbOptionsProvider.setOption(testOptions, 'testBoolean', testBoolean);
        expect(newOptions.testBoolean).toBe(testBoolean);
    });

    it('allows to override testString', function () {
        let testString = 'overriden';
        let newOptions = _bbOptionsProvider.setOption(testOptions, 'testString', testString);
        expect(newOptions.testString).toBe(testString);
    });

    it('allows to override testArray', function () {
        let testArray = [1, 2, 3];
        let newOptions = _bbOptionsProvider.setOption(testOptions, 'testArray', testArray);
        expect(newOptions.testArray).toBe(testArray);
    });

    it('allows to override testObject.internalObject.someArray', function () {
        let testArray = [1, 2, 3];
        let newOptions = _bbOptionsProvider.setOption(testOptions, 'testObject', {
            internalObject: {
                someArray: testArray
            }
        });
        expect(newOptions.testObject.internalObject.someArray).toBe(testArray);
    });

    it('allows to override testObject.internalString', function () {
        let internalString = 'abc';
        let newOptions = _bbOptionsProvider.setOption(testOptions, 'testObject', {
            internalString: internalString
        });
        expect(newOptions.testObject.internalString).toBe(internalString);
    });

    describe('will throw error when', function () {
        it('you try to assign boolean value to string value', function () {
            expect(() => _bbOptionsProvider.setOption(testOptions, 'testString', true))
                .toThrow(jasmine.stringMatching(/required type is "string"/));
        });

        it('you try to assign array value to string value', function () {
            expect(() => _bbOptionsProvider.setOption(testOptions, 'testString', [1, 2, 3]))
                .toThrow(jasmine.stringMatching(/required type is "string"/));
        });

        it('you try to assign object value to string value', function () {
            expect(() => _bbOptionsProvider.setOption(testOptions, 'testString', {}))
                .toThrow(jasmine.stringMatching(/required type is "string"/));
        });

        it('you try to assign boolean value to array value', function () {
            expect(() => _bbOptionsProvider.setOption(testOptions, 'testObject', {
                internalObject: {
                    someArray: true
                }
            })).toThrow(jasmine.stringMatching(/required type is "array"/));
        });

        it('you try to assign array value to object value', function () {
            expect(() => _bbOptionsProvider.setOption(testOptions, 'testObject', {
                internalObject: []
            })).toThrow(jasmine.stringMatching(/must be an object/));
        });
    });
});
