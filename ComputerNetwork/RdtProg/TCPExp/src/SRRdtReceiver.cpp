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
    //计算checksum
    int checkSum = pUtils->calculateCheckSum(packet);

    //三种情况
    //1. 不在receiveWin内的包也要发ack
    //2. 在receiveWin中,但是seq!=base,此时需要将报文buffer
    //3. 在receiveWin中,且seq==base,此时需要按顺序递交所有连续的buffer的packet,并移动窗口
    if (checkSum == packet.checksum){
        int packet_index = packet.seqnum - this->base;
        //特判,由于窗口空间是序号空间的一半,所以可以判断当序号距离小于-windowsize时,是当前轮的报文,而不是之前收到过的报文
        if (packet_index < -WINDOW_SIZE){
            packet_index = (packet_index+SEQ_SIZE)%SEQ_SIZE;
        }
        if (packet_index<0 || packet_index>=WINDOW_SIZE){
            //收到之前的报文
            pUtils->printPacket("receive prior packet", packet);
        } else if (packet_index != 0){
            //将报文buffer
            this->receiveWin[packet_index].packet = packet;
            this->receiveWin[packet_index].hasPacket = true;
            pUtils->printPacket("receive packet that should buffer", packet);

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
                }
            }
            assert(this->receiveWin[0].hasPacket == false);  //debug
        }

        //构建响应报文
        Packet ack;
        ack.seqnum = -1;
        ack.acknum = packet.seqnum;
        for (auto & i: ack.payload){
            i = '.';
        }
        ack.checksum = pUtils->calculateCheckSum(ack);
        //发送响应报文
        pUtils->printPacket("send ack", ack);
        pns->sendToNetworkLayer(SENDER, ack);
    } else{
        pUtils->printPacket("the packet is corrupt!", packet);
    }
}

SRRdtReceiver::~SRRdtReceiver() = default;