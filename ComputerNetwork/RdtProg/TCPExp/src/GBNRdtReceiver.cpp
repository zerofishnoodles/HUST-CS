//
// Created by Ray on 2021/10/15.
//

#include "GBNRdtReceiver.h"

GBNRdtReceiver::GBNRdtReceiver() {
    this->expectSequenceNumberRcvd = 0;
    this->lastAckPkt.acknum = -1;
    this->lastAckPkt.seqnum = -1; //��Ӧ���������
    for (char & i : this->lastAckPkt.payload) {
        i = '.';
    }
    this->lastAckPkt.checksum = pUtils->calculateCheckSum(lastAckPkt);
}

void GBNRdtReceiver::receive(const Packet &packet) {
    //���У��ͺ����
    int checkSum = pUtils->calculateCheckSum(packet);
    if (checkSum == packet.checksum && packet.seqnum == this->expectSequenceNumberRcvd){
        //����ͺ������ȷ
        //��ȡmessage�����䵽Ӧ�ò�
        Message m;
        memcpy(m.data, packet.payload, sizeof(packet.payload));
        pUtils->printPacket("receive packet", packet);
        pns->delivertoAppLayer(RECEIVER, m);

        //������������Ӧ����
        this->lastAckPkt.seqnum = -1; //��Ӧ���ĺ���seqnum
        this->lastAckPkt.acknum = packet.seqnum;
        this->lastAckPkt.checksum = pUtils->calculateCheckSum(lastAckPkt);
        pUtils->printPacket("send ack", lastAckPkt);
        pns->sendToNetworkLayer(SENDER, lastAckPkt);

        //���±���
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
