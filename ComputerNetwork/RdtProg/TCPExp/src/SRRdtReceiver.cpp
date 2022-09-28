//
// Created by Ray on 2021/10/17.
//

#include "SRRdtReceiver.h"
#include <cassert>

SRRdtReceiver::SRRdtReceiver() {
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
}

void SRRdtReceiver::receive(const Packet &packet) {
    //����checksum
    int checkSum = pUtils->calculateCheckSum(packet);

    //�������
    //1. ����receiveWin�ڵİ�ҲҪ��ack
    //2. ��receiveWin��,����seq!=base,��ʱ��Ҫ������buffer
    //3. ��receiveWin��,��seq==base,��ʱ��Ҫ��˳��ݽ�����������buffer��packet,���ƶ�����
    if (checkSum == packet.checksum){
        int packet_index = packet.seqnum - this->base;
        //����,���ڴ��ڿռ�����ſռ��һ��,���Կ����жϵ���ž���С��-windowsizeʱ,�ǵ�ǰ�ֵı���,������֮ǰ�յ����ı���
        if (packet_index < -WINDOW_SIZE){
            packet_index = (packet_index+SEQ_SIZE)%SEQ_SIZE;
        }
        if (packet_index<0 || packet_index>=WINDOW_SIZE){
            //�յ�֮ǰ�ı���
            pUtils->printPacket("receive prior packet", packet);
        } else if (packet_index != 0){
            //������buffer
            this->receiveWin[packet_index].packet = packet;
            this->receiveWin[packet_index].hasPacket = true;
            pUtils->printPacket("receive packet that should buffer", packet);

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
                }
            }
            assert(this->receiveWin[0].hasPacket == false);  //debug
        }

        //������Ӧ����
        Packet ack;
        ack.seqnum = -1;
        ack.acknum = packet.seqnum;
        for (auto & i: ack.payload){
            i = '.';
        }
        ack.checksum = pUtils->calculateCheckSum(ack);
        //������Ӧ����
        pUtils->printPacket("send ack", ack);
        pns->sendToNetworkLayer(SENDER, ack);
    } else{
        pUtils->printPacket("the packet is corrupt!", packet);
    }
}

SRRdtReceiver::~SRRdtReceiver() = default;