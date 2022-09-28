//
// Created by Ray on 2021/10/14.
//

#include "GBNRdtSender.h"
#include "Tool.h"
#include "Global.h"

bool GBNRdtSender::getWaitingState() {
    return this->waitingState;
}

void GBNRdtSender::receive(const Packet &ackPkt) {
    //判断响应报文，根据响应报文更新相关变量

    //计算checksum
    int checksum = pUtils->calculateCheckSum(ackPkt);

    if (ackPkt.checksum == checksum && (ackPkt.acknum>=base || ackPkt.acknum<base-WINDOW_SIZE)){ //这里是个很奇怪的地方，如何判断收到的不是上一轮的某个数？
        //收到最新的响应报文，滑动至最新的窗口
        pUtils->printPacket("receive correct ack", ackPkt);

        //终止计时器
        pns->stopTimer(SENDER, base);

        printf("window:\n");
        for (int i = 0; i < this->expectSequenceNumberSend-this->base; i++) {
            pUtils->printPacket("packet in window", this->win[i]);
        }

        //窗口移动
        int move_len = (ackPkt.acknum-base) <0 ? ackPkt.acknum-base+SEQ_SIZE : ackPkt.acknum-base;
        move_len = move_len+1;
        base = (ackPkt.acknum+1) % SEQ_SIZE;   //base空间大小和报文序号空间大小一致


        for(int k=0;k<move_len;k++){
            for (int i = 1; i < WINDOW_SIZE; ++i) {
                this->win[i-1] = this->win[i];
            }
        }
        //更新waitingstate
        int packet_num = this->expectSequenceNumberSend - this->base;
        if (packet_num<0){
            packet_num = packet_num + SEQ_SIZE;
        }
        if (packet_num < WINDOW_SIZE){
            this->waitingState = false;
        }


        //如果仍有在传输的packet，则启动定时器
        if (packet_num>0){
            pns->startTimer(SENDER, Configuration::TIME_OUT, this->base);
        }

    }else{
        pUtils->printPacket("receive wrong ack", ackPkt);
    }
}

bool GBNRdtSender::send(const Message &message) {
    if (this->waitingState){
        return false;
    }
    //判断窗口是否满了
    //packetnum可能出现复数：expectnum跨过7重新到0，而base仍在上一次的空间中
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

GBNRdtSender::GBNRdtSender(){
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
}

GBNRdtSender::~GBNRdtSender() = default;

void GBNRdtSender::timeoutHandler(int seqNum) {
    int packet_num = this->expectSequenceNumberSend - this->base;
    if (packet_num<0){
        packet_num = packet_num + SEQ_SIZE;
    }
    this->expectSequenceNumberSend = this->base;
    for (int i = 0; i < packet_num; ++i) {
        pUtils->printPacket("Time out, resend all the packet in the window", this->win[i]);
        if (i == 0){//只针对最早的
            pns->stopTimer(SENDER,this->win[0].seqnum);										//首先关闭定时器
            pns->startTimer(SENDER, Configuration::TIME_OUT,this->win[0].seqnum);			//重新启动发送方定时器
        }
        pns->sendToNetworkLayer(RECEIVER, this->win[i]);
        this->expectSequenceNumberSend = (this->expectSequenceNumberSend + 1) % SEQ_SIZE;
    }
}
