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
    //�ж���Ӧ���ģ�������Ӧ���ĸ�����ر���

    //����checksum
    printf("base:%d, acknum:%d, ackchecksum:%d\n", base, ackPkt.acknum, ackPkt.checksum);
    int checksum = pUtils->calculateCheckSum(ackPkt);


    if (ackPkt.checksum == checksum && ((ackPkt.acknum-base>=0 && ackPkt.acknum-base<WINDOW_SIZE)|| ackPkt.acknum<base-WINDOW_SIZE)) { //�����Ǹ�����ֵĵط�������ж��յ��Ĳ�����һ�ֵ�ĳ������
        //�յ����µ���Ӧ���ģ����������µĴ���
        pUtils->printPacket("receive correct ack", ackPkt);

        //��ֹ��ʱ��
        pns->stopTimer(SENDER, base);

        //�����ƶ�
        int move_len = (ackPkt.acknum - base) < 0 ? ackPkt.acknum - base + SEQ_SIZE : ackPkt.acknum - base;
        move_len = move_len + 1;
        base = (ackPkt.acknum + 1) % SEQ_SIZE;   //base�ռ��С�ͱ�����ſռ��Сһ��
        for (int k = 0; k < move_len; k++) {
            for (int i = 1; i < WINDOW_SIZE; ++i) {
                this->win[i - 1] = this->win[i];
            }
        }
        //����waitingstate
        int packet_num = this->expectSequenceNumberSend - this->base;
        if (packet_num < 0) {
            packet_num = packet_num + SEQ_SIZE;
        }
        if (packet_num < WINDOW_SIZE) {
            this->waitingState = false;
        }

        //��ӡ������Ϣ
        printf("window:\n");
        for (int i = 0; i < packet_num; i++) {
            pUtils->printPacket("packet in window", this->win[i]);
        }

        //��������ڴ����packet����������ʱ��
        if (packet_num > 0) {
            pns->startTimer(SENDER, Configuration::TIME_OUT, this->base);
        }

    }else if(ackPkt.checksum == checksum &&  base-WINDOW_SIZE<ackPkt.acknum && ackPkt.acknum<base){
        pUtils->printPacket("receive prior ack, accumulating...", ackPkt);
        accumulate_num++;
        if (accumulate_num == 3){
            //��������
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
    //ֻ�ط�����δ�յ��ı���
    assert(seqNum==this->base);  //debug
    accumulate_num = 0; //ҲҪ����accumulate����num
    pUtils->printPacket("time out, resend packet", this->win[0]);
    pns->stopTimer(SENDER, this->win[0].seqnum);
    pns->startTimer(SENDER, Configuration::TIME_OUT, seqNum);
    pns->sendToNetworkLayer(RECEIVER, this->win[0]);
}