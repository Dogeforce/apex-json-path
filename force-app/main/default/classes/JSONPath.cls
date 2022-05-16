public class JSONPath {
    private String raw;
    private Object data;

    public JSONPath(String rawJson) {
        this.raw = rawJson;
        this.data = JSON.deserializeUntyped(rawJson);
    }

    public Object get(String path) {
        return this.get(path.removeStart('$'), this.data);
    }

    private Object get(String path, Object data) {
        Boolean isObject = data instanceof Map<String, Object>;
        Boolean isList = data instanceof List<Object>;

        List<String> levels = path.removeStart('.').split('\\.');
        String currentLevel = levels.remove(0);

        if (isObject) {
            return handleObject(currentLevel, levels, data);
        }

        if (isList) {
            return handleList(currentLevel, levels, data);
        }

        return null;
    }

    private Object handleObject(
        String currentLevel,
        List<String> levels,
        Object data
    ) {
        Map<String, Object> d = (Map<String, Object>) data;

        if (currentLevel.endsWith(']')) {
            return this.get(
                ('[' +
                currentLevel.reverse().substringBetween(']', '[') +
                '].' +
                String.join(levels, '.')),
                d.get(currentLevel.split('\\[').remove(0))
            );
        }

        return levels.size() == 0
            ? d.get(currentLevel)
            : this.get(String.join(levels, '.'), d.get(currentLevel));
    }

    private Object handleList(
        String currentLevel,
        List<String> levels,
        Object data
    ) {
        List<Object> dataList = (List<Object>) data;
        if (currentLevel.startsWith('[]')) {
            if (levels.size() > 0) {
                List<Object> result = new List<Object>();
                for (Object objectInstance : dataList) {
                    result.add(
                        this.get(String.join(levels, '.'), objectInstance)
                    );
                }
                System.debug(result);
                return result;
            }
            return dataList;
        }

        Integer index = getIndex(currentLevel);

        return levels.size() == 0
            ? dataList.get(index)
            : this.get(String.join(levels, '.'), dataList.get(index));
    }

    private Integer getIndex(String currentLevel) {
        String indexStr = currentLevel.substringBetween('[', ']');

        if (indexStr == null) {
            String m = 'Invalid path.';
            JSONPathException e = new JSONPathException(m);
            e.setMessage(m);
            throw e;
        }

        return Integer.valueOf(indexStr);
    }

    public class JSONPathException extends Exception {
    }
}
