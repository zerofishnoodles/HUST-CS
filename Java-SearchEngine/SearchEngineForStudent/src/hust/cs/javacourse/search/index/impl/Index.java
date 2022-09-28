package hust.cs.javacourse.search.index.impl;

import hust.cs.javacourse.search.index.*;

import java.io.*;
import java.util.*;

/**
 * AbstractIndex的具体实现类
 */
public class Index extends AbstractIndex {

    public Index() {
    }

    /**
     * 返回索引的字符串表示
     *
     * @return 索引的字符串表示
     */
    @Override
    public String toString() {
        StringBuilder s = new StringBuilder();
        for(Map.Entry<AbstractTerm, AbstractPostingList> entry: this.termToPostingListMapping.entrySet()){
            s.append(entry.getKey().toString());
            s.append(":\n");
            s.append(entry.getValue().toString());
            s.append("-------------------------------\n");
        }
        return s.toString();
    }

    /**
     * 添加文档到索引，更新索引内部的HashMap
     *
     * @param document ：文档的AbstractDocument子类型表示
     */
    @Override
    public void addDocument(AbstractDocument document) {
        if (document == null) return;
        this.docIdToDocPathMapping.put(document.getDocId(), document.getDocPath());
        List<AbstractTermTuple> tuples = document.getTuples();   //获取三元组
        Map<AbstractTerm, AbstractPosting> termToPostingMapping = new HashMap<>();
        for(AbstractTermTuple tuple : tuples){  //通过三元组建立posting
            if (tuple == null) continue;
            if (!termToPostingMapping.containsKey(tuple.term)){    //若该词不存在在倒排索引中则新建一个key-value对
                AbstractPosting posting = new Posting();
                posting.setDocId(document.getDocId());
                posting.setFreq(tuple.freq);
                List<Integer> positions = new ArrayList<>();
                positions.add(tuple.curPos);
                posting.setPositions(positions);
                termToPostingMapping.put(tuple.term, posting);
            }else{   //存在则更新已有posting
                AbstractPosting posting = termToPostingMapping.get(tuple.term);
                posting.setFreq(posting.getFreq() + tuple.freq);
                posting.getPositions().add(tuple.curPos);
            }
        }
        for(Map.Entry<AbstractTerm, AbstractPosting> entry :termToPostingMapping.entrySet()){ //postinglList加入到倒排索引结构中
            if (entry == null) continue;
            if (!this.termToPostingListMapping.containsKey(entry.getKey())){
                AbstractPostingList postingList = new PostingList();
                postingList.add(entry.getValue());
                this.termToPostingListMapping.put(entry.getKey(), postingList);
            }else{
                this.termToPostingListMapping.get(entry.getKey()).add(entry.getValue());
            }
        }

    }

    /**
     * <pre>
     * 从索引文件里加载已经构建好的索引.内部调用FileSerializable接口方法readObject即可
     * @param file ：索引文件
     * </pre>
     */
    @Override
    public void load(File file) {
        try {
            this.readObject(new ObjectInputStream(new FileInputStream(file)));
        }catch (IOException e){
            e.printStackTrace();
        }

    }

    /**
     * <pre>
     * 将在内存里构建好的索引写入到文件. 内部调用FileSerializable接口方法writeObject即可
     * @param file ：写入的目标索引文件
     * </pre>
     */
    @Override
    public void save(File file) {
        try{
            System.out.println();
            this.writeObject(new ObjectOutputStream(new FileOutputStream(file)));
        } catch (IOException e){
            e.printStackTrace();
        }

    }

    /**
     * 返回指定单词的PostingList
     *
     * @param term : 指定的单词
     * @return ：指定单词的PostingList;如果索引字典没有该单词，则返回null
     */
    @Override
    public AbstractPostingList search(AbstractTerm term) {
        return this.termToPostingListMapping.get(term);
    }

    /**
     * 返回索引的字典.字典为索引里所有单词的并集
     *
     * @return ：索引中Term列表
     */
    @Override
    public Set<AbstractTerm> getDictionary() {
        return this.termToPostingListMapping.keySet();
    }

    /**
     * <pre>
     * 对索引进行优化，包括：
     *      对索引里每个单词的PostingList按docId从小到大排序
     *      同时对每个Posting里的positions从小到大排序
     * 在内存中把索引构建完后执行该方法
     * </pre>
     */
    @Override
    public void optimize() {
        for (AbstractTerm key : this.termToPostingListMapping.keySet()){
            AbstractPostingList postingList = this.termToPostingListMapping.get(key);
            postingList.sort();
            for (int i = 0; i<postingList.size(); i++){
                AbstractPosting posting = postingList.get(i);
                posting.getPositions().sort(Comparator.naturalOrder());
            }
        }
    }

    /**
     * 根据docId获得对应文档的完全路径名
     *
     * @param docId ：文档id
     * @return : 对应文档的完全路径名
     */
    @Override
    public String getDocName(int docId) {
        return this.docIdToDocPathMapping.get(docId);
    }

    /**
     * 写到二进制文件
     *
     * @param out :输出流对象
     */
    @Override
    public void writeObject(ObjectOutputStream out) {
        try{
            out.writeObject(this.docIdToDocPathMapping);
            out.writeObject(this.termToPostingListMapping);
        }catch (IOException e){
            e.printStackTrace();
        }
    }

    /**
     * 从二进制文件读
     *
     * @param in ：输入流对象
     */
    @Override
    public void readObject(ObjectInputStream in) {
        try{
            this.docIdToDocPathMapping = (Map<Integer, String>) in.readObject();
            this.termToPostingListMapping = (Map<AbstractTerm, AbstractPostingList>) in.readObject();
        }catch (IOException | ClassNotFoundException e){
            e.printStackTrace();
        }
    }
}
