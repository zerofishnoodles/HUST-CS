//
// Created by Ray on 2021/10/15.
//

#include "GBNRdtReceiver.h"

GBNRdtReceiver::GBNRdtReceiver() {
    this->expectSequenceNumberRcvd = 0;
    this->lastAckPkt.acknum = -1;
    this->lastAckPkt.seqnum = -1; //响应报文无序号
    for (char & i : this->lastAckPkt.payload) {
        i = '.';
    }
    this->lastAckPkt.checksum = pUtils->calculateCheckSum(lastAckPkt);
}

void GBNRdtReceiver::receive(const Packet &packet) {
    //检查校验和和序号
    int checkSum = pUtils->calculateCheckSum(packet);
    if (checkSum == packet.checksum && packet.seqnum == this->expectSequenceNumberRcvd){
        //检验和和序号正确
        //抽取message并传输到应用层
        Message m;
        memcpy(m.data, packet.payload, sizeof(packet.payload));
        pUtils->printPacket("receive packet", packet);
        pns->delivertoAppLayer(RECEIVER, m);

        //构建并发送响应报文
        this->lastAckPkt.seqnum = -1; //响应报文忽略seqnum
        this->lastAckPkt.acknum = packet.seqnum;
        this->lastAckPkt.checksum = pUtils->calculateCheckSum(lastAckPkt);
        pUtils->printPacket("send ack", lastAckPkt);
        pns->sendToNetworkLayer(SENDER, lastAckPkt);

        //更新变量
        this->expectSequenceNumberRcvd = (this->expectSequenceNumberRcvd + 1) % SEQ_SIZE;
    }
    else{
        if (checkSum != packet.checksum){
            pUtils->printPacket("receiver received failed, the packet is corrupt!", packet);
        }else{
            pUtils->printPacket("receiver received failed, the packet sequence is wrong!", packet);
        }
        pUtils->printPacket("send last ack", lastAckPkt);
        pns->sendToNetworkLayer(SENDER, lastAckPkt);
    }
}

GBNRdtReceiver::~GBNRdtReceiver() noexcept {}
