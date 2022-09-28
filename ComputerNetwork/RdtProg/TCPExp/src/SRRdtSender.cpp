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
    this->sendWin[packet_num].packet = p;
    this->sendWin[packet_num].hasAck = false;

    //���Ͳ�������ʱ��
    pns->startTimer(SENDER, Configuration::TIME_OUT, p.seqnum);
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

void SRRdtSender::receive(const Packet &ackPkt) {
    //�ж���Ӧ���ģ�������Ӧ���ĸ�����ر���

    //����checksum
    int checksum = pUtils->calculateCheckSum(ackPkt);

    //�������
    //1.�յ���ackNum == base�ı���,��ʱ��Ҫ�ƶ�����һ��û�յ�ack�ı���
    //2.�յ���ackNum != base�ı���,��ʱ����Ҫ�ƶ�,����Ҫ����״̬
    if (ackPkt.checksum == checksum){
        // ��ֹ��ʱ��
        pns->stopTimer(SENDER, ackPkt.acknum);
        //����״̬
        int packet_index = ackPkt.acknum-base;
        if (packet_index<0){
            packet_index = packet_index+SEQ_SIZE;
        }
        assert(packet_index>=0);
        this->sendWin[packet_index].hasAck = true;

        if (ackPkt.acknum == base){
            //�յ���ackNum==base����Ӧ���ģ����������µĴ���
            pUtils->printPacket("receive base ack", ackPkt);

            //��������
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

            //����waitingstate
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
    //ֻ�ط�seqNum��Ӧ�ı���
    assert(seqNum < SEQ_SIZE);
    int packet_index = seqNum - base;
    if (packet_index<0){
        packet_index = packet_index+SEQ_SIZE;
    }
    pUtils->printPacket("Time out, resend packet", this->sendWin[packet_index].packet);
    pns->sendToNetworkLayer(RECEIVER, this->sendWin[packet_index].packet);

    //������ʱ��
    pns->stopTimer(SENDER, seqNum);
    pns->startTimer(SENDER, Configuration::TIME_OUT, seqNum);
}
