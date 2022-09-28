//
// Created by Ray on 2021/10/23.
//

#ifndef TCPEXP_TCPRDTRECEIVER_H
#define TCPEXP_TCPRDTRECEIVER_H
#include "RdtReceiver.h"
#include "Global.h"



class TCPRdtReceiver : public RdtReceiver{
private:
    struct receiveWin{
        Packet packet;
        bool hasPacket;
    }receiveWin[WINDOW_SIZE]; //����hasPacket,���㷢��������
    int base;
    Packet lastack;

public:
    TCPRdtReceiver();
    virtual ~TCPRdtReceiver();

public:

    void receive(const Packet &packet) ;	//���ձ��ģ�����NetworkService����


};

//class TCPRdtReceiver : public RdtReceiver{
//private:
//    int expectSequenceNumberRcvd;	// �ڴ��յ�����һ���������
//    Packet lastAckPkt;				//�ϴη��͵�ȷ�ϱ���
//
//public:
//    TCPRdtReceiver();
//    virtual ~TCPRdtReceiver();
//
//public:
//
//    void receive(const Packet &packet) override;	//���ձ��ģ�����NetworkService����
//};

#endif //TCPEXP_TCPRDTRECEIVER_H
