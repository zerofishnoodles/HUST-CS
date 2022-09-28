//
// Created by Ray on 2021/10/17.
//

#include "SRRdtSender.h"
#include <cassert>

SRRdtSender::SRRdtSender() {
    //init
    this->base = 0;
    this->waitingState = false;
    this->expectSequenceNumberSend = 0;
    for (auto & item : this->sendWin){
        item.packet.seqnum = -1;
        item.packet.checksum = -1;
        item.packet.acknum = -1;
        memset(item.packet.payload, 0, sizeof(item.packet.payload));
        item.hasAck = false;
    }
}

bool SRRdtSender::getWaitingState() {
    return this->waitingState;
}

SRRdtSender::~SRRdtSender() noexcept = default;

bool SRRdtSender::send(const Message &message) {
    if (this->waitingState){
        return false;
    }
    //判断窗口是否满了
    //packetnum可能出现负数：expectnum跨过7重新到0，而base仍在上一次的空间中
    int packet_num = this->expectSequenceNumberSend - this->base;
    if (packet_num<0){
        packet_num = packet_num + SEQ_SIZE;
    }
    if (packet_num >= WINDOW_SIZE){
        this->waitingState = true;
        return false;
    }
    //构建packet
    Packet p;
    p.acknum = -1;
    p.seqnum = this->expectSequenceNumberSend;
    memcpy(p.payload, message.data, sizeof(message.data));
    p.checksum = pUtils->calculateCheckSum(p);
    pUtils->printPacket("send packet", p);

    //将packet加进发送窗口中
    this->sendWin[packet_num].packet = p;
    this->sendWin[packet_num].hasAck = false;

    //发送并启动计时器
    pns->startTimer(SENDER, Configuration::TIME_OUT, p.seqnum);
    pns->sendToNetworkLayer(RECEIVER, p);
    this->expectSequenceNumberSend = (this->expectSequenceNumberSend + 1) % SEQ_SIZE;

    //更新packetnum
    packet_num = this->expectSequenceNumberSend - this->base;
    if (packet_num<0){
        packet_num = packet_num + SEQ_SIZE;
    }
    if (packet_num >= WINDOW_SIZE){
        this->waitingState = true;
    }

    return true;
}

void SRRdtSender::receive(const Packet &ackPkt) {
    //判断响应报文，根据响应报文更新相关变量

    //计算checksum
    int checksum = pUtils->calculateCheckSum(ackPkt);

    //两种情况
    //1.收到了ackNum == base的报文,此时需要移动到第一个没收到ack的报文
    //2.收到了ackNum != base的报文,此时不需要移动,但需要更改状态
    if (ackPkt.checksum == checksum){
        // 终止计时器
        pns->stopTimer(SENDER, ackPkt.acknum);
        //更新状态
        int packet_index = ackPkt.acknum-base;
        if (packet_index<0){
            packet_index = packet_index+SEQ_SIZE;
        }
        assert(packet_index>=0);
        this->sendWin[packet_index].hasAck = true;

        if (ackPkt.acknum == base){
            //收到和ackNum==base的响应报文，滑动至最新的窗口
            pUtils->printPacket("receive base ack", ackPkt);

            //滑动窗口
            int move_len=0;
            while (move_len<WINDOW_SIZE && this->sendWin[0].hasAck){
                base = (base+1)%SEQ_SIZE;
                for(int j=1;j<WINDOW_SIZE;++j){
                    this->sendWin[j-1] = this->sendWin[j];
                    this->sendWin[j].hasAck = false;
                }
                move_len++;
            }

            assert(move_len>0);  //debug

            //更新waitingstate
            int packet_num = this->expectSequenceNumberSend - this->base;
            if (packet_num<0){
                packet_num = packet_num + SEQ_SIZE;
            }
            if (packet_num < WINDOW_SIZE){
                this->waitingState = false;
            }

            printf("window:\n");
            for (int i = 0; i < packet_num; i++) {
                pUtils->printPacket("packet in window", this->sendWin[i].packet);
            }
        }else{
            pUtils->printPacket("receive ack that should buffer", ackPkt);
        }
    }else{
        pUtils->printPacket("receive wrong ack", ackPkt);
    }
}

void SRRdtSender::timeoutHandler(int seqNum) {
    //只重发seqNum对应的报文
    assert(seqNum < SEQ_SIZE);
    int packet_index = seqNum - base;
    if (packet_index<0){
        packet_index = packet_index+SEQ_SIZE;
    }
    pUtils->printPacket("Time out, resend packet", this->sendWin[packet_index].packet);
    pns->sendToNetworkLayer(RECEIVER, this->sendWin[packet_index].packet);

    //重启计时器
    pns->stopTimer(SENDER, seqNum);
    pns->startTimer(SENDER, Configuration::TIME_OUT, seqNum);
}
