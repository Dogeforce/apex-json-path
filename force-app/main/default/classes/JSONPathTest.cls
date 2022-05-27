@IsTest
private class JSONPathTest {
    @IsTest
    static void test() {
        JSONPath jpObject = new JSONPath(
            '{"name":"John","company":{"name":"Company"}}'
        );
        System.assertEquals('John', jpObject.get('$.name'), 'Incorrect data.');
        System.assertEquals(
            'Company',
            jpObject.get('$.company.name'),
            'Incorrect data.'
        );
        JSONPath jpList = new JSONPath(
            '[{"name":"John","company":{"name":"Company"}}]'
        );
        System.assertEquals('John', jpList.get('$[0].name'), 'Incorrect data.');
        System.assert(
            jpList.get('$[]') instanceof List<Object>,
            'Should be a list.'
        );
        System.assert(
            jpList.get('$[0]') instanceof Map<String, Object>,
            'Should be an object.'
        );
        JSONPath jpListNested = new JSONPath(
            '[{"attr":[{"name":"John"},{"name":"Mary"}]}]'
        );
        System.assertEquals(
            'Mary',
            jpListNested.get('$[0].attr[1].name'),
            'Incorrect data.'
        );
        System.assert(
            jpListNested.get('$[].name') instanceof List<Object>,
            'Should have returned a list.'
        );
        JSONPath jpAttributeListFromObjectList = new JSONPath(
            '[{"name":"John"},{"name":"Mary"}]'
        );
        List<Object> names = (List<Object>) jpAttributeListFromObjectList.get(
            '$[].name'
        );
        System.assert(
            names[0] == 'John' &&
            names[1] == 'Mary',
            'Should have returned a list of names.'
        );
        JSONPath jpAttributeListFromInnerObjectList = new JSONPath(
            '{"people":[{"name":"John"},{"name":"Mary"}]}}'
        );
        names = (List<Object>) jpAttributeListFromInnerObjectList.get(
            '$.people[].name'
        );
        System.assert(
            names[0] == 'John' &&
            names[1] == 'Mary',
            'Should have returned a list of names.'
        );
        JSONPath invalidPath = new JSONPath(
            '{"messages":["Hello, world!", "Goodbye, world!"]}'
        );
        System.assertEquals(
            null,
            invalidPath.get('$.messages[-1]'),
            'Should have returned null for invalid path.'
        );

        JSONPath twoDigitsList = new JSONPath(
            '{"integers":[0,1,2,3,4,5,6,7,8,9,10]}'
        );
        System.assertEquals(
            10,
            twoDigitsList.get('$.integers[10]'),
            'Should have returned 10.'
        );

        JSONPath testArrayFunctions = new JSONPath('{"numbers":[1, 2, 3, 40]}');
        System.assertEquals(
            false,
            testArrayFunctions.get('$.numbers.empty()'),
            'Incorrect result for "empty".'
        );
        System.assertEquals(
            4,
            testArrayFunctions.get('$.numbers.length()'),
            'Incorrect result for "length".'
        );
        System.assertEquals(
            4,
            testArrayFunctions.get('$.numbers.size()'),
            'Incorrect result for "size".'
        );
        System.assertEquals(
            1,
            testArrayFunctions.get('$.numbers.min()'),
            'Incorrect result for "min".'
        );
        System.assertEquals(
            40,
            testArrayFunctions.get('$.numbers.max()'),
            'Incorrect result for "max".'
        );
        System.assertEquals(
            11.5,
            testArrayFunctions.get('$.numbers.avg()'),
            'Incorrect result for "avg".'
        );
    }
}
