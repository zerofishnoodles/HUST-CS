
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

-- ----------------------------
-- Records of routine
-- ----------------------------
INSERT INTO routine VALUES ('C5001', '武昌', '咸宁南', '07:09:00', '08:46:00', 1, 91);
INSERT INTO routine VALUES ('C5003', '武昌', '咸宁南', '10:11:00', '11:11:00', 1, 91);
INSERT INTO routine VALUES ('C5005', '武昌', '咸宁南', '12:37:00', '14:05:00', 1, 91);
INSERT INTO routine VALUES ('C5007', '武昌', '咸宁南', '15:42:00', '16:49:00', 1, 91);
INSERT INTO routine VALUES ('C5009', '武昌', '咸宁南', '18:33:00', '19:48:00', 1, 91);
INSERT INTO routine VALUES ('C5010', '咸宁南', '汉口', '20:03:00', '21:12:00', 1, 111);
INSERT INTO routine VALUES ('C5021', '武昌', '咸宁南', '08:07:00', '09:28:00', 1, 91);
INSERT INTO routine VALUES ('C5023', '武昌', '咸宁南', '11:30:00', '13:07:00', 1, 91);
INSERT INTO routine VALUES ('C5025', '武昌', '咸宁南', '15:18:00', '16:14:00', 1, 91);
INSERT INTO routine VALUES ('C5027', '武昌', '咸宁南', '17:50:00', '19:00:00', 1, 91);
INSERT INTO routine VALUES ('C5028', '咸宁南', '汉口', '19:22:00', '20:53:00', 1, 111);
INSERT INTO routine VALUES ('C5301', '汉口', '孝感东', '06:14:00', '06:40:00', 1, 61);
INSERT INTO routine VALUES ('C5303', '汉口', '孝感东', '13:12:00', '13:53:00', 1, 61);
INSERT INTO routine VALUES ('C5305', '汉口', '孝感东', '09:16:00', '09:50:00', 1, 61);
INSERT INTO routine VALUES ('C5307', '汉口', '孝感东', '14:35:00', '15:11:00', 1, 61);
INSERT INTO routine VALUES ('C5309', '汉口', '孝感东', '13:07:00', '13:52:00', 1, 61);
INSERT INTO routine VALUES ('C5311', '汉口', '孝感东', '06:30:00', '06:56:00', 1, 61);
INSERT INTO routine VALUES ('C5313', '汉口', '孝感东', '08:21:00', '09:14:00', 1, 61);
INSERT INTO routine VALUES ('C5315', '汉口', '孝感东', '10:39:00', '11:16:00', 1, 61);
INSERT INTO routine VALUES ('C5317', '汉口', '孝感东', '12:46:00', '13:33:00', 1, 61);
INSERT INTO routine VALUES ('C5337', '汉口', '孝感东', '07:10:00', '07:38:00', 1, 61);
INSERT INTO routine VALUES ('C5339', '汉口', '孝感东', '14:10:00', '14:44:00', 1, 61);
INSERT INTO routine VALUES ('C5341', '汉口', '孝感东', '14:34:00', '15:14:00', 1, 61);
INSERT INTO routine VALUES ('C5521', '武汉', '大冶北', '06:33:00', '07:13:00', 1, 95);
INSERT INTO routine VALUES ('C5601', '武汉', '黄冈东', '06:26:00', '07:03:00', 1, 65);
INSERT INTO routine VALUES ('C5603', '武汉', '黄冈东', '08:15:00', '08:56:00', 1, 65);
INSERT INTO routine VALUES ('C5605', '武汉', '黄冈东', '13:35:00', '14:16:00', 1, 65);
INSERT INTO routine VALUES ('C5607', '武汉', '黄冈东', '15:33:00', '16:31:00', 1, 65);
INSERT INTO routine VALUES ('C5609', '武汉', '黄冈东', '18:00:00', '18:41:00', 1, 65);
INSERT INTO routine VALUES ('C5611', '武汉', '黄冈东', '07:43:00', '08:35:00', 1, 65);
INSERT INTO routine VALUES ('C5613', '武汉', '黄冈东', '09:50:00', '10:46:00', 1, 65);
INSERT INTO routine VALUES ('C5615', '武汉', '黄冈东', '12:31:00', '13:22:00', 1, 65);
INSERT INTO routine VALUES ('C5617', '武汉', '黄冈东', '15:00:00', '15:47:00', 1, 65);
INSERT INTO routine VALUES ('C5619', '武汉', '黄冈东', '17:02:00', '17:38:00', 1, 65);
INSERT INTO routine VALUES ('C5631', '武汉', '黄冈东', '06:53:00', '07:34:00', 1, 65);
INSERT INTO routine VALUES ('C5633', '武汉', '黄冈东', '07:06:00', '07:43:00', 1, 65);
INSERT INTO routine VALUES ('C5635', '武汉', '黄冈东', '08:24:00', '09:01:00', 1, 65);
INSERT INTO routine VALUES ('C9205', '汉口', '十堰东', '13:45:00', '16:39:00', 1, 460);
INSERT INTO routine VALUES ('D2175/D2178', '武汉', '千岛湖', '08:10:00', '13:26:00', 1, 638);
INSERT INTO routine VALUES ('D2187/D2190', '汉口', '杭州', '09:36:00', '14:35:00', 1, 772);
INSERT INTO routine VALUES ('D2191/D2194', '宜昌东', '杭州东', '08:52:00', '15:50:00', 1, 1280);
INSERT INTO routine VALUES ('D2195/D2198', '汉口', '宁波', '06:45:00', '12:15:00', 1, 927);
INSERT INTO routine VALUES ('D2251', '汉口', '重庆北', '07:42:00', '14:27:00', 1, 845);
INSERT INTO routine VALUES ('D2259', '汉口', '成都东', '10:36:00', '19:39:00', 1, 1149);
INSERT INTO routine VALUES ('D2265', '汉口', '重庆北', '14:22:00', '21:00:00', 1, 845);
INSERT INTO routine VALUES ('D2276/D2277', '武汉', '重庆北', '08:07:00', '15:15:00', 1, 876);
INSERT INTO routine VALUES ('D25', '北京', '佳木斯', '10:28:00', '21:19:00', 1, 1591);
INSERT INTO routine VALUES ('D3001/D3004', '汉口', '上海南', '17:25:00', '23:29:00', 1, 847);
INSERT INTO routine VALUES ('D3002/D3003', '上海虹桥', '汉口', '06:38:00', '12:02:00', 1, 827);
INSERT INTO routine VALUES ('D3005/D3008', '宜昌东', '上海虹桥', '06:55:00', '15:15:00', 1, 1121);
INSERT INTO routine VALUES ('D3009/D3012', '汉口', '上海虹桥', '08:30:00', '14:21:00', 1, 827);
INSERT INTO routine VALUES ('D3013/D3016', '汉口', '上海虹桥', '07:59:00', '13:22:00', 1, 827);
INSERT INTO routine VALUES ('D3021/D3024', '武昌', '上海虹桥', '15:43:00', '21:37:00', 1, 849);
INSERT INTO routine VALUES ('D3025/D3028', '汉口', '上海虹桥', '07:31:00', '13:06:00', 1, 827);
INSERT INTO routine VALUES ('D3031/D3034', '宜昌东', '上海虹桥', '06:33:00', '14:47:00', 1, 1121);
INSERT INTO routine VALUES ('D3041/D3044', '武昌', '上海虹桥', '09:40:00', '16:00:00', 1, 849);
INSERT INTO routine VALUES ('D3045/D3048', '武昌', '上海虹桥', '11:25:00', '17:28:00', 1, 847);
INSERT INTO routine VALUES ('D3059/D3062', '汉口', '嘉兴南', '16:20:00', '22:35:00', 1, 911);
INSERT INTO routine VALUES ('D3063/D3066', '汉口', '上海南', '16:38:00', '22:47:00', 1, 847);
INSERT INTO routine VALUES ('D3067/D3070', '汉口', '上海南', '15:50:00', '22:13:00', 1, 847);
INSERT INTO routine VALUES ('D3082', '宜昌东', '南京南', '09:01:00', '14:22:00', 1, 808);
INSERT INTO routine VALUES ('D3084', '宜昌东', '南京南', '10:03:00', '15:06:00', 1, 808);
INSERT INTO routine VALUES ('D3089/D3092', '汉口', '上海虹桥', '15:36:00', '20:50:00', 1, 811);
INSERT INTO routine VALUES ('D3151/D3154', '汉口', '南通', '14:26:00', '19:56:00', 1, 767);
INSERT INTO routine VALUES ('D3155/D3158', '汉口', '南通', '10:29:00', '15:45:00', 1, 767);
INSERT INTO routine VALUES ('D3223', '武汉', '南昌', '17:16:00', '20:14:00', 1, 344);
INSERT INTO routine VALUES ('D3241', '武汉', '南昌西', '08:50:00', '11:19:00', 1, 344);
INSERT INTO routine VALUES ('D3245', '武汉', '南昌', '14:46:00', '17:11:00', 1, 344);
INSERT INTO routine VALUES ('D3251/D3254', '重庆北', '南昌西', '09:26:00', '19:37:00', 1, 1215);
INSERT INTO routine VALUES ('D3252/D3253', '南昌西', '重庆北', '07:36:00', '17:25:00', 1, 1215);
INSERT INTO routine VALUES ('D3255/D3258', '宜昌东', '南昌西', '09:10:00', '14:16:00', 1, 675);
INSERT INTO routine VALUES ('D3262/D3263', '汉口', '福州', '08:09:00', '14:38:00', 1, 916);
INSERT INTO routine VALUES ('D3265', '武汉', '福州', '14:55:00', '21:09:00', 1, 880);
INSERT INTO routine VALUES ('D3272/D3273', '汉口', '厦门北', '12:37:00', '20:23:00', 1, 1068);
INSERT INTO routine VALUES ('D3276/D3277', '汉口', '厦门北', '08:16:00', '16:11:00', 1, 1068);
INSERT INTO routine VALUES ('D3281/D3284', '武汉', '景德镇北', '20:35:00', '22:53:00', 1, 380);
INSERT INTO routine VALUES ('D3286/D3287', '汉口', '梅州西', '10:14:00', '21:06:00', 1, 1381);
INSERT INTO routine VALUES ('D3289', '武汉', '厦门北', '14:00:00', '21:14:00', 1, 1172);
INSERT INTO routine VALUES ('D3395/D3398', '汉口', '杭州东', '09:12:00', '15:50:00', 1, 772);
INSERT INTO routine VALUES ('D361', '汉口', '成都东', '12:25:00', '21:42:00', 1, 1149);
INSERT INTO routine VALUES ('D366/D367', '武汉', '成都东', '07:38:00', '17:05:00', 1, 1185);
INSERT INTO routine VALUES ('D4204', '武汉', '南京南', '20:04:00', '23:36:00', 1, 512);
INSERT INTO routine VALUES ('D4668/D4669', '上海虹桥', '汉口', '01:24:00', '05:23:00', 1, 827);
INSERT INTO routine VALUES ('D4670/D4667', '汉口', '上海虹桥', '20:44:00', '00:56:00', 2, 827);
INSERT INTO routine VALUES ('D4678/D4679', '上海虹桥', '汉口', '01:17:00', '05:18:00', 1, 827);
INSERT INTO routine VALUES ('D4680/D4677', '汉口', '上海虹桥', '20:28:00', '00:41:00', 2, 827);
INSERT INTO routine VALUES ('D4684/D4681', '汉口', '上海虹桥', '19:36:00', '00:04:00', 2, 827);
INSERT INTO routine VALUES ('D4694/D4695', '上海虹桥', '汉口', '21:52:00', '02:36:00', 2, 827);
INSERT INTO routine VALUES ('D4696/D4693', '汉口', '上海虹桥', '03:01:00', '07:40:00', 1, 827);
INSERT INTO routine VALUES ('D4698/D4699', '上海', '汉口', '20:20:00', '01:15:00', 2, 827);
INSERT INTO routine VALUES ('D4700/D4697', '汉口', '上海', '01:35:00', '06:05:00', 1, 827);
INSERT INTO routine VALUES ('D4794', '汉口', '南京南', '09:46:00', '13:07:00', 1, 516);
INSERT INTO routine VALUES ('D4804/D4801', '汉口', '杭州东', '22:52:00', '02:47:00', 2, 772);
INSERT INTO routine VALUES ('D4806/D4807', '上海虹桥', '汉口', '04:00:00', '08:24:00', 1, 827);
INSERT INTO routine VALUES ('D4808/G4805', '汉口', '上海虹桥', '23:26:00', '03:39:00', 2, 827);
INSERT INTO routine VALUES ('D4813/D4816', '汉口', '上海虹桥', '03:48:00', '08:22:00', 1, 827);

