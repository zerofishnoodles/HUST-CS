package hust.cs.javacourse.search.parse.impl;

import hust.cs.javacourse.search.index.AbstractTermTuple;
import hust.cs.javacourse.search.parse.AbstractTermTupleFilter;
import hust.cs.javacourse.search.parse.AbstractTermTupleStream;
import hust.cs.javacourse.search.util.Config;
import hust.cs.javacourse.search.util.StopWords;

import java.util.Arrays;
import java.util.List;
import java.util.regex.Pattern;

public class StopWordTermTupleFilter extends AbstractTermTupleFilter {
    private static List<String> stopWords = Arrays.asList(StopWords.STOP_WORDS);

    public StopWordTermTupleFilter(AbstractTermTupleStream input) {
        super(input);
    }

    /**
     * 获得下一个三元组
     *
     * @return: 下一个三元组；如果到了流的末尾，返回null
     */
    @Override
    public AbstractTermTuple next() {
        AbstractTermTuple curTermTuple = input.next();
        if (curTermTuple == null) return null;
        while (stopWords.contains(curTermTuple.term.getContent()))
        {
            curTermTuple = input.next();
            if (curTermTuple == null) return null;
        }
        return curTermTuple;
    }
}
