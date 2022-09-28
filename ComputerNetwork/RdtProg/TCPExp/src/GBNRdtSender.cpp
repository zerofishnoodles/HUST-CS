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
    //�ж���Ӧ���ģ�������Ӧ���ĸ�����ر���

    //����checksum
    int checksum = pUtils->calculateCheckSum(ackPkt);

    if (ackPkt.checksum == checksum && (ackPkt.acknum>=base || ackPkt.acknum<base-WINDOW_SIZE)){ //�����Ǹ�����ֵĵط�������ж��յ��Ĳ�����һ�ֵ�ĳ������
        //�յ����µ���Ӧ���ģ����������µĴ���
        pUtils->printPacket("receive correct ack", ackPkt);

        //��ֹ��ʱ��
        pns->stopTimer(SENDER, base);

        printf("window:\n");
        for (int i = 0; i < this->expectSequenceNumberSend-this->base; i++) {
            pUtils->printPacket("packet in window", this->win[i]);
        }

        //�����ƶ�
        int move_len = (ackPkt.acknum-base) <0 ? ackPkt.acknum-base+SEQ_SIZE : ackPkt.acknum-base;
        move_len = move_len+1;
        base = (ackPkt.acknum+1) % SEQ_SIZE;   //base�ռ��С�ͱ�����ſռ��Сһ��


        for(int k=0;k<move_len;k++){
            for (int i = 1; i < WINDOW_SIZE; ++i) {
                this->win[i-1] = this->win[i];
            }
        }
        //����waitingstate
        int packet_num = this->expectSequenceNumberSend - this->base;
        if (packet_num<0){
            packet_num = packet_num + SEQ_SIZE;
        }
        if (packet_num < WINDOW_SIZE){
            this->waitingState = false;
        }


        //��������ڴ����packet����������ʱ��
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
    //�жϴ����Ƿ�����
    //packetnum���ܳ��ָ�����expectnum���7���µ�0����base������һ�εĿռ���
    int packet_num = this->expectSequenceNumberSend - this->base;
    if (packet_num<0){
        packet_num = packet_num + SEQ_SIZE;
    }
    if (packet_num >= WINDOW_SIZE){
        this->waitingState = true;
        return false;
    }
    //����packet
    Packet p;
    p.acknum = -1;
    p.seqnum = this->expectSequenceNumberSend;
    memcpy(p.payload, message.data, sizeof(message.data));
    p.checksum = pUtils->calculateCheckSum(p);
    pUtils->printPacket("send packet", p);

    //��packet�ӽ����ʹ�����
    this->win[packet_num] = p;

    //���Ͳ�������ʱ��
    //ֻ�������δ�յ�ack�ļ�ʱ
    if (p.seqnum  == this->base){
        pns->startTimer(SENDER, Configuration::TIME_OUT, p.seqnum);
    }
    pns->sendToNetworkLayer(RECEIVER, p);
    this->expectSequenceNumberSend = (this->expectSequenceNumberSend + 1) % SEQ_SIZE;

    //����packetnum
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
        if (i == 0){//ֻ��������
            pns->stopTimer(SENDER,this->win[0].seqnum);										//���ȹرն�ʱ��
            pns->startTimer(SENDER, Configuration::TIME_OUT,this->win[0].seqnum);			//�����������ͷ���ʱ��
        }
        pns->sendToNetworkLayer(RECEIVER, this->win[i]);
        this->expectSequenceNumberSend = (this->expectSequenceNumberSend + 1) % SEQ_SIZE;
    }
}
