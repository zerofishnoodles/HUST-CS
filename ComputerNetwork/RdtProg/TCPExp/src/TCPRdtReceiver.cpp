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
    //��ӡwindow
    for(int i=0;i<4;i++){
        if (this->receiveWin[i].hasPacket){
            pUtils->printPacket("packet in the receive window", this->receiveWin[i].packet);
        }
    }

    //null_packet
    Packet null_packet;

    //����checksum
    int checkSum = pUtils->calculateCheckSum(packet);

    //�������
    //1. ����receiveWin�ڵİ�ҲҪ��ack
    //2. ��receiveWin��,����seq!=base,��ʱ��Ҫ������buffer,��������һ�������ack
    //3. ��receiveWin��,��seq==base,��ʱ��Ҫ��˳��ݽ�����������buffer��packet,���ƶ����ڣ��������һ��ack
    if (checkSum == packet.checksum){
        int packet_index = packet.seqnum - this->base;
        //����,���ڴ��ڿռ�����ſռ��һ��,���Կ����жϵ���ž���С��-windowsizeʱ,�ǵ�ǰ�ֵı���,������֮ǰ�յ����ı���
        if (packet_index < -WINDOW_SIZE){
            packet_index = (packet_index+SEQ_SIZE)%SEQ_SIZE;
        }
        if (packet_index<0 || packet_index>=WINDOW_SIZE){
            //�յ�֮ǰ�ı���
//            assert(1==0);
            pUtils->printPacket("receive prior packet", packet);
            //������Ӧ����
            this->lastack.seqnum = -1;
            for(auto &i : this->lastack.payload){
                i = '.';
            }
            this->lastack.checksum = pUtils->calculateCheckSum(this->lastack);
            pUtils->printPacket("send last ack", lastack);
            pns->sendToNetworkLayer(SENDER, lastack);
        } else if (packet_index != 0){
            //������buffer
            this->receiveWin[packet_index].packet = packet;
            this->receiveWin[packet_index].hasPacket = true;
            pUtils->printPacket("receive packet that should buffer", packet);

            //������Ӧ����
            this->lastack.seqnum = -1;
            for(auto &i : this->lastack.payload){
                i = '.';
            }
            this->lastack.checksum = pUtils->calculateCheckSum(this->lastack);
            pUtils->printPacket("send last ack", lastack);
            pns->sendToNetworkLayer(SENDER, lastack);

        }else{
            //���ȼ��뵱ǰ��packet
            this->receiveWin[packet_index].packet = packet;
            this->receiveWin[packet_index].hasPacket = true;
            pUtils->printPacket("receive packet", packet);

            //�ݽ�����
            int packet_num=0; //Ҫ�ݽ�������
            while (this->receiveWin[packet_num].hasPacket && packet_num<WINDOW_SIZE){
                Packet p = this->receiveWin[packet_num].packet;
                pUtils->printPacket("deliver packet", p);
                Message m;
                memcpy(m.data, p.payload, sizeof(p.payload));
                pns->delivertoAppLayer(RECEIVER, m);
                packet_num++;
            }

            assert(packet_num>0);  //debug

            //�ƶ�����
            base = (base + packet_num)%SEQ_SIZE ;  //base�ռ��С�ͱ�����ſռ��Сһ��
            for(int k=0;k<packet_num;k++){
                for (int i = 1; i < WINDOW_SIZE; ++i) {
                    this->receiveWin[i-1] = this->receiveWin[i];
                    this->receiveWin[i].hasPacket = false;
                    this->receiveWin[i].packet = null_packet;
                }
            }
            assert(this->receiveWin[0].hasPacket == false);  //debug

            //������Ӧ����
            this->lastack.acknum = base-1<0 ? base-1+SEQ_SIZE: base-1;

            //������Ӧ����
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
        //������Ӧ����
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
//    this->lastAckPkt.seqnum = -1; //��Ӧ���������
//    for (char & i : this->lastAckPkt.payload) {
//        i = '.';
//    }
//    this->lastAckPkt.checksum = pUtils->calculateCheckSum(lastAckPkt);
//}
//
//void TCPRdtReceiver::receive(const Packet &packet) {
//    //���У��ͺ����
//    int checkSum = pUtils->calculateCheckSum(packet);
//    if (checkSum == packet.checksum && packet.seqnum == this->expectSequenceNumberRcvd){
//        //����ͺ������ȷ
//        //��ȡmessage�����䵽Ӧ�ò�
//        Message m;
//        memcpy(m.data, packet.payload, sizeof(packet.payload));
//        pUtils->printPacket("receive packet", packet);
//        pns->delivertoAppLayer(RECEIVER, m);
//
//        //������������Ӧ����
//        this->lastAckPkt.seqnum = -1; //��Ӧ���ĺ���seqnum
//        this->lastAckPkt.acknum = packet.seqnum;
//        this->lastAckPkt.checksum = pUtils->calculateCheckSum(lastAckPkt);
//        pUtils->printPacket("send ack", lastAckPkt);
//        pns->sendToNetworkLayer(SENDER, lastAckPkt);
//
//        //���±���
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
