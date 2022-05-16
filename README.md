# Apex JSON Path

This repository contains a minimum implementation of the [JSON Path Syntax](https://support.smartbear.com/alertsite/docs/monitors/api/endpoint/jsonpath.html). With this you can access data from a JSON string using a path specified by another string.

Might come in handy with integrations, specially, where one might have to read data from a JSON payload according to some specifications from data or metadata instead of deserializing the whole thing to an Apex type.

## Usage

To get an attribute value:

```apex
JSONPath j = new JSONPath('{"name":"John","company":{"name":"Company"}}');

String companyName = j.get('$.company.name');

System.assertEquals('Company', companyName, 'Wrong company name.');
```

It works for returning entire objects. So you could use `$.company` to get the `Object` that contains the company data (then you could cast it to a `Map<String, Object>` and access the `name` from there if you wanted to). This is also true for returning inner lists.

```apex
JSONPath jpListNested = new JSONPath('[{"attr":[{"name":"John"},{"name":"Mary"}]}]');

System.assertEquals(
    'Mary',
    jpListNested.get('$[0].attr[1].name'),
    'Incorrect data.'
);
```

Also works for returning specific attributes from inner lists. So if the JSON payload is a list or the object contains a list then it is reachable using the `[]` syntax:

```apex
JSONPath jpAttributeListFromObjectList = new JSONPath(
    '[{"name":"John"},{"name":"Mary"}]'
);
List<Object> names = (List<Object>) jpAttributeListFromObjectList.get('$[].name');
// names[0] = John and names[1] = 'Mary'

JSONPath jpAttributeListFromInnerObjectList = new JSONPath(
    '{"people":[{"name":"John"},{"name":"Mary"}]}}'
);
names = (List<Object>) jpAttributeListFromInnerObjectList.get('$.people[].name');
// names[0] = John and names[1] = 'Mary'
```
