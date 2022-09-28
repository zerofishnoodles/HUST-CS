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
    }receiveWin[WINDOW_SIZE]; //增加hasPacket,方便发连续报文
    int base;
    Packet lastack;

public:
    TCPRdtReceiver();
    virtual ~TCPRdtReceiver();

public:

    void receive(const Packet &packet) ;	//接收报文，将被NetworkService调用


};

//class TCPRdtReceiver : public RdtReceiver{
//private:
//    int expectSequenceNumberRcvd;	// 期待收到的下一个报文序号
//    Packet lastAckPkt;				//上次发送的确认报文
//
//public:
//    TCPRdtReceiver();
//    virtual ~TCPRdtReceiver();
//
//public:
//
//    void receive(const Packet &packet) override;	//接收报文，将被NetworkService调用
//};

#endif //TCPEXP_TCPRDTRECEIVER_H
