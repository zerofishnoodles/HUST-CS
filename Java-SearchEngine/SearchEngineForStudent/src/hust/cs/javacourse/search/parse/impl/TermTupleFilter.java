package hust.cs.javacourse.search.parse.impl;

import hust.cs.javacourse.search.index.AbstractTermTuple;
import hust.cs.javacourse.search.parse.AbstractTermTupleFilter;
import hust.cs.javacourse.search.parse.AbstractTermTupleStream;
import hust.cs.javacourse.search.util.Config;
import hust.cs.javacourse.search.util.StopWords;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Pattern;

public class TermTupleFilter extends AbstractTermTupleFilter {
    private List<String> stopWords = Arrays.asList(StopWords.STOP_WORDS);
    public TermTupleFilter(AbstractTermTupleStream input) {
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
        while (stopWords.contains(curTermTuple.term.getContent()) ||
                !Pattern.matches(Config.TERM_FILTER_PATTERN, curTermTuple.term.getContent()) ||
                        curTermTuple.term.getContent().length() < Config.TERM_FILTER_MINLENGTH ||
                            curTermTuple.term.getContent().length() > Config.TERM_FILTER_MAXLENGTH)
        {
            curTermTuple = input.next();
            if (curTermTuple == null) return null;
        }
        return curTermTuple;
    }

    /**
     * 实现父类AbstractTermTupleStream的close方法，关闭流
     */
    @Override
    public void close() {
        super.close();
    }
}
