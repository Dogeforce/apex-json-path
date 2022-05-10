@IsTest
private class JSONPathTest {
    @IsTest
    static void test() {
        JSONPath jpObject = new JSONPath(
            '{"name":"John","company":{"name":"Company"}}'
        );
        System.assertEquals(
            'John',
            jpObject.get('$.name'),
            'Incorrect data.'
        );
        System.assertEquals(
            'Company',
            jpObject.get('$.company.name'),
            'Incorrect data.'
        );
        JSONPath jpList = new JSONPath(
            '[{"name":"John","company":{"name":"Company"}}]'
        );
        System.assertEquals(
            'John',
            jpList.get('$[0].name'),
            'Incorrect data.'
        );
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
    }
}
