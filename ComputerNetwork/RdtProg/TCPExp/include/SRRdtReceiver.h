//
// Created by Ray on 2021/10/17.
//

#ifndef TCPEXP_SRRDTRECEIVER_H
#define TCPEXP_SRRDTRECEIVER_H
#include "RdtReceiver.h"
#include "Global.h"


class SRRdtReceiver : public RdtReceiver {
private:
    struct receiveWin{
        Packet packet;
        bool hasPacket;
    }receiveWin[WINDOW_SIZE]; //����hasPacket,���㷢��������
    int base;

public:
    SRRdtReceiver();
    virtual ~SRRdtReceiver();

public:

    void receive(const Packet &packet) ;	//���ձ��ģ�����NetworkService����

};


#endif //TCPEXP_SRRDTRECEIVER_H
