DROP TABLE IF EXISTS residents;

-- ----------------------------
-- Table structure for routine
-- ----------------------------
DROP TABLE IF EXISTS routine;
CREATE TABLE routine  (
  trainno char(11) primary key,
  start char(10),
  dest char(10),
  depart time,
  arrival time,
  days int,
  distance int
) ;


INSERT INTO routine VALUES ('D4816/D4813', '汉口', '上海虹桥', '03:48:00', '08:22:00', 1, 827);
INSERT INTO routine VALUES ('D4817/D4820', '汉口', '上海虹桥', '03:10:00', '08:43:00', 1, 827);
INSERT INTO routine VALUES ('D4820/D4817', '汉口', '上海虹桥', '03:10:00', '08:43:00', 1, 827);
INSERT INTO routine VALUES ('D4832/D4829', '武昌', '苏州北', '21:50:00', '02:02:00', 2, 750);
INSERT INTO routine VALUES ('D4840/D4841', '上海虹桥', '汉口', '03:06:00', '07:06:00', 1, 827);
INSERT INTO routine VALUES ('D4842/D4839', '汉口', '上海虹桥', '22:39:00', '02:37:00', 2, 827);
INSERT INTO routine VALUES ('D4984/D4985', '上海虹桥', '汉口', '03:13:00', '07:52:00', 1, 811);
INSERT INTO routine VALUES ('D4986/D4983', '汉口', '上海虹桥', '20:50:00', '02:42:00', 2, 827);
INSERT INTO routine VALUES ('D5201/D5204', '孝感东', '咸宁南', '08:53:00', '10:55:00', 1, 172);
INSERT INTO routine VALUES ('D5202/D5203', '咸宁南', '孝感东', '06:45:00', '08:38:00', 1, 172);
INSERT INTO routine VALUES ('D5206/D5207', '咸宁南', '孝感东', '11:15:00', '13:11:00', 1, 172);
INSERT INTO routine VALUES ('D5208/D5205', '孝感东', '咸宁南', '15:30:00', '18:00:00', 1, 172);
INSERT INTO routine VALUES ('D5211/D5214', '咸宁南', '孝感东', '18:18:00', '20:44:00', 1, 172);
INSERT INTO routine VALUES ('D5212/D5213', '阳新', '襄阳', '08:37:00', '12:40:00', 1, 497);
INSERT INTO routine VALUES ('D5221/D5224', '孝感东', '咸宁南', '07:00:00', '09:22:00', 1, 172);
INSERT INTO routine VALUES ('D5222/D5223', '咸宁南', '孝感东', '09:37:00', '12:01:00', 1, 172);
INSERT INTO routine VALUES ('D5225/D5228', '孝感东', '咸宁南', '14:08:00', '16:16:00', 1, 172);
INSERT INTO routine VALUES ('D5226/D5227', '咸宁南', '孝感东', '19:28:00', '21:40:00', 1, 172);
INSERT INTO routine VALUES ('D5233', '汉口', '襄阳', '15:40:00', '18:10:00', 1, 315);
INSERT INTO routine VALUES ('D5235', '汉口', '襄阳', '07:00:00', '09:20:00', 1, 315);
INSERT INTO routine VALUES ('D5241', '汉口', '十堰', '08:00:00', '11:50:00', 1, 480);
INSERT INTO routine VALUES ('D5243', '汉口', '十堰', '14:41:00', '18:19:00', 1, 480);
INSERT INTO routine VALUES ('D5251', '汉口', '襄阳', '07:50:00', '10:10:00', 1, 315);
INSERT INTO routine VALUES ('D5253', '汉口', '襄阳', '11:20:00', '13:45:00', 1, 315);
INSERT INTO routine VALUES ('D5271/D5274', '汉口', '随州', '10:00:00', '11:48:00', 1, 166);
INSERT INTO routine VALUES ('D5272/D5273', '武昌', '襄阳', '09:10:00', '11:45:00', 1, 328);
INSERT INTO routine VALUES ('D5276/D5277', '武昌', '襄阳', '17:00:00', '19:32:00', 1, 328);
INSERT INTO routine VALUES ('D5282/D5283', '武昌', '十堰', '12:36:00', '17:05:00', 1, 493);
INSERT INTO routine VALUES ('D5291/D5294', '汉口', '襄阳', '07:18:00', '09:38:00', 1, 315);
INSERT INTO routine VALUES ('D5601', '南京南', '安庆', '09:07:00', '11:07:00', 1, 257);
INSERT INTO routine VALUES ('D5603', '南京南', '安庆', '12:00:00', '14:06:00', 1, 257);
INSERT INTO routine VALUES ('D5605', '南京南', '安庆', '13:44:00', '15:50:00', 1, 257);
INSERT INTO routine VALUES ('D5609', '南京南', '安庆', '18:32:00', '20:26:00', 1, 257);
INSERT INTO routine VALUES ('D5752/D5753', '武昌', '宜昌东', '07:25:00', '09:33:00', 1, 312);
INSERT INTO routine VALUES ('D5756/D5757', '武昌', '利川', '10:20:00', '15:04:00', 1, 587);
INSERT INTO routine VALUES ('D5760/D5761', '武昌', '宜昌东', '12:20:00', '14:30:00', 1, 312);
INSERT INTO routine VALUES ('D5763/D5766', '武昌', '宜昌东', '07:25:00', '09:35:00', 1, 312);
INSERT INTO routine VALUES ('D5764/D5765', '武昌', '宜昌东', '16:17:00', '18:28:00', 1, 312);
INSERT INTO routine VALUES ('D5765/D5764', '武昌', '宜昌东', '16:17:00', '18:28:00', 1, 312);
INSERT INTO routine VALUES ('D5767/D5770', '武昌', '宜昌东', '12:20:00', '14:31:00', 1, 312);
INSERT INTO routine VALUES ('D5768/D5769', '武昌', '宜昌东', '17:53:00', '20:11:00', 1, 312);
INSERT INTO routine VALUES ('D5801/D5804', '汉口', '宜昌东', '08:26:00', '10:40:00', 1, 292);
INSERT INTO routine VALUES ('D5802/D5803', '武汉', '宜昌东', '05:33:00', '07:53:00', 1, 323);
INSERT INTO routine VALUES ('D5804/D5801', '宜昌东', '武汉', '20:40:00', '23:17:00', 1, 323);
INSERT INTO routine VALUES ('D5805/D5808', '汉口', '恩施', '11:24:00', '15:28:00', 1, 506);
INSERT INTO routine VALUES ('D5806/D5807', '武汉', '宜昌东', '09:33:00', '11:55:00', 1, 323);
INSERT INTO routine VALUES ('D5810/D5811', '武汉', '宜昌东', '15:43:00', '18:19:00', 1, 323);
INSERT INTO routine VALUES ('D5814/D5815', '武汉', '利川', '08:15:00', '13:28:00', 1, 603);
INSERT INTO routine VALUES ('D5817/D5820', '汉口', '宜昌东', '06:56:00', '08:45:00', 1, 292);
INSERT INTO routine VALUES ('D5821/D5824', '汉口', '荆州', '19:08:00', '20:39:00', 1, 204);
INSERT INTO routine VALUES ('D5822/D5823', '武汉', '宜昌东', '16:21:00', '18:48:00', 1, 323);
INSERT INTO routine VALUES ('D5825/D5828', '汉口', '宜昌东', '18:00:00', '20:07:00', 1, 292);
INSERT INTO routine VALUES ('D5861/D5864', '宜昌东', '大冶北', '16:05:00', '19:56:00', 1, 423);
INSERT INTO routine VALUES ('D5862/D5863', '大冶北', '宜昌东', '07:35:00', '10:55:00', 1, 423);
INSERT INTO routine VALUES ('D5866/D5867', '阳新', '恩施', '08:05:00', '13:51:00', 1, 688);
INSERT INTO routine VALUES ('D5881/D5884', '利川', '黄冈东', '14:35:00', '20:35:00', 1, 668);
INSERT INTO routine VALUES ('D5882/D5883', '黄冈东', '利川', '07:52:00', '14:03:00', 1, 668);
INSERT INTO routine VALUES ('D5941', '汉口', '宜昌东', '07:13:00', '09:08:00', 1, 292);
INSERT INTO routine VALUES ('D5943', '汉口', '恩施', '06:31:00', '10:28:00', 1, 506);
INSERT INTO routine VALUES ('D5945', '汉口', '宜昌东', '17:30:00', '19:32:00', 1, 292);
INSERT INTO routine VALUES ('D5947', '汉口', '宜昌东', '07:47:00', '09:55:00', 1, 292);
INSERT INTO routine VALUES ('D5949', '汉口', '宜昌东', '09:03:00', '11:00:00', 1, 292);
INSERT INTO routine VALUES ('D5951', '汉口', '利川', '14:16:00', '19:36:00', 1, 567);
INSERT INTO routine VALUES ('D5953', '汉口', '宜昌东', '19:09:00', '21:18:00', 1, 292);
INSERT INTO routine VALUES ('D5955', '汉口', '荆州', '19:55:00', '21:26:00', 1, 204);
INSERT INTO routine VALUES ('D5957', '汉口', '宜昌东', '13:41:00', '15:43:00', 1, 292);
INSERT INTO routine VALUES ('D5959', '汉口', '荆州', '16:57:00', '18:31:00', 1, 204);
INSERT INTO routine VALUES ('D5961', '汉口', '宜昌东', '19:09:00', '21:16:00', 1, 292);
INSERT INTO routine VALUES ('D5965', '汉口', '恩施', '11:23:00', '15:38:00', 1, 506);
INSERT INTO routine VALUES ('D5991/D5994', '孝感东', '宜昌东', '15:29:00', '18:57:00', 1, 353);
INSERT INTO routine VALUES ('D5992/D5993', '恩施', '孝感东', '08:45:00', '13:22:00', 1, 567);
INSERT INTO routine VALUES ('D618/D619', '武汉', '成都东', '08:54:00', '18:50:00', 1, 1185);
INSERT INTO routine VALUES ('D625', '汉口', '重庆北', '08:26:00', '15:10:00', 1, 845);
INSERT INTO routine VALUES ('D627', '汉口', '重庆北', '07:31:00', '14:05:00', 1, 845);
INSERT INTO routine VALUES ('D629', '汉口', '重庆北', '09:32:00', '16:08:00', 1, 845);
INSERT INTO routine VALUES ('D632/D633', '武汉', '成都东', '06:25:00', '16:22:00', 1, 1185);
INSERT INTO routine VALUES ('D7001', '武汉', '阳新', '06:12:00', '07:08:00', 1, 131);
INSERT INTO routine VALUES ('D7003', '武汉', '阳新', '06:46:00', '07:45:00', 1, 131);
INSERT INTO routine VALUES ('D7005', '武汉', '阳新', '07:13:00', '08:15:00', 1, 131);
INSERT INTO routine VALUES ('D7007', '武汉', '大冶北', '08:01:00', '08:43:00', 1, 95);
INSERT INTO routine VALUES ('D7009', '武汉', '阳新', '10:15:00', '11:33:00', 1, 131);
INSERT INTO routine VALUES ('D7021', '麻城北', '武昌', '08:09:00', '09:14:00', 1, 111);
INSERT INTO routine VALUES ('D7022', '汉口', '麻城北', '07:05:00', '07:49:00', 1, 111);
INSERT INTO routine VALUES ('D7081/D7084', '孝感东', '咸宁南', '08:10:00', '10:25:00', 1, 172);
INSERT INTO routine VALUES ('D7085/D7088', '孝感东', '咸宁南', '15:20:00', '17:30:00', 1, 172);
INSERT INTO routine VALUES ('D7086/D7087', '咸宁南', '孝感东', '17:49:00', '20:11:00', 1, 172);
INSERT INTO routine VALUES ('D7553', '怀集', '深圳', '11:21:00', '14:20:00', 1, 315);
INSERT INTO routine VALUES ('D9342/D9343', '武昌', '十堰', '12:02:00', '16:27:00', 1, 493);
INSERT INTO routine VALUES ('D9499', '南京南', '安庆', '08:09:00', '10:15:00', 1, 257);
INSERT INTO routine VALUES ('D9529', '南京南', '安庆', '07:31:00', '09:25:00', 1, 257);
INSERT INTO routine VALUES ('D9531', '南京南', '安庆', '12:25:00', '14:32:00', 1, 257);
INSERT INTO routine VALUES ('D9533', '南京南', '安庆', '17:45:00', '19:47:00', 1, 257);
