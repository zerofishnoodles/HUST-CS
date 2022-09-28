//
// Created by Ray on 2021/10/23.
//

#ifndef TCPEXP_TCPRDTSENDER_H
#define TCPEXP_TCPRDTSENDER_H
#include "RdtSender.h"
#include "Global.h"



class TCPRdtSender: public RdtSender{
private:
    int expectSequenceNumberSend;	// ��һ��������� ��Ҫѭ��
    bool waitingState;				// �Ƿ��ڵȴ�Ack��״̬
    Packet win[WINDOW_SIZE];     // �ѷ��Ͳ��ȴ�Ack�����ݰ�����
    int base;
    int accumulate_num;

public:

    bool getWaitingState() override;
    bool send(const Message &message) override;						//����Ӧ�ò�������Message����NetworkServiceSimulator����,������ͷ��ɹ��ؽ�Message���͵�����㣬����true;�����Ϊ���ͷ����ڵȴ���ȷȷ��״̬���ܾ�����Message���򷵻�false
    void receive(const Packet &ackPkt) override;						//����ȷ��Ack������NetworkServiceSimulator����
    void timeoutHandler(int seqNum) override;					//Timeout handler������NetworkServiceSimulator����

public:
    TCPRdtSender();
    virtual ~TCPRdtSender();

};


#endif //TCPEXP_TCPRDTSENDER_H
