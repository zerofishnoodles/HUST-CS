//
// Created by Ray on 2021/10/23.
//

#include "TCPRdtSender.h"
#include "Tool.h"
#include "Global.h"
#include <cassert>

bool TCPRdtSender::getWaitingState() {
    return this->waitingState;
}

void TCPRdtSender::receive(const Packet &ackPkt) {
    //判断响应报文，根据响应报文更新相关变量

    //计算checksum
    printf("base:%d, acknum:%d, ackchecksum:%d\n", base, ackPkt.acknum, ackPkt.checksum);
    int checksum = pUtils->calculateCheckSum(ackPkt);


    if (ackPkt.checksum == checksum && ((ackPkt.acknum-base>=0 && ackPkt.acknum-base<WINDOW_SIZE)|| ackPkt.acknum<base-WINDOW_SIZE)) { //这里是个很奇怪的地方，如何判断收到的不是上一轮的某个数？
        //收到最新的响应报文，滑动至最新的窗口
        pUtils->printPacket("receive correct ack", ackPkt);

        //终止计时器
        pns->stopTimer(SENDER, base);

        //窗口移动
        int move_len = (ackPkt.acknum - base) < 0 ? ackPkt.acknum - base + SEQ_SIZE : ackPkt.acknum - base;
        move_len = move_len + 1;
        base = (ackPkt.acknum + 1) % SEQ_SIZE;   //base空间大小和报文序号空间大小一致
        for (int k = 0; k < move_len; k++) {
            for (int i = 1; i < WINDOW_SIZE; ++i) {
                this->win[i - 1] = this->win[i];
            }
        }
        //更新waitingstate
        int packet_num = this->expectSequenceNumberSend - this->base;
        if (packet_num < 0) {
            packet_num = packet_num + SEQ_SIZE;
        }
        if (packet_num < WINDOW_SIZE) {
            this->waitingState = false;
        }

        //打印窗口信息
        printf("window:\n");
        for (int i = 0; i < packet_num; i++) {
            pUtils->printPacket("packet in window", this->win[i]);
        }

        //如果仍有在传输的packet，则启动定时器
        if (packet_num > 0) {
            pns->startTimer(SENDER, Configuration::TIME_OUT, this->base);
        }

    }else if(ackPkt.checksum == checksum &&  base-WINDOW_SIZE<ackPkt.acknum && ackPkt.acknum<base){
        pUtils->printPacket("receive prior ack, accumulating...", ackPkt);
        accumulate_num++;
        if (accumulate_num == 3){
            //变量更新
            accumulate_num = 0;
            pUtils->printPacket("accumulate to 3, ready to resend", ackPkt);
            pUtils->printPacket("resend packet", this->win[0]);
            pns->sendToNetworkLayer(RECEIVER, this->win[0]);
        }
    }
    else {
        pUtils->printPacket("receive wrong ack", ackPkt);
    }

}

bool TCPRdtSender::send(const Message &message) {
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
    this->win[packet_num] = p;

    //发送并启动计时器
    //只针对最早未收到ack的计时
    if (p.seqnum  == this->base){
        pns->startTimer(SENDER, Configuration::TIME_OUT, p.seqnum);
    }
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

TCPRdtSender::TCPRdtSender(){
    //init
    this->expectSequenceNumberSend = 0;
    this->base = 0;
    this->waitingState = false;
    for (auto & i : this->win){
        i.seqnum = -1;
        i.checksum = -1;
        i.acknum = -1;
        memset(i.payload, 0, sizeof(i.payload));
    }
    this->accumulate_num = 0;
}

TCPRdtSender::~TCPRdtSender() = default;

void TCPRdtSender::timeoutHandler(int seqNum) {
    //只重发最早未收到的报文
    assert(seqNum==this->base);  //debug
    accumulate_num = 0; //也要更新accumulate——num
    pUtils->printPacket("time out, resend packet", this->win[0]);
    pns->stopTimer(SENDER, this->win[0].seqnum);
    pns->startTimer(SENDER, Configuration::TIME_OUT, seqNum);
    pns->sendToNetworkLayer(RECEIVER, this->win[0]);
}