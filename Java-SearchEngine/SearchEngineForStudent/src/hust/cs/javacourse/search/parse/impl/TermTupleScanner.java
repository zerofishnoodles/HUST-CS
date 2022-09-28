package hust.cs.javacourse.search.parse.impl;

import hust.cs.javacourse.search.index.AbstractTermTuple;
import hust.cs.javacourse.search.index.impl.Term;
import hust.cs.javacourse.search.index.impl.TermTuple;
import hust.cs.javacourse.search.parse.AbstractTermTupleScanner;
import hust.cs.javacourse.search.util.Config;
import hust.cs.javacourse.search.util.StringSplitter;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class TermTupleScanner extends AbstractTermTupleScanner {
    private List<AbstractTermTuple> termTuples = new ArrayList<>();
    private int pos;

    /**
     * 缺省构造函数
     */
    public TermTupleScanner() {
    }

    /**
     * 构造函数
     *
     * @param input ：指定输入流对象，应该关联到一个文本文件
     */
    public TermTupleScanner(BufferedReader input) {
        super(input);
        pos = 0;
    }

    /**
     * 获得下一个三元组
     *
     * @return: 下一个三元组；如果到了流的末尾，返回null
     */
    @Override
    public AbstractTermTuple next() {
        if (termTuples.isEmpty()){
            StringSplitter splitter = new StringSplitter();
            splitter.setSplitRegex(Config.STRING_SPLITTER_REGEX);
            try {
                String s = input.readLine();
                if (s == null) return null;
                List<String> list = splitter.splitByRegex(s);  //分词
                if (list.isEmpty()) return this.next();
                for (String term : list){
                    AbstractTermTuple termTuple = new TermTuple();
                    termTuple.term = new Term(Config.IGNORE_CASE ? term.toLowerCase() : term); //统一转成小写
                    termTuple.curPos = pos;
                    pos++;
                    termTuples.add(termTuple);
                }
            }catch (IOException e){
                e.printStackTrace();
            }
        }
        return termTuples.remove(0);
    }

    /**
     * 实现父类AbstractTermTupleStream的close方法，关闭流
     */
    @Override
    public void close() {
        super.close();
    }
}
