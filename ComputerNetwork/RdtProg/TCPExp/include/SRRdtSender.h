//
// Created by Ray on 2021/10/17.
//

#ifndef TCPEXP_SRRDTSENDER_H
#define TCPEXP_SRRDTSENDER_H
#include "RdtSender.h"
#include "Global.h"


class SRRdtSender : public RdtSender{
private:
    int expectSequenceNumberSend;	// ��һ��������� ��Ҫѭ��
    bool waitingState;				// �Ƿ��ڵȴ�Ack��״̬
    struct sendWin{
        Packet packet;
        bool hasAck; //��ʶ�Ƿ�����Ӧ
    }sendWin[WINDOW_SIZE];  // �ѷ��Ͳ��ȴ�Ack�����ݰ�����
    int base;

public:

    bool getWaitingState() override;
    bool send(const Message &message) override;						//����Ӧ�ò�������Message����NetworkServiceSimulator����,������ͷ��ɹ��ؽ�Message���͵�����㣬����true;�����Ϊ���ͷ����ڵȴ���ȷȷ��״̬���ܾ�����Message���򷵻�false
    void receive(const Packet &ackPkt) override;						//����ȷ��Ack������NetworkServiceSimulator����
    void timeoutHandler(int seqNum) override;					//Timeout handler������NetworkServiceSimulator����

public:
    SRRdtSender();
    virtual ~SRRdtSender();
};


#endif //TCPEXP_SRRDTSENDER_H
