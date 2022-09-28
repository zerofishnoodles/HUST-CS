package hust.cs.javacourse.search.query.impl;

import hust.cs.javacourse.search.index.AbstractPosting;
import hust.cs.javacourse.search.index.AbstractPostingList;
import hust.cs.javacourse.search.index.AbstractTerm;
import hust.cs.javacourse.search.query.AbstractHit;
import hust.cs.javacourse.search.query.AbstractIndexSearcher;
import hust.cs.javacourse.search.query.Sort;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class IndexSearcher extends AbstractIndexSearcher {
    public IndexSearcher() {
    }

    /**
     * 从指定索引文件打开索引，加载到index对象里. 一定要先打开索引，才能执行search方法
     *
     * @param indexFile ：指定索引文件
     */
    @Override
    public void open(String indexFile) {
        this.index.load(new File(indexFile));
    }

    /**
     * 根据单个检索词进行搜索
     *
     * @param queryTerm ：检索词
     * @param sorter    ：排序器
     * @return ：命中结果数组
     */
    @Override
    public AbstractHit[] search(AbstractTerm queryTerm, Sort sorter) {
        List<AbstractHit> hitList = new ArrayList<>();
        AbstractPostingList postingList = this.index.search(queryTerm);
        if (postingList == null) return null;
        for (int i=0; i<postingList.size(); i++){
            AbstractPosting posting = postingList.get(i);
            Map<AbstractTerm, AbstractPosting> termPostingMapping = new HashMap<>();
            termPostingMapping.put(queryTerm, posting);
            AbstractHit hit = new Hit(posting.getDocId(), this.index.getDocName(posting.getDocId()), termPostingMapping);
            hitList.add(hit);
        }
        sorter.sort(hitList);
        return hitList.toArray(new AbstractHit[0]);
    }

    /**
     * 根据二个检索词进行搜索
     *
     * @param queryTerm1 ：第1个检索词
     * @param queryTerm2 ：第2个检索词
     * @param sorter     ：    排序器
     * @param combine    ：   多个检索词的逻辑组合方式
     * @return ：命中结果数组
     */
    @Override
    public AbstractHit[] search(AbstractTerm queryTerm1, AbstractTerm queryTerm2, Sort sorter, LogicalCombination combine) {
        List<AbstractHit> hitList = new ArrayList<>();
        AbstractPostingList postingList1 = this.index.search(queryTerm1);
        AbstractPostingList postingList2 = this.index.search(queryTerm2);
        if (combine.compareTo(LogicalCombination.AND) == 0){   //两个词同时出现
            for (int i=0; i<postingList1.size(); i++){
                AbstractPosting posting = postingList1.get(i);
                for(int j=0;j<postingList2.size();j++) {
                    AbstractPosting posting2 = postingList2.get(j);
                    if (posting2.getDocId() == posting.getDocId()) {  //两个posting的docID一样说明两个词同时出现在这个doc中
                        Map<AbstractTerm, AbstractPosting> termPostingMapping = new HashMap<>();
                        termPostingMapping.put(queryTerm1, posting);
                        termPostingMapping.put(queryTerm2, posting2);
                        AbstractHit hit = new Hit(posting.getDocId(), this.index.getDocName(posting.getDocId()), termPostingMapping);
                        hitList.add(hit);
                    }
                }
            }
        }else{
            for (int i=0; i<postingList1.size(); i++){  //其实就是加两遍
                AbstractPosting posting = postingList1.get(i);
                Map<AbstractTerm, AbstractPosting> termPostingMapping = new HashMap<>();
                termPostingMapping.put(queryTerm1, posting);
                AbstractHit hit = new Hit(posting.getDocId(), this.index.getDocName(posting.getDocId()), termPostingMapping);
                hitList.add(hit);
            }
            for (int i=0; i<postingList2.size(); i++){
                AbstractPosting posting = postingList2.get(i);
                Map<AbstractTerm, AbstractPosting> termPostingMapping = new HashMap<>();
                termPostingMapping.put(queryTerm1, posting);
                AbstractHit hit = new Hit(posting.getDocId(), this.index.getDocName(posting.getDocId()), termPostingMapping);
                hitList.add(hit);
            }
        }
        sorter.sort(hitList);
        AbstractHit[] hits=new AbstractHit[hitList.size()];
        return (AbstractHit[]) hitList.toArray(hits);
    }

    /**
     * 根据两个词搜索这两个词需相邻的结果
     * @param queryTerm1 ：第一个检索词
     * @param queryTerm2 ： 第二个检索词
     * @param sorter ：排序器
     * @return
     */
    public AbstractHit[] search_fixPos(AbstractTerm queryTerm1, AbstractTerm queryTerm2, Sort sorter) {
        List<AbstractHit> hitList = new ArrayList<>();
        AbstractPostingList postingList1 = this.index.search(queryTerm1);
        AbstractPostingList postingList2 = this.index.search(queryTerm2);
        for (int i=0; i<postingList1.size(); i++){
            AbstractPosting posting = postingList1.get(i);
            for(int j=0;j<postingList2.size();j++) {
                AbstractPosting posting2 = postingList2.get(j);
                if (posting2.getDocId() == posting.getDocId()) {  //两个posting的docID一样说明两个词同时出现在这个doc
                    if (isNeighbor(posting,posting2)){
                        Map<AbstractTerm, AbstractPosting> termPostingMapping = new HashMap<>();
                        termPostingMapping.put(queryTerm1, posting);
                        termPostingMapping.put(queryTerm2, posting2);
                        AbstractHit hit = new Hit(posting.getDocId(), this.index.getDocName(posting.getDocId()), termPostingMapping);
                        hitList.add(hit);
                    }
                }
            }
        }
        sorter.sort(hitList);
        AbstractHit[] hits=new AbstractHit[hitList.size()];
        return (AbstractHit[]) hitList.toArray(hits);
    }

    public boolean isNeighbor(AbstractPosting p1, AbstractPosting p2){
        List<Integer> list1 = p1.getPositions();
        List<Integer> list2 = p2.getPositions();
        for (int i : list1){
            for (int j: list2){
                int k = i-j;
                if (Math.abs(k) == 1) return true;
            }
        }
        return false;
    }

    /**
     * 对任意数量单词进行搜索（OR）
     * @param terms 单词list
     * @param sorter 排序器
     * @return
     */
    public AbstractHit[] search(List<AbstractTerm> terms, Sort sorter) {
        List<AbstractHit> hitList = new ArrayList<>();
        for (AbstractTerm term : terms){
            AbstractPostingList postingList = this.index.search(term);
            if (postingList == null) return null;
            for (int i=0; i<postingList.size(); i++){
                AbstractPosting posting = postingList.get(i);
                Map<AbstractTerm, AbstractPosting> termPostingMapping = new HashMap<>();
                termPostingMapping.put(term, posting);
                AbstractHit hit = new Hit(posting.getDocId(), this.index.getDocName(posting.getDocId()), termPostingMapping);
                hitList.add(hit);
            }
        }
        sorter.sort(hitList);
        AbstractHit[] hits=new AbstractHit[hitList.size()];
        return (AbstractHit[]) hitList.toArray(hits);
    }

}
