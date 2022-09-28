package hust.cs.javacourse.search.run;

import hust.cs.javacourse.search.index.AbstractTerm;
import hust.cs.javacourse.search.index.AbstractTermTuple;
import hust.cs.javacourse.search.index.impl.Term;
import hust.cs.javacourse.search.query.AbstractHit;
import hust.cs.javacourse.search.query.AbstractIndexSearcher;
import hust.cs.javacourse.search.query.Sort;
import hust.cs.javacourse.search.query.impl.AttentionSorter;
import hust.cs.javacourse.search.query.impl.IndexSearcher;
import hust.cs.javacourse.search.query.impl.SimpleSorter;
import hust.cs.javacourse.search.util.Config;

import java.util.ArrayList;
import java.util.List;

/**
 * 测试搜索
 */
public class TestSearchIndex {
    /**
     *  搜索程序入口
     * @param args ：命令行参数
     */
    public static void main(String[] args){
//        Sort simpleSorter = new SimpleSorter();
        Sort attentionSorter = new AttentionSorter();
        String indexFile = Config.INDEX_DIR + "index.dat";
        AbstractIndexSearcher searcher = new IndexSearcher();
        searcher.open(indexFile);
        List<AbstractTerm> terms = new ArrayList<>();
//        terms.add(new Term("fizzy"));
//        terms.add(new Term("google"));
//        terms.add(new Term("marketplace"));
//        AbstractHit[] hits = ((IndexSearcher) searcher).search(terms, simpleSorter);
        AbstractHit[] hits = searcher.search(new Term("activity"), new Term("benefits"), attentionSorter, AbstractIndexSearcher.LogicalCombination.AND);
        for(AbstractHit hit : hits){ System.out.println(hit); }
    }
}
