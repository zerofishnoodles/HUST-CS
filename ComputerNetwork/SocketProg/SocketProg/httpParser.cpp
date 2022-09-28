#pragma once
#include<iostream>
#include<fstream>
#include<string>
#include<map>
#include"httpParser.h"
#include"global.h"
using namespace std;
#define MAXBUF 2048
#define	MESS_404 "<html><body><h1>404 FILE NOT FOUND</h1></body></html>"
#define HEAD_404 "HTTP/1.1 404 Not Found\r\nContent-Type:text/html\r\n"
#define HEAD_200 "HTTP/1.1 200 OK\r\n"
#define HEAD_400 "HTTP/1.1 400 Bad Request\r\nContent-Type:text/html\r\n\r\n"
#define MESS_400 "<html><body><h1>400 Bad Request</h1></body></html>"

void httpParser::initContentTypes() {
	httpTypes["html"] = "text/html";
	httpTypes["jpg"] = "image/jpeg";
	httpTypes["ico"] = "image/x-icon";
	httpTypes["mp3"] = "audio/mpeg";
	httpTypes["mp4"] = "video/mp4";
}


httpParser::httpParser(string buf) : request(buf)
{
	initContentTypes();
	int pos1 = buf.find(" ", 0);
	if (pos1 != string::npos) {
		requestType = buf.substr(0, pos1);
	}
	int pos2 = buf.find(" ", pos1 + 1);
	if (pos2 != string::npos) {
		fileName = buf.substr(pos1 + 1, pos2-(pos1+1));
		fileName.insert(0, ".");
		if (fileName == "./")
		{
			fileName = Home;
		}
	}
	int pos3 = fileName.rfind(".");
	if (pos3 != string::npos && pos3!=0) {
		contentType = fileName.substr(pos3 + 1);
	}
	else {
		contentType = "html";
		fileName = fileName + ".html";
	}

};

string httpParser::httpResponse(void) {
	if (requestType == "GET") {
		return getResponse();
	}
	else {
		string output;
		output = HEAD_400;
		output.append(MESS_400);
		response = output;
		return output;
	}
}

string httpParser::getResponse(void) {
	FILE* fp;
	fpos_t length = 0;
	string output;
	char* data = NULL;
	fp = fopen(fileName.c_str(), "r+b");
	if (fp != NULL) {
		fseek(fp, 0, SEEK_END);
		fgetpos(fp, &length);
		fseek(fp, 0, SEEK_SET);

		data = new char[length + 1];
		length = fread(data, 1, length, fp);
		fclose(fp);
	}
	else { //404 not found
		output = HEAD_404;
		output.append("Content-Length: ");
		output.append(to_string(string(MESS_404).length()));
		output.append("\r\n\r\n");
		output.append(MESS_404);
		response = output;
		return output;
	}
	//header

	//content type
	output = HEAD_200;
	output.append("Content-Type: ");
	output.append(httpTypes[contentType]);
	output.append("\r\n");

	//content length
	string dataLength = to_string(length);
	output.append("Content-Length: ");
	output.append(dataLength);
	output.append("\r\n\r\n");

	//data
	output.append(data, length);

	response = output;
	delete data;
	data = NULL;
	return output;
}

void httpParser::printInfo(void) {
	//cout << "request:" << endl <<  request << endl;
	cout << "requestType:" << requestType << endl;
	//cout << "response:" << endl << response << endl;
	cout << "fileName:" << fileName << endl;
}