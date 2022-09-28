#pragma once
#include<iostream>
#include<fstream>
#include<string>
using namespace std;
#define MAXBUF 516
typedef map<string, string> HTTPTYPES;


class httpParser {
private:
	string request;
	string response;
	string fileName;
	string requestType;
	string contentType;
	HTTPTYPES httpTypes;

public:
	httpParser() = default;
	~httpParser() = default;
	httpParser(string buf);
	string httpResponse(void);
	string getResponse(void);
	void printInfo(void);
	void initContentTypes();
};