//
// Created by Ray on 2021/10/23.
//

#include "TCPRdtReceiver.h"
#include <cassert>

TCPRdtReceiver::TCPRdtReceiver() {
    for (auto & item : this->receiveWin) {
        item.packet.acknum = -1;
        item.packet.seqnum = -1;
        item.hasPacket = false;
        for (auto & payload: item.packet.payload){
            payload = '.';
        }
        item.packet.checksum = pUtils->calculateCheckSum(item.packet);
    }
    this->base = 0;
    this->lastack.acknum = -1;
    this->lastack.seqnum = -1;
    for(auto &i : this->lastack.payload){
        i = '.';
    }
    this->lastack.checksum = pUtils->calculateCheckSum(this->lastack);
}

void TCPRdtReceiver::receive(const Packet &packet) {
    //打印window
    for(int i=0;i<4;i++){
        if (this->receiveWin[i].hasPacket){
            pUtils->printPacket("packet in the receive window", this->receiveWin[i].packet);
        }
    }

    //null_packet
    Packet null_packet;

    //计算checksum
    int checkSum = pUtils->calculateCheckSum(packet);

    //三种情况
    //1. 不在receiveWin内的包也要发ack
    //2. 在receiveWin中,但是seq!=base,此时需要将报文buffer,并发送上一个有序的ack
    //3. 在receiveWin中,且seq==base,此时需要按顺序递交所有连续的buffer的packet,并移动窗口，发送最后一个ack
    if (checkSum == packet.checksum){
        int packet_index = packet.seqnum - this->base;
        //特判,由于窗口空间是序号空间的一半,所以可以判断当序号距离小于-windowsize时,是当前轮的报文,而不是之前收到过的报文
        if (packet_index < -WINDOW_SIZE){
            packet_index = (packet_index+SEQ_SIZE)%SEQ_SIZE;
        }
        if (packet_index<0 || packet_index>=WINDOW_SIZE){
            //收到之前的报文
//            assert(1==0);
            pUtils->printPacket("receive prior packet", packet);
            //发送响应报文
            this->lastack.seqnum = -1;
            for(auto &i : this->lastack.payload){
                i = '.';
            }
            this->lastack.checksum = pUtils->calculateCheckSum(this->lastack);
            pUtils->printPacket("send last ack", lastack);
            pns->sendToNetworkLayer(SENDER, lastack);
        } else if (packet_index != 0){
            //将报文buffer
            this->receiveWin[packet_index].packet = packet;
            this->receiveWin[packet_index].hasPacket = true;
            pUtils->printPacket("receive packet that should buffer", packet);

            //发送响应报文
            this->lastack.seqnum = -1;
            for(auto &i : this->lastack.payload){
                i = '.';
            }
            this->lastack.checksum = pUtils->calculateCheckSum(this->lastack);
            pUtils->printPacket("send last ack", lastack);
            pns->sendToNetworkLayer(SENDER, lastack);

        }else{
            //首先加入当前的packet
            this->receiveWin[packet_index].packet = packet;
            this->receiveWin[packet_index].hasPacket = true;
            pUtils->printPacket("receive packet", packet);

            //递交报文
            int packet_num=0; //要递交的数量
            while (this->receiveWin[packet_num].hasPacket && packet_num<WINDOW_SIZE){
                Packet p = this->receiveWin[packet_num].packet;
                pUtils->printPacket("deliver packet", p);
                Message m;
                memcpy(m.data, p.payload, sizeof(p.payload));
                pns->delivertoAppLayer(RECEIVER, m);
                packet_num++;
            }

            assert(packet_num>0);  //debug

            //移动窗口
            base = (base + packet_num)%SEQ_SIZE ;  //base空间大小和报文序号空间大小一致
            for(int k=0;k<packet_num;k++){
                for (int i = 1; i < WINDOW_SIZE; ++i) {
                    this->receiveWin[i-1] = this->receiveWin[i];
                    this->receiveWin[i].hasPacket = false;
                    this->receiveWin[i].packet = null_packet;
                }
            }
            assert(this->receiveWin[0].hasPacket == false);  //debug

            //更新响应报文
            this->lastack.acknum = base-1<0 ? base-1+SEQ_SIZE: base-1;

            //发送响应报文
            this->lastack.seqnum = -1;
            for(auto &i : this->lastack.payload){
                i = '.';
            }
            this->lastack.checksum = pUtils->calculateCheckSum(this->lastack);
            pUtils->printPacket("send new ack", this->lastack);
            pns->sendToNetworkLayer(SENDER, lastack);
        }

    } else{
        pUtils->printPacket("the packet is corrupt!", packet);
        //发送响应报文
        this->lastack.seqnum = -1;
        for(auto &i : this->lastack.payload){
            i = '.';
        }
        this->lastack.checksum = pUtils->calculateCheckSum(this->lastack);
        pUtils->printPacket("send last ack", lastack);
        pns->sendToNetworkLayer(SENDER, lastack);
    }
}

TCPRdtReceiver::~TCPRdtReceiver() = default;

//
// Created by Ray on 2021/10/15.
//

//#include "TCPRdtReceiver.h"
//
//TCPRdtReceiver::TCPRdtReceiver() {
//    this->expectSequenceNumberRcvd = 0;
//    this->lastAckPkt.acknum = -1;
//    this->lastAckPkt.seqnum = -1; //响应报文无序号
//    for (char & i : this->lastAckPkt.payload) {
//        i = '.';
//    }
//    this->lastAckPkt.checksum = pUtils->calculateCheckSum(lastAckPkt);
//}
//
//void TCPRdtReceiver::receive(const Packet &packet) {
//    //检查校验和和序号
//    int checkSum = pUtils->calculateCheckSum(packet);
//    if (checkSum == packet.checksum && packet.seqnum == this->expectSequenceNumberRcvd){
//        //检验和和序号正确
//        //抽取message并传输到应用层
//        Message m;
//        memcpy(m.data, packet.payload, sizeof(packet.payload));
//        pUtils->printPacket("receive packet", packet);
//        pns->delivertoAppLayer(RECEIVER, m);
//
//        //构建并发送响应报文
//        this->lastAckPkt.seqnum = -1; //响应报文忽略seqnum
//        this->lastAckPkt.acknum = packet.seqnum;
//        this->lastAckPkt.checksum = pUtils->calculateCheckSum(lastAckPkt);
//        pUtils->printPacket("send ack", lastAckPkt);
//        pns->sendToNetworkLayer(SENDER, lastAckPkt);
//
//        //更新变量
//        this->expectSequenceNumberRcvd = (this->expectSequenceNumberRcvd + 1) % SEQ_SIZE;
//    }
//    else{
//        if (checkSum != packet.checksum){
//            pUtils->printPacket("receiver received failed, the packet is corrupt!", packet);
//        }else{
//            pUtils->printPacket("receiver received failed, the packet sequence is wrong!", packet);
//        }
//        pUtils->printPacket("send last ack", lastAckPkt);
//        pns->sendToNetworkLayer(SENDER, lastAckPkt);
//    }
//}
//
//TCPRdtReceiver::~TCPRdtReceiver() noexcept {}
