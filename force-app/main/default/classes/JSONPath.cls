public class JSONPath {
    private String raw;
    private Object data;

    public JSONPath(String rawJson) {
        this.raw = rawJson;
        this.data = JSON.deserializeUntyped(rawJson);
    }

    public Object get(String path) {
        try {
            Object o = this.get(path.removeStart('$'), this.data);
            return o;
        } catch (Exception e) {
            return null;
        }
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
                currentLevel.reverse().substringBetween(']', '[').reverse() +
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
                return result;
            }
            return dataList;
        }

        if (currentLevel.endsWith('()')) {
            switch on currentLevel.removeEnd('()') {
                when 'min' {
                    return this.getMin(dataList);
                }
                when 'max' {
                    return this.getMax(dataList);
                }
                when 'avg' {
                    return this.getAvg(dataList);
                }
                when 'sum' {
                    return this.getSum(dataList);
                }
                when 'length', 'size' {
                    return dataList.size();
                }
                when 'empty' {
                    return dataList.isEmpty();
                }
                when else {
                    throw new JSONPath.JSONPathException(
                        'Non-existing function "' +
                        currentLevel.removeEnd('()') +
                        '".'
                    );
                }
            }
        }

        Integer index = Integer.valueOf(
            currentLevel.substringBetween('[', ']')
        );

        return levels.size() == 0
            ? dataList.get(index)
            : this.get(String.join(levels, '.'), dataList.get(index));
    }

    private Double getMin(List<Object> numbers) {
        return getMinOrMax(numbers, true);
    }

    private Double getMax(List<Object> numbers) {
        return getMinOrMax(numbers, false);
    }

    private Double getMinOrMax(List<Object> numbers, Boolean isMin) {
        Double result;

        for (Object obj : numbers) {
            Double d = (Double) obj;
            if (result == null) {
                result = d;
                continue;
            }

            if (isMin) {
                if (d < result) {
                    result = d;
                }
            } else {
                if (d > result) {
                    result = d;
                }
            }
        }

        return result;
    }

    private Double getAvg(List<Object> numbers) {
        return getSum(numbers) / numbers.size();
    }

    private Double getSum(List<Object> numbers) {
        Double sum = 0;

        for (Object obj : numbers) {
            sum += obj != null ? (Double) obj : 0;
        }

        return sum;
    }

    public class JSONPathException extends Exception {
    }
}
