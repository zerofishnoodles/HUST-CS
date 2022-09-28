drop database if exists  covid19mon ;
create database covid19mon ;  
use covid19mon;

-- 表1 人员表(person)
create table person (
  id int not null,
  fullname char(20)   not null,
  telephone char(11) not null,
  constraint pk_person primary key(id)
);

-- 表2 地点表(location)
create table location (
  id int not null,
  location_name char(20)  not null,
  constraint pk_location primary key(id)
);

-- 表3 行程表（itinerary）
drop table if exists itinerary;
create table itinerary (
  id int  not null,
  p_id int,
  loc_id int,
  s_time datetime,
  e_time datetime,
  constraint pk_itinerary primary key(id),
  constraint fk_itinerary_pid foreign key(p_id) references person(id),
  constraint fk_itinerary_lid foreign key(loc_id) references location(id)
);

-- 表4 诊断表（diagnose_record）
create table diagnose_record (
  id int  not null,
  p_id int,
  diagnose_date datetime,
  result int,
  constraint pk_diagnose_record primary key(id),
  constraint fk_diagnose_pid foreign key(p_id) references person(id)
);


-- 表5 密切接触者表（close_contact）
create table close_contact (
  id int not null,
  p_id int ,
  contact_date datetime,
  loc_id int,
  case_p_id int,
  constraint pk_close_contact primary key(id),
  constraint fk_contact_pid foreign key(p_id) references person(id),
  constraint fk_contact_lid foreign key(loc_id) references location(id),
  constraint fk_contact_caseid foreign key(case_p_id) references person(id)
);

-- 表6 隔离地点表（isolation_location）
create table isolation_location (
  id int  not null,
  location_name char(20) ,
  capacity int,
  constraint pk_isolation_loc primary key(id)
);

-- 表7 隔离表（isolation_record）
create table isolation_record (
  id int  not null,
  p_id int,
  s_date datetime,
  e_date datetime,
  isol_loc_id int,
  state int,
  constraint pk_isolation primary key(id),
  constraint fk_isolation_pid foreign key(p_id) references person(id),
  constraint fk_isolation_lid foreign key(isol_loc_id) references isolation_location(id)
);


/* ***********************  建库建表结束  ************************** */ 

INSERT INTO person VALUES (1, '明一伟','17248275719'),
(2, '方斯雪','13967381281'),
(3, '贾涵山','17341017981'),
(4, '白燕子','15881113869'),
(5, '耿如冰','13750726610'),
(6, '农寒天','15881113869'),
(7, '党野云','13750726610'),
(8, '寇雯华','13632078253'),
(9, '龚文君','13375196839'),
(10, '金雪兰','19126333978'),
(11, '充珉瑶','18587071864'),
(12, '逢盼曼','13418868855'),
(13, '雍惜筠','18296733300'),
(14, '国柔丽','15563856139'),
(15, '宓珺琦','16512657944'),
(16, '江梓悦','13475951871'),
(17, '杜绮艳','15393201024'),
(18, '张春娇','13772096644'),
(19, '阴梦凡','18637418149'),
(20, '姜童彤','17800555907'),
(21, '温昊怡','18164837835'),
(22, '漕凝远','17211951927'),
(23, '游娇洁','17008539330'),
(24, '田淑华','15859921826'),
(25, '巴小玉','18069563673'),
(26, '晃妙菱','19156197031'),
(27, '冉子惠','15539691128'),
(28, '丁冷雁','13512817556'),
(29, '靳宛儿','18527483841'),
(30, '游华芝','14730292619'),
(31, '暨欢欣','15661993913'),
(32, '屠凝思','17311095186'),
(33, '满洁雅','15582191038'),
(34, '浦梓欣','14650522523'),
(35, '田春琳','17680871106'),
(36, '陈觅风','14569236126'),
(37, '班秋柳','18359202773'),
(38, '龙灵松','18944032183'),
(39, '魏瑶瑾','19856341540'),
(40, '能梦容','15225679479'),
(41, '聂娅欣','17008206382'),
(42, '麴玉兰','15760462400'),
(43, '古沛文','13656713006'),
(44, '汪春燕','19864895791'),
(45, '段怀柔','18346347090'),
(46, '甘辰雪','13653671369'),
(47, '吴晴曦','18746061522'),
(48, '富昱瑛','13954808100'),
(49, '古郁安','15903525244'),
(50, '景静安','14585237285');  


-- location
insert into location values (1, '超市'),
(2, '烧烤店'),
(3, '活动中心'),
(4, '棋牌室'),
(5, '电玩城'),
(6, 'Today便利店'),
(7, '第一医院'),
(8, '电影院'),
(9, '艺术馆'),
(10, '密室逃脱'),
(11, '桌游吧'),
(12, '奶茶店'),
(13, '蛋糕店'),
(14, '网咖'),
(15, '火锅店'),
(16, '博物馆');

-- select * from location;
-- isolation_location

INSERT INTO isolation_location VALUES (1, '马丁内斯酒店', 25),
(2, '威尔逊总统酒店', 20),
(3, '拉格尼斯大度假村',15),
(4, '卡拉沃尔普酒店', 10),
(5, '集中隔离点', 30),
(6, '斯威特快捷酒店',30);

-- diagnose_record
-- delete diagnose_record;

INSERT INTO diagnose_record VALUES (1, 29, '2021-02-04 10:00:00', 2),
 (2, 39, '2021-02-04 10:000', 2),
 (3, 30, '2021-02-04 10:00:00', 1),
 (4, 22, '2021-02-04 10:00:00', 1),
 (5, 31, '2021-02-04 10:00:00', 2),
 (6, 14, '2021-02-04 10:00:00', 2),
 (7, 26, '2021-02-04 10:00:00', 1),
 (8, 36, '2021-02-04 10:00:00', 1),
 (9, 23, '2021-02-04 10:00:00', 3),
 (10,7, '2021-02-04 10:00:00', 1);

-- select * from diagnose_record;
-- itininerary
-- select * from itinerary
insert into itinerary values (1,25,7,'2021-02-02 10:14:40.000','2021-02-02 10:53:40.000'),
(2,25,12,'2021-02-02 10:54:40.000','2021-02-02 11:25:40.000'),
(3,25,15,'2021-02-02 11:29:40.000','2021-02-02 11:57:40.000'),
(4,25,11,'2021-02-02 11:57:40.000','2021-02-02 13:46:40.000'),
(5,25,13,'2021-02-02 13:48:40.000','2021-02-02 15:31:40.000'),
(6,25,5,'2021-02-02 15:34:40.000','2021-02-02 16:28:40.000'),
(7,25,8,'2021-02-02 16:30:40.000','2021-02-02 18:24:40.000'),
(8,25,14,'2021-02-02 18:28:40.000','2021-02-02 18:40:40.000'),
(9,25,10,'2021-02-02 18:44:40.000','2021-02-02 20:01:40.000'),
(10,25,3,'2021-02-02 20:05:40.000','2021-02-02 21:25:40.000'),
(11,25,9,'2021-02-02 21:25:40.000','2021-02-02 22:27:40.000'),
(12,1,3,'2021-02-02 00:52:21.000','2021-02-02 02:24:21.000'),
(13,4,9,'2021-02-02 15:02:09.000','2021-02-02 16:08:09.000'),
(14,4,15,'2021-02-02 16:10:09.000','2021-02-02 17:15:09.000'),
(15,4,11,'2021-02-02 17:16:09.000','2021-02-02 17:40:09.000'),
(16,4,8,'2021-02-02 17:40:09.000','2021-02-02 18:12:09.000'),
(17,4,10,'2021-02-02 18:15:09.000','2021-02-02 18:24:09.000'),
(18,4,6,'2021-02-02 18:26:09.000','2021-02-02 19:32:09.000'),
(19,4,1,'2021-02-02 19:35:09.000','2021-02-02 21:05:09.000'),
(20,4,3,'2021-02-02 21:09:09.000','2021-02-02 22:47:09.000'),
(21,4,16,'2021-02-02 22:49:09.000','2021-02-03 00:32:09.000'),
(22,4,12,'2021-02-03 00:32:09.000','2021-02-03 00:58:09.000'),
(23,4,4,'2021-02-03 00:58:09.000','2021-02-03 02:55:09.000'),
(24,4,13,'2021-02-03 02:58:09.000','2021-02-03 03:02:09.000'),
(25,4,2,'2021-02-03 03:05:09.000','2021-02-03 03:57:09.000'),
(26,4,5,'2021-02-03 04:01:09.000','2021-02-03 06:00:09.000'),
(27,4,7,'2021-02-03 06:01:09.000','2021-02-03 07:56:09.000'),
(28,5,16,'2021-02-02 15:56:29.000','2021-02-02 16:18:29.000'),
(29,5,1,'2021-02-02 16:19:29.000','2021-02-02 16:38:29.000'),
(30,5,4,'2021-02-02 16:41:29.000','2021-02-02 18:19:29.000'),
(31,5,7,'2021-02-02 18:19:29.000','2021-02-02 18:35:29.000'),
(32,5,11,'2021-02-02 18:37:29.000','2021-02-02 20:16:29.000'),
(33,5,5,'2021-02-02 20:20:29.000','2021-02-02 21:54:29.000'),
(34,5,9,'2021-02-02 21:56:29.000','2021-02-02 23:01:29.000'),
(35,5,8,'2021-02-02 23:03:29.000','2021-02-02 23:07:29.000'),
(36,5,13,'2021-02-02 23:09:29.000','2021-02-03 00:11:29.000'),
(37,5,12,'2021-02-03 00:13:29.000','2021-02-03 00:55:29.000'),
(38,5,6,'2021-02-03 00:59:29.000','2021-02-03 01:20:29.000'),
(39,5,14,'2021-02-03 01:20:29.000','2021-02-03 03:09:29.000'),
(40,5,3,'2021-02-03 03:09:29.000','2021-02-03 04:01:29.000'),
(41,5,10,'2021-02-03 04:03:29.000','2021-02-03 04:45:29.000'),
(42,5,2,'2021-02-03 04:48:29.000','2021-02-03 06:22:29.000'),
(43,5,15,'2021-02-03 06:22:29.000','2021-02-03 07:38:29.000'),
(44,5,16,'2021-02-03 07:42:29.000','2021-02-03 07:45:29.000'),
(45,5,1,'2021-02-03 07:48:29.000','2021-02-03 08:21:29.000'),
(46,5,4,'2021-02-03 08:23:29.000','2021-02-03 09:46:29.000'),
(47,5,7,'2021-02-03 09:49:29.000','2021-02-03 10:02:29.000'),
(48,22,12,'2021-02-02 23:11:47.000','2021-02-03 00:10:47.000'),
(49,22,14,'2021-02-03 00:13:47.000','2021-02-03 00:46:47.000'),
(50,22,11,'2021-02-03 00:47:47.000','2021-02-03 01:24:47.000'),
(51,22,6,'2021-02-03 01:28:47.000','2021-02-03 02:43:47.000'),
(52,36,8,'2021-02-02 07:39:40.000','2021-02-02 08:18:40.000'),
(53,36,1,'2021-02-02 08:20:40.000','2021-02-02 10:12:40.000'),
(54,36,12,'2021-02-02 10:14:40.000','2021-02-02 11:32:40.000'),
(55,36,11,'2021-02-02 11:32:40.000','2021-02-02 12:04:40.000'),
(56,36,14,'2021-02-02 12:07:40.000','2021-02-02 13:54:40.000'),
(57,36,4,'2021-02-02 13:57:40.000','2021-02-02 15:49:40.000'),
(58,36,7,'2021-02-02 15:52:40.000','2021-02-02 17:30:40.000'),
(59,36,3,'2021-02-02 17:30:40.000','2021-02-02 18:47:40.000'),
(61,46,3,'2021-02-02 05:10:04.000','2021-02-02 05:32:04.000'),
(62,46,10,'2021-02-02 05:35:04.000','2021-02-02 05:59:04.000'),
(63,46,9,'2021-02-02 06:02:04.000','2021-02-02 07:32:04.000'),
(64,46,4,'2021-02-02 07:32:04.000','2021-02-02 08:10:04.000'),
(65,46,16,'2021-02-02 08:13:04.000','2021-02-02 08:34:04.000'),
(66,46,8,'2021-02-02 08:34:04.000','2021-02-02 10:00:04.000'),
(67,46,13,'2021-02-02 10:00:04.000','2021-02-02 11:59:04.000'),
(68,46,15,'2021-02-02 11:59:04.000','2021-02-02 12:40:04.000'),
(69,46,11,'2021-02-02 12:43:04.000','2021-02-02 13:58:04.000'),
(70,46,12,'2021-02-02 14:02:04.000','2021-02-02 15:45:04.000'),
(71,46,2,'2021-02-02 15:46:04.000','2021-02-02 17:05:04.000'),
(72,46,5,'2021-02-02 17:09:04.000','2021-02-02 17:31:04.000'),
(73,46,14,'2021-02-02 17:35:04.000','2021-02-02 19:33:04.000'),
(74,46,7,'2021-02-02 19:36:04.000','2021-02-02 20:46:04.000'),
(75,46,1,'2021-02-02 20:48:04.000','2021-02-02 21:09:04.000'),
(76,46,6,'2021-02-02 21:10:04.000','2021-02-02 22:27:04.000'),
(77,46,3,'2021-02-02 22:27:04.000','2021-02-02 22:41:04.000'),
(78,46,10,'2021-02-02 22:45:04.000','2021-02-03 00:17:04.000'),
(79,46,9,'2021-02-03 00:17:04.000','2021-02-03 01:13:04.000'),
(80,48,2,'2021-02-02 06:54:09.000','2021-02-02 06:55:09.000'),
(81,48,12,'2021-02-02 06:56:09.000','2021-02-02 07:32:09.000'),
(82,16,7,'2021-02-02 16:45:09.000','2021-02-02 18:18:09.000'),
(83,16,14,'2021-02-02 18:21:09.000','2021-02-02 19:48:09.000'),
(84,16,10,'2021-02-02 19:48:09.000','2021-02-02 20:17:09.000'),
(85,16,12,'2021-02-02 20:19:09.000','2021-02-02 21:52:09.000'),
(86,16,9,'2021-02-02 21:52:09.000','2021-02-02 22:20:09.000'),
(87,16,13,'2021-02-02 22:24:09.000','2021-02-02 23:34:09.000'),
(88,16,15,'2021-02-02 23:35:09.000','2021-02-03 01:28:09.000'),
(89,16,2,'2021-02-03 01:28:09.000','2021-02-03 02:21:09.000'),
(90,16,16,'2021-02-03 02:23:09.000','2021-02-03 02:39:09.000'),
(91,41,4,'2021-02-02 02:44:47.000','2021-02-02 04:42:47.000'),
(92,41,2,'2021-02-02 04:45:47.000','2021-02-02 06:24:47.000'),
(93,41,10,'2021-02-02 06:28:47.000','2021-02-02 08:05:47.000'),
(94,41,3,'2021-02-02 08:09:47.000','2021-02-02 09:30:47.000'),
(95,41,11,'2021-02-02 09:34:47.000','2021-02-02 10:13:47.000'),
(96,41,13,'2021-02-02 10:15:47.000','2021-02-02 11:06:47.000'),
(97,41,7,'2021-02-02 11:06:47.000','2021-02-02 12:08:47.000'),
(98,41,12,'2021-02-02 12:10:47.000','2021-02-02 12:51:47.000'),
(99,41,1,'2021-02-02 12:51:47.000','2021-02-02 14:27:47.000'),
(100,41,9,'2021-02-02 14:29:47.000','2021-02-02 14:32:47.000'),
(101,41,5,'2021-02-02 14:34:47.000','2021-02-02 15:15:47.000'),
(102,41,15,'2021-02-02 15:19:47.000','2021-02-02 15:31:47.000'),
(103,41,6,'2021-02-02 15:35:47.000','2021-02-02 16:50:47.000'),
(104,41,8,'2021-02-02 16:54:47.000','2021-02-02 17:27:47.000'),
(105,15,8,'2021-02-02 15:50:07.000','2021-02-02 16:08:07.000'),
(106,15,12,'2021-02-02 16:12:07.000','2021-02-02 16:18:07.000'),
(107,15,3,'2021-02-02 16:20:07.000','2021-02-02 16:30:07.000'),
(108,15,7,'2021-02-02 16:32:07.000','2021-02-02 17:08:07.000'),
(109,15,11,'2021-02-02 17:08:07.000','2021-02-02 17:27:07.000'),
(110,15,15,'2021-02-02 17:30:07.000','2021-02-02 19:03:07.000'),
(111,15,2,'2021-02-02 19:07:07.000','2021-02-02 19:31:07.000'),
(112,15,10,'2021-02-02 19:33:07.000','2021-02-02 19:44:07.000'),
(113,15,9,'2021-02-02 19:44:07.000','2021-02-02 21:10:07.000'),
(114,27,6,'2021-02-02 22:20:07.000','2021-02-02 22:22:07.000'),
(115,27,1,'2021-02-02 22:24:07.000','2021-02-02 23:48:07.000'),
(116,27,12,'2021-02-02 23:50:07.000','2021-02-03 00:19:07.000'),
(117,27,2,'2021-02-03 00:20:07.000','2021-02-03 02:14:07.000'),
(118,27,7,'2021-02-03 02:18:07.000','2021-02-03 04:10:07.000'),
(119,27,13,'2021-02-03 04:13:07.000','2021-02-03 06:01:07.000'),
(120,14,9,'2021-02-02 15:01:58.000','2021-02-02 15:58:58.000'),
(121,14,4,'2021-02-02 16:01:58.000','2021-02-02 18:00:58.000'),
(122,14,2,'2021-02-02 18:02:58.000','2021-02-02 19:32:58.000'),
(123,14,10,'2021-02-02 19:33:58.000','2021-02-02 19:44:58.000'),
(124,14,11,'2021-02-02 19:48:58.000','2021-02-02 20:59:58.000'),
(125,14,6,'2021-02-02 21:02:58.000','2021-02-02 22:59:58.000'),
(126,14,8,'2021-02-02 22:59:58.000','2021-02-02 23:24:58.000'),
(127,14,16,'2021-02-02 23:24:58.000','2021-02-03 00:36:58.000'),
(128,14,15,'2021-02-03 00:36:58.000','2021-02-03 01:58:58.000'),
(129,14,5,'2021-02-03 01:58:58.000','2021-02-03 03:08:58.000'),
(130,14,7,'2021-02-03 03:11:58.000','2021-02-03 03:50:58.000'),
(131,33,11,'2021-02-02 16:57:33.000','2021-02-02 17:05:33.000'),
(132,33,1,'2021-02-02 17:05:33.000','2021-02-02 17:22:33.000'),
(133,33,3,'2021-02-02 17:22:33.000','2021-02-02 17:27:33.000'),
(134,33,2,'2021-02-02 17:29:33.000','2021-02-02 17:41:33.000'),
(135,33,5,'2021-02-02 17:41:33.000','2021-02-02 18:54:33.000'),
(136,33,14,'2021-02-02 18:57:33.000','2021-02-02 20:13:33.000'),
(137,33,6,'2021-02-02 20:16:33.000','2021-02-02 21:31:33.000'),
(138,24,11,'2021-02-02 20:52:34.000','2021-02-02 20:54:34.000'),
(139,24,2,'2021-02-02 20:57:34.000','2021-02-02 21:23:34.000'),
(140,24,14,'2021-02-02 21:27:34.000','2021-02-02 23:06:34.000'),
(141,24,4,'2021-02-02 23:10:34.000','2021-02-02 23:50:34.000'),
(142,24,12,'2021-02-02 23:53:34.000','2021-02-03 01:15:34.000'),
(143,24,8,'2021-02-03 01:17:34.000','2021-02-03 01:25:34.000'),
(144,24,1,'2021-02-03 01:25:34.000','2021-02-03 02:23:34.000'),
(145,24,6,'2021-02-03 02:23:34.000','2021-02-03 02:32:34.000'),
(146,24,5,'2021-02-03 02:34:34.000','2021-02-03 03:21:34.000'),
(147,24,3,'2021-02-03 03:25:34.000','2021-02-03 05:19:34.000'),
(148,24,13,'2021-02-03 05:19:34.000','2021-02-03 05:58:34.000'),
(149,47,9,'2021-02-02 04:35:57.000','2021-02-02 06:29:57.000'),
(150,47,8,'2021-02-02 06:29:57.000','2021-02-02 06:38:57.000'),
(151,47,5,'2021-02-02 06:38:57.000','2021-02-02 07:25:57.000'),
(152,47,12,'2021-02-02 07:25:57.000','2021-02-02 07:47:57.000'),
(153,47,6,'2021-02-02 07:50:57.000','2021-02-02 07:59:57.000'),
(154,47,16,'2021-02-02 08:02:57.000','2021-02-02 08:40:57.000'),
(155,47,2,'2021-02-02 08:43:57.000','2021-02-02 09:31:57.000'),
(156,47,11,'2021-02-02 09:34:57.000','2021-02-02 10:27:57.000'),
(157,47,7,'2021-02-02 10:27:57.000','2021-02-02 10:58:57.000'),
(158,47,13,'2021-02-02 10:59:57.000','2021-02-02 12:18:57.000'),
(159,47,14,'2021-02-02 12:18:57.000','2021-02-02 12:58:57.000'),
(160,47,10,'2021-02-02 13:00:57.000','2021-02-02 14:38:57.000'),
(161,47,15,'2021-02-02 14:41:57.000','2021-02-02 15:51:57.000'),
(162,47,4,'2021-02-02 15:52:57.000','2021-02-02 16:12:57.000'),
(163,2,15,'2021-02-02 12:34:55.000','2021-02-02 13:48:55.000'),
(164,2,2,'2021-02-02 13:48:55.000','2021-02-02 14:37:55.000'),
(165,2,5,'2021-02-02 14:40:55.000','2021-02-02 14:44:55.000'),
(166,2,4,'2021-02-02 14:48:55.000','2021-02-02 15:03:55.000'),
(167,18,1,'2021-02-02 15:35:50.000','2021-02-02 15:38:50.000'),
(168,18,12,'2021-02-02 15:40:50.000','2021-02-02 17:22:50.000'),
(169,18,16,'2021-02-02 17:26:50.000','2021-02-02 18:48:50.000'),
(170,18,8,'2021-02-02 18:50:50.000','2021-02-02 19:15:50.000'),
(171,18,3,'2021-02-02 19:16:50.000','2021-02-02 20:17:50.000'),
(172,18,11,'2021-02-02 20:17:50.000','2021-02-02 20:30:50.000'),
(173,18,2,'2021-02-02 20:34:50.000','2021-02-02 20:42:50.000'),
(174,18,7,'2021-02-02 20:44:50.000','2021-02-02 20:58:50.000'),
(175,18,14,'2021-02-02 21:00:50.000','2021-02-02 22:36:50.000'),
(176,18,15,'2021-02-02 22:40:50.000','2021-02-03 00:23:50.000'),
(177,18,10,'2021-02-03 00:26:50.000','2021-02-03 01:19:50.000'),
(178,18,13,'2021-02-03 01:19:50.000','2021-02-03 02:30:50.000'),
(179,18,9,'2021-02-03 02:32:50.000','2021-02-03 03:49:50.000'),
(180,18,4,'2021-02-03 03:53:50.000','2021-02-03 04:56:50.000'),
(181,18,5,'2021-02-03 04:59:50.000','2021-02-03 06:54:50.000'),
(182,18,6,'2021-02-03 06:57:50.000','2021-02-03 07:46:50.000'),
(183,18,1,'2021-02-03 07:49:50.000','2021-02-03 08:22:50.000'),
(184,18,12,'2021-02-03 08:25:50.000','2021-02-03 08:26:50.000'),
(185,18,16,'2021-02-03 08:27:50.000','2021-02-03 08:58:50.000'),
(186,39,13,'2021-02-02 09:00:04.000','2021-02-02 09:25:04.000'),
(187,39,10,'2021-02-02 09:29:04.000','2021-02-02 11:16:04.000'),
(188,39,7,'2021-02-02 11:19:04.000','2021-02-02 13:08:04.000'),
(189,39,9,'2021-02-02 13:08:04.000','2021-02-02 14:56:04.000'),
(190,39,8,'2021-02-02 14:58:04.000','2021-02-02 15:52:04.000'),
(191,13,3,'2021-02-02 05:01:53.000','2021-02-02 05:28:53.000'),
(192,13,1,'2021-02-02 05:28:53.000','2021-02-02 06:10:53.000'),
(193,13,6,'2021-02-02 06:13:53.000','2021-02-02 07:55:53.000'),
(194,13,10,'2021-02-02 07:59:53.000','2021-02-02 08:58:53.000'),
(195,13,7,'2021-02-02 08:58:53.000','2021-02-02 10:40:53.000'),
(196,13,9,'2021-02-02 10:42:53.000','2021-02-02 10:43:53.000'),
(197,34,9,'2021-02-02 02:36:15.000','2021-02-02 04:36:15.000'),
(198,34,2,'2021-02-02 04:38:15.000','2021-02-02 05:40:15.000'),
(199,34,13,'2021-02-02 05:44:15.000','2021-02-02 06:35:15.000'),
(200,34,12,'2021-02-02 06:39:15.000','2021-02-02 07:45:15.000'),
(201,40,16,'2021-02-02 12:06:18.000','2021-02-02 12:33:18.000'),
(202,40,4,'2021-02-02 12:34:18.000','2021-02-02 14:27:18.000'),
(203,40,3,'2021-02-02 14:27:18.000','2021-02-02 15:37:18.000'),
(204,40,7,'2021-02-02 15:37:18.000','2021-02-02 16:13:18.000'),
(205,40,14,'2021-02-02 16:14:18.000','2021-02-02 17:45:18.000'),
(206,40,10,'2021-02-02 17:45:18.000','2021-02-02 19:35:18.000'),
(207,40,12,'2021-02-02 19:39:18.000','2021-02-02 20:52:18.000'),
(208,40,11,'2021-02-02 20:55:18.000','2021-02-02 21:12:18.000'),
(209,40,8,'2021-02-02 21:16:18.000','2021-02-02 22:58:18.000'),
(210,40,9,'2021-02-02 22:58:18.000','2021-02-03 00:56:18.000'),
(211,40,5,'2021-02-03 00:59:18.000','2021-02-03 02:52:18.000'),
(212,40,15,'2021-02-03 02:54:18.000','2021-02-03 03:28:18.000'),
(213,40,6,'2021-02-03 03:32:18.000','2021-02-03 05:32:18.000'),
(214,40,2,'2021-02-03 05:36:18.000','2021-02-03 05:47:18.000'),
(215,40,1,'2021-02-03 05:51:18.000','2021-02-03 07:35:18.000'),
(216,45,10,'2021-02-02 08:40:47.000','2021-02-02 09:34:47.000'),
(217,45,2,'2021-02-02 09:38:47.000','2021-02-02 10:35:47.000'),
(218,45,6,'2021-02-02 10:36:47.000','2021-02-02 10:58:47.000'),
(219,45,14,'2021-02-02 11:01:47.000','2021-02-02 12:32:47.000'),
(220,45,11,'2021-02-02 12:36:47.000','2021-02-02 13:37:47.000'),
(221,45,9,'2021-02-02 13:37:47.000','2021-02-02 13:59:47.000'),
(222,45,3,'2021-02-02 14:03:47.000','2021-02-02 14:59:47.000'),
(223,35,10,'2021-02-02 16:16:56.000','2021-02-02 16:37:56.000'),
(224,35,12,'2021-02-02 16:41:56.000','2021-02-02 18:01:56.000'),
(225,35,7,'2021-02-02 18:02:56.000','2021-02-02 18:15:56.000'),
(226,35,14,'2021-02-02 18:15:56.000','2021-02-02 18:23:56.000'),
(227,35,5,'2021-02-02 18:26:56.000','2021-02-02 19:12:56.000'),
(228,35,15,'2021-02-02 19:13:56.000','2021-02-02 20:17:56.000'),
(229,35,9,'2021-02-02 20:20:56.000','2021-02-02 20:55:56.000'),
(230,35,13,'2021-02-02 20:56:56.000','2021-02-02 21:37:56.000'),
(231,35,4,'2021-02-02 21:38:56.000','2021-02-02 22:40:56.000'),
(232,35,1,'2021-02-02 22:44:56.000','2021-02-02 23:41:56.000'),
(233,35,2,'2021-02-02 23:42:56.000','2021-02-03 01:01:56.000'),
(234,35,8,'2021-02-03 01:02:56.000','2021-02-03 01:51:56.000'),
(235,35,16,'2021-02-03 01:52:56.000','2021-02-03 02:40:56.000'),
(236,35,6,'2021-02-03 02:42:56.000','2021-02-03 04:17:56.000'),
(237,10,1,'2021-02-02 08:07:59.000','2021-02-02 08:19:59.000'),
(238,10,9,'2021-02-02 08:20:59.000','2021-02-02 09:07:59.000'),
(239,10,5,'2021-02-02 09:09:59.000','2021-02-02 09:56:59.000'),
(240,10,7,'2021-02-02 10:00:59.000','2021-02-02 11:46:59.000'),
(241,10,13,'2021-02-02 11:49:59.000','2021-02-02 11:57:59.000'),
(242,10,8,'2021-02-02 11:58:59.000','2021-02-02 13:39:59.000'),
(243,10,16,'2021-02-02 13:42:59.000','2021-02-02 15:40:59.000'),
(244,10,3,'2021-02-02 15:44:59.000','2021-02-02 17:26:59.000'),
(245,10,2,'2021-02-02 17:27:59.000','2021-02-02 18:13:59.000'),
(246,10,11,'2021-02-02 18:17:59.000','2021-02-02 18:27:59.000'),
(247,10,14,'2021-02-02 18:27:59.000','2021-02-02 19:58:59.000'),
(248,10,6,'2021-02-02 20:00:59.000','2021-02-02 21:34:59.000'),
(249,10,4,'2021-02-02 21:38:59.000','2021-02-02 23:35:59.000'),
(250,17,4,'2021-02-02 05:36:53.000','2021-02-02 06:10:53.000'),
(251,17,6,'2021-02-02 06:14:53.000','2021-02-02 07:11:53.000'),
(252,17,2,'2021-02-02 07:11:53.000','2021-02-02 09:00:53.000'),
(253,17,13,'2021-02-02 09:04:53.000','2021-02-02 09:39:53.000'),
(254,17,7,'2021-02-02 09:39:53.000','2021-02-02 11:05:53.000'),
(255,17,3,'2021-02-02 11:06:53.000','2021-02-02 12:42:53.000'),
(256,17,9,'2021-02-02 12:42:53.000','2021-02-02 12:52:53.000'),
(257,17,1,'2021-02-02 12:54:53.000','2021-02-02 14:25:53.000'),
(258,17,8,'2021-02-02 14:25:53.000','2021-02-02 15:23:53.000'),
(259,17,5,'2021-02-02 15:27:53.000','2021-02-02 15:36:53.000'),
(260,49,12,'2021-02-02 17:18:48.000','2021-02-02 17:42:48.000'),
(261,49,8,'2021-02-02 17:44:48.000','2021-02-02 17:57:48.000'),
(262,49,15,'2021-02-02 17:59:48.000','2021-02-02 19:07:48.000'),
(263,49,16,'2021-02-02 19:09:48.000','2021-02-02 19:35:48.000'),
(264,49,9,'2021-02-02 19:35:48.000','2021-02-02 21:08:48.000'),
(265,49,5,'2021-02-02 21:11:48.000','2021-02-02 22:06:48.000'),
(266,49,13,'2021-02-02 22:08:48.000','2021-02-02 22:31:48.000'),
(267,49,6,'2021-02-02 22:32:48.000','2021-02-02 22:41:48.000'),
(268,49,1,'2021-02-02 22:45:48.000','2021-02-02 23:11:48.000'),
(269,49,11,'2021-02-02 23:14:48.000','2021-02-03 00:09:48.000'),
(270,49,2,'2021-02-03 00:12:48.000','2021-02-03 00:28:48.000'),
(271,49,4,'2021-02-03 00:29:48.000','2021-02-03 01:09:48.000'),
(272,49,14,'2021-02-03 01:13:48.000','2021-02-03 02:08:48.000'),
(273,49,3,'2021-02-03 02:09:48.000','2021-02-03 03:43:48.000'),
(274,38,1,'2021-02-02 06:21:29.000','2021-02-02 07:32:29.000'),
(275,38,2,'2021-02-02 07:32:29.000','2021-02-02 08:42:29.000'),
(276,38,3,'2021-02-02 08:46:29.000','2021-02-02 10:09:29.000'),
(277,38,9,'2021-02-02 10:12:29.000','2021-02-02 10:55:29.000'),
(278,38,13,'2021-02-02 10:57:29.000','2021-02-02 11:09:29.000'),
(279,38,16,'2021-02-02 11:09:29.000','2021-02-02 12:22:29.000'),
(280,38,15,'2021-02-02 12:22:29.000','2021-02-02 13:08:29.000'),
(281,38,7,'2021-02-02 13:09:29.000','2021-02-02 14:30:29.000'),
(282,38,8,'2021-02-02 14:34:29.000','2021-02-02 16:25:29.000'),
(283,38,4,'2021-02-02 16:26:29.000','2021-02-02 16:45:29.000'),
(284,38,14,'2021-02-02 16:46:29.000','2021-02-02 18:25:29.000'),
(285,38,6,'2021-02-02 18:27:29.000','2021-02-02 20:23:29.000'),
(286,38,5,'2021-02-02 20:23:29.000','2021-02-02 22:22:29.000'),
(287,38,12,'2021-02-02 22:26:29.000','2021-02-02 22:37:29.000'),
(288,21,7,'2021-02-02 11:51:16.000','2021-02-02 12:55:16.000'),
(289,21,16,'2021-02-02 12:56:16.000','2021-02-02 14:29:16.000'),
(290,21,11,'2021-02-02 14:31:16.000','2021-02-02 14:37:16.000'),
(291,21,9,'2021-02-02 14:41:16.000','2021-02-02 15:45:16.000'),
(292,21,13,'2021-02-02 15:47:16.000','2021-02-02 16:12:16.000'),
(293,21,14,'2021-02-02 16:16:16.000','2021-02-02 16:59:16.000'),
(294,21,15,'2021-02-02 17:03:16.000','2021-02-02 18:22:16.000'),
(295,21,6,'2021-02-02 18:24:16.000','2021-02-02 19:02:16.000'),
(296,21,3,'2021-02-02 19:02:16.000','2021-02-02 20:56:16.000'),
(297,21,5,'2021-02-02 20:59:16.000','2021-02-02 21:33:16.000'),
(298,21,12,'2021-02-02 21:35:16.000','2021-02-02 22:25:16.000'),
(299,21,2,'2021-02-02 22:28:16.000','2021-02-02 23:11:16.000'),
(300,21,10,'2021-02-02 23:11:16.000','2021-02-03 00:06:16.000'),
(301,21,4,'2021-02-03 00:06:16.000','2021-02-03 00:55:16.000'),
(302,21,1,'2021-02-03 00:59:16.000','2021-02-03 01:33:16.000'),
(303,21,8,'2021-02-03 01:36:16.000','2021-02-03 02:21:16.000'),
(304,6,3,'2021-02-02 14:08:49.000','2021-02-02 15:57:49.000'),
(305,6,8,'2021-02-02 16:01:49.000','2021-02-02 16:37:49.000'),
(306,6,1,'2021-02-02 16:40:49.000','2021-02-02 17:14:49.000'),
(307,6,12,'2021-02-02 17:15:49.000','2021-02-02 19:07:49.000'),
(308,6,11,'2021-02-02 19:11:49.000','2021-02-02 19:36:49.000'),
(309,6,2,'2021-02-02 19:38:49.000','2021-02-02 19:48:49.000'),
(310,6,4,'2021-02-02 19:50:49.000','2021-02-02 21:41:49.000'),
(311,6,15,'2021-02-02 21:42:49.000','2021-02-02 23:35:49.000'),
(312,6,5,'2021-02-02 23:38:49.000','2021-02-03 00:15:49.000'),
(313,6,13,'2021-02-03 00:17:49.000','2021-02-03 01:02:49.000'),
(314,6,10,'2021-02-03 01:04:49.000','2021-02-03 01:50:49.000'),
(315,43,3,'2021-02-02 08:53:27.000','2021-02-02 10:12:27.000'),
(316,43,14,'2021-02-02 10:13:27.000','2021-02-02 10:42:27.000'),
(317,43,12,'2021-02-02 10:46:27.000','2021-02-02 12:44:27.000'),
(318,43,8,'2021-02-02 12:45:27.000','2021-02-02 14:24:27.000'),
(319,43,16,'2021-02-02 14:25:27.000','2021-02-02 16:07:27.000'),
(320,12,3,'2021-02-02 00:48:41.000','2021-02-02 00:51:41.000'),
(321,12,7,'2021-02-02 00:55:41.000','2021-02-02 01:11:41.000'),
(322,12,15,'2021-02-02 01:14:41.000','2021-02-02 02:15:41.000'),
(323,12,16,'2021-02-02 02:17:41.000','2021-02-02 03:06:41.000'),
(324,12,1,'2021-02-02 03:06:41.000','2021-02-02 04:16:41.000'),
(325,12,11,'2021-02-02 04:16:41.000','2021-02-02 06:00:41.000'),
(326,12,8,'2021-02-02 06:03:41.000','2021-02-02 06:38:41.000'),
(327,12,12,'2021-02-02 06:41:41.000','2021-02-02 08:21:41.000'),
(328,12,6,'2021-02-02 08:24:41.000','2021-02-02 10:14:41.000'),
(329,12,2,'2021-02-02 10:16:41.000','2021-02-02 10:56:41.000'),
(330,12,5,'2021-02-02 10:58:41.000','2021-02-02 12:04:41.000'),
(331,12,13,'2021-02-02 12:07:41.000','2021-02-02 12:34:41.000'),
(332,12,9,'2021-02-02 12:37:41.000','2021-02-02 13:16:41.000'),
(333,12,14,'2021-02-02 13:20:41.000','2021-02-02 14:26:41.000'),
(334,12,10,'2021-02-02 14:30:41.000','2021-02-02 15:11:41.000'),
(335,12,4,'2021-02-02 15:12:41.000','2021-02-02 16:08:41.000'),
(336,12,3,'2021-02-02 16:12:41.000','2021-02-02 18:08:41.000'),
(337,12,7,'2021-02-02 18:09:41.000','2021-02-02 19:22:41.000'),
(338,26,16,'2021-02-02 03:48:55.000','2021-02-02 03:51:55.000'),
(339,26,2,'2021-02-02 03:54:55.000','2021-02-02 04:39:55.000'),
(340,26,11,'2021-02-02 04:43:55.000','2021-02-02 06:14:55.000'),
(341,23,7,'2021-02-02 11:01:14.000','2021-02-02 11:33:14.000'),
(342,23,12,'2021-02-02 11:37:14.000','2021-02-02 12:33:14.000'),
(343,23,8,'2021-02-02 12:34:14.000','2021-02-02 12:40:14.000'),
(344,23,5,'2021-02-02 12:41:14.000','2021-02-02 13:55:14.000'),
(345,23,15,'2021-02-02 13:55:14.000','2021-02-02 14:30:14.000'),
(346,23,4,'2021-02-02 14:32:14.000','2021-02-02 15:47:14.000'),
(347,23,3,'2021-02-02 15:51:14.000','2021-02-02 16:25:14.000'),
(348,23,6,'2021-02-02 16:26:14.000','2021-02-02 17:53:14.000'),
(349,23,16,'2021-02-02 17:54:14.000','2021-02-02 19:11:14.000'),
(350,23,11,'2021-02-02 19:11:14.000','2021-02-02 20:04:14.000'),
(351,23,1,'2021-02-02 20:04:14.000','2021-02-02 20:27:14.000'),
(352,23,13,'2021-02-02 20:30:14.000','2021-02-02 20:40:14.000'),
(353,23,10,'2021-02-02 20:41:14.000','2021-02-02 22:09:14.000'),
(354,28,13,'2021-02-02 02:42:39.000','2021-02-02 03:59:39.000'),
(355,28,15,'2021-02-02 04:03:39.000','2021-02-02 04:33:39.000'),
(356,28,6,'2021-02-02 04:37:39.000','2021-02-02 04:46:39.000'),
(357,28,10,'2021-02-02 04:47:39.000','2021-02-02 06:03:39.000'),
(358,28,11,'2021-02-02 06:04:39.000','2021-02-02 07:37:39.000'),
(359,28,14,'2021-02-02 07:41:39.000','2021-02-02 08:34:39.000'),
(360,28,8,'2021-02-02 08:34:39.000','2021-02-02 09:55:39.000'),
(361,44,7,'2021-02-02 13:39:18.000','2021-02-02 14:57:18.000'),
(362,44,14,'2021-02-02 14:59:18.000','2021-02-02 15:36:18.000'),
(363,44,15,'2021-02-02 15:38:18.000','2021-02-02 16:33:18.000'),
(364,44,1,'2021-02-02 16:35:18.000','2021-02-02 17:54:18.000'),
(365,44,8,'2021-02-02 17:56:18.000','2021-02-02 18:52:18.000'),
(366,44,16,'2021-02-02 18:56:18.000','2021-02-02 20:20:18.000'),
(367,44,11,'2021-02-02 20:21:18.000','2021-02-02 22:04:18.000'),
(368,44,6,'2021-02-02 22:07:18.000','2021-02-02 22:59:18.000'),
(369,44,3,'2021-02-02 23:03:18.000','2021-02-02 23:08:18.000'),
(370,44,9,'2021-02-02 23:09:18.000','2021-02-03 00:53:18.000'),
(371,44,13,'2021-02-03 00:55:18.000','2021-02-03 01:57:18.000'),
(372,44,10,'2021-02-03 01:59:18.000','2021-02-03 03:32:18.000'),
(373,37,1,'2021-02-02 05:01:26.000','2021-02-02 05:02:26.000'),
(374,37,2,'2021-02-02 05:06:26.000','2021-02-02 07:04:26.000'),
(375,37,6,'2021-02-02 07:04:26.000','2021-02-02 07:48:26.000'),
(376,37,10,'2021-02-02 07:50:26.000','2021-02-02 09:28:26.000'),
(377,37,9,'2021-02-02 09:31:26.000','2021-02-02 10:51:26.000'),
(378,37,3,'2021-02-02 10:51:26.000','2021-02-02 11:53:26.000'),
(379,37,7,'2021-02-02 11:54:26.000','2021-02-02 12:42:26.000'),
(380,37,13,'2021-02-02 12:43:26.000','2021-02-02 13:54:26.000'),
(381,37,4,'2021-02-02 13:57:26.000','2021-02-02 15:54:26.000'),
(382,37,16,'2021-02-02 15:57:26.000','2021-02-02 16:11:26.000'),
(383,37,15,'2021-02-02 16:13:26.000','2021-02-02 18:08:26.000'),
(384,37,12,'2021-02-02 18:11:26.000','2021-02-02 18:33:26.000'),
(385,37,5,'2021-02-02 18:37:26.000','2021-02-02 20:22:26.000'),
(386,3,6,'2021-02-02 14:21:03.000','2021-02-02 14:46:03.000'),
(387,3,15,'2021-02-02 14:46:03.000','2021-02-02 16:09:03.000'),
(388,3,2,'2021-02-02 16:10:03.000','2021-02-02 16:45:03.000'),
(389,3,11,'2021-02-02 16:48:03.000','2021-02-02 17:47:03.000'),
(390,3,5,'2021-02-02 17:49:03.000','2021-02-02 18:09:03.000'),
(391,3,12,'2021-02-02 18:10:03.000','2021-02-02 19:55:03.000'),
(392,3,1,'2021-02-02 19:56:03.000','2021-02-02 21:13:03.000'),
(393,3,3,'2021-02-02 21:13:03.000','2021-02-02 23:11:03.000'),
(394,3,16,'2021-02-02 23:14:03.000','2021-02-03 00:45:03.000'),
(395,29,4,'2021-02-02 16:07:32.000','2021-02-02 17:14:32.000'),
(396,31,3,'2021-02-02 16:39:55.000','2021-02-02 18:24:55.000'),
(397,31,7,'2021-02-02 18:24:55.000','2021-02-02 20:14:55.000'),
(398,31,12,'2021-02-02 20:15:55.000','2021-02-02 21:10:55.000'),
(399,31,5,'2021-02-02 21:13:55.000','2021-02-02 22:27:55.000'),
(400,31,6,'2021-02-02 22:30:55.000','2021-02-02 23:31:55.000'),
(401,31,16,'2021-02-02 23:32:55.000','2021-02-03 00:30:55.000'),
(402,31,11,'2021-02-03 00:31:55.000','2021-02-03 00:33:55.000'),
(403,31,1,'2021-02-03 00:33:55.000','2021-02-03 00:38:55.000'),
(404,31,2,'2021-02-03 00:42:55.000','2021-02-03 02:24:55.000'),
(405,31,13,'2021-02-03 02:27:55.000','2021-02-03 03:11:55.000'),
(406,7,12,'2021-02-02 23:22:01.000','2021-02-02 23:45:01.000'),
(407,7,3,'2021-02-02 23:46:01.000','2021-02-03 01:39:01.000'),
(408,7,11,'2021-02-03 01:40:01.000','2021-02-03 02:27:01.000'),
(409,7,1,'2021-02-03 02:30:01.000','2021-02-03 03:10:01.000'),
(410,7,8,'2021-02-03 03:14:01.000','2021-02-03 04:27:01.000'),
(411,7,7,'2021-02-03 04:30:01.000','2021-02-03 04:55:01.000'),
(412,7,16,'2021-02-03 04:56:01.000','2021-02-03 05:46:01.000'),
(413,7,13,'2021-02-03 05:48:01.000','2021-02-03 07:03:01.000'),
(414,7,2,'2021-02-03 07:05:01.000','2021-02-03 07:39:01.000'),
(415,7,5,'2021-02-03 07:43:01.000','2021-02-03 08:11:01.000'),
(416,7,15,'2021-02-03 08:11:01.000','2021-02-03 08:31:01.000'),
(417,7,4,'2021-02-03 08:32:01.000','2021-02-03 09:51:01.000'),
(418,7,6,'2021-02-03 09:54:01.000','2021-02-03 10:19:01.000'),
(419,20,11,'2021-02-02 14:43:46.000','2021-02-02 16:07:46.000'),
(420,20,16,'2021-02-02 16:09:46.000','2021-02-02 16:11:46.000'),
(421,20,8,'2021-02-02 16:12:46.000','2021-02-02 16:54:46.000'),
(422,20,2,'2021-02-02 16:55:46.000','2021-02-02 17:54:46.000'),
(423,20,4,'2021-02-02 17:57:46.000','2021-02-02 19:20:46.000'),
(424,42,2,'2021-02-02 08:14:17.000','2021-02-02 09:19:17.000'),
(425,42,16,'2021-02-02 09:23:17.000','2021-02-02 11:12:17.000'),
(426,42,12,'2021-02-02 11:16:17.000','2021-02-02 12:44:17.000'),
(427,42,14,'2021-02-02 12:46:17.000','2021-02-02 14:18:17.000'),
(428,42,5,'2021-02-02 14:22:17.000','2021-02-02 16:12:17.000'),
(429,19,12,'2021-02-02 17:43:56.000','2021-02-02 19:09:56.000'),
(430,19,8,'2021-02-02 19:11:56.000','2021-02-02 20:14:56.000'),
(431,19,10,'2021-02-02 20:17:56.000','2021-02-02 21:51:56.000'),
(432,19,6,'2021-02-02 21:55:56.000','2021-02-02 23:26:56.000'),
(433,19,4,'2021-02-02 23:29:56.000','2021-02-03 01:06:56.000'),
(434,19,5,'2021-02-03 01:08:56.000','2021-02-03 03:00:56.000'),
(435,19,7,'2021-02-03 03:04:56.000','2021-02-03 04:36:56.000'),
(436,19,14,'2021-02-03 04:37:56.000','2021-02-03 05:27:56.000'),
(437,19,16,'2021-02-03 05:31:56.000','2021-02-03 07:24:56.000'),
(438,19,3,'2021-02-03 07:26:56.000','2021-02-03 08:20:56.000'),
(439,19,11,'2021-02-03 08:22:56.000','2021-02-03 09:56:56.000'),
(440,30,3,'2021-02-02 21:47:27.000','2021-02-02 23:44:27.000'),
(441,30,13,'2021-02-02 23:48:27.000','2021-02-03 00:31:27.000'),
(442,30,2,'2021-02-03 00:35:27.000','2021-02-03 00:57:27.000'),
(443,30,11,'2021-02-03 00:58:27.000','2021-02-03 02:25:27.000'),
(444,30,14,'2021-02-03 02:25:27.000','2021-02-03 04:20:27.000'),
(445,30,15,'2021-02-03 04:21:27.000','2021-02-03 05:26:27.000'),
(446,30,4,'2021-02-03 05:30:27.000','2021-02-03 06:29:27.000'),
(447,30,10,'2021-02-03 06:31:27.000','2021-02-03 07:35:27.000'),
(448,30,16,'2021-02-03 07:35:27.000','2021-02-03 08:47:27.000'),
(449,30,6,'2021-02-03 08:47:27.000','2021-02-03 10:20:27.000'),
(450,30,5,'2021-02-03 10:22:27.000','2021-02-03 11:47:27.000'),
(451,30,12,'2021-02-03 11:51:27.000','2021-02-03 13:20:27.000'),
(452,30,8,'2021-02-03 13:21:27.000','2021-02-03 13:57:27.000'),
(453,30,1,'2021-02-03 13:59:27.000','2021-02-03 14:49:27.000'),
(454,30,7,'2021-02-03 14:53:27.000','2021-02-03 15:18:27.000'),
(455,30,9,'2021-02-03 15:19:27.000','2021-02-03 16:02:27.000'),
(456,32,8,'2021-02-02 06:27:53.000','2021-02-02 08:06:53.000'),
(457,32,4,'2021-02-02 08:10:53.000','2021-02-02 10:10:53.000'),
(458,32,10,'2021-02-02 10:11:53.000','2021-02-02 11:05:53.000'),
(459,32,15,'2021-02-02 11:06:53.000','2021-02-02 11:31:53.000'),
(460,32,14,'2021-02-02 11:32:53.000','2021-02-02 13:09:53.000'),
(461,32,6,'2021-02-02 13:09:53.000','2021-02-02 14:35:53.000'),
(462,32,1,'2021-02-02 14:36:53.000','2021-02-02 14:58:53.000'),
(463,32,9,'2021-02-02 15:00:53.000','2021-02-02 15:14:53.000'),
(464,32,11,'2021-02-02 15:15:53.000','2021-02-02 16:35:53.000'),
(465,32,5,'2021-02-02 16:36:53.000','2021-02-02 17:29:53.000'),
(466,32,16,'2021-02-02 17:29:53.000','2021-02-02 19:16:53.000'),
(467,32,7,'2021-02-02 19:17:53.000','2021-02-02 21:17:53.000'),
(468,32,13,'2021-02-02 21:19:53.000','2021-02-02 22:58:53.000'),
(469,32,12,'2021-02-02 22:58:53.000','2021-02-03 00:28:53.000'),
(470,32,3,'2021-02-03 00:30:53.000','2021-02-03 01:37:53.000'),
(471,8,1,'2021-02-02 04:58:01.000','2021-02-02 05:16:01.000'),
(472,8,7,'2021-02-02 05:17:01.000','2021-02-02 07:08:01.000'),
(473,8,2,'2021-02-02 07:10:01.000','2021-02-02 08:28:01.000'),
(474,8,16,'2021-02-02 08:32:01.000','2021-02-02 08:46:01.000'),
(475,8,5,'2021-02-02 08:48:01.000','2021-02-02 09:43:01.000'),
(476,8,12,'2021-02-02 09:45:01.000','2021-02-02 10:10:01.000'),
(477,8,13,'2021-02-02 10:12:01.000','2021-02-02 10:13:01.000'),
(478,8,14,'2021-02-02 10:15:01.000','2021-02-02 10:39:01.000'),
(479,8,10,'2021-02-02 10:42:01.000','2021-02-02 12:01:01.000'),
(480,8,3,'2021-02-02 12:02:01.000','2021-02-02 12:41:01.000'),
(481,8,6,'2021-02-02 12:44:01.000','2021-02-02 13:24:01.000'),
(482,8,4,'2021-02-02 13:28:01.000','2021-02-02 14:25:01.000'),
(483,8,8,'2021-02-02 14:29:01.000','2021-02-02 16:03:01.000'),
(484,8,11,'2021-02-02 16:05:01.000','2021-02-02 18:05:01.000'),
(485,8,15,'2021-02-02 18:07:01.000','2021-02-02 18:29:01.000'),
(486,8,9,'2021-02-02 18:30:01.000','2021-02-02 19:07:01.000'),
(487,8,1,'2021-02-02 19:11:01.000','2021-02-02 20:51:01.000'),
(488,8,7,'2021-02-02 20:53:01.000','2021-02-02 21:56:01.000'),
(489,9,15,'2021-02-02 13:49:32.000','2021-02-02 14:32:32.000'),
(490,9,13,'2021-02-02 14:33:32.000','2021-02-02 14:36:32.000'),
(491,9,12,'2021-02-02 14:39:32.000','2021-02-02 16:39:32.000'),
(492,9,6,'2021-02-02 16:43:32.000','2021-02-02 17:35:32.000'),
(493,50,11,'2021-02-02 13:35:11.000','2021-02-02 14:37:11.000'),
(494,50,7,'2021-02-02 14:37:11.000','2021-02-02 15:20:11.000'),
(495,50,6,'2021-02-02 15:22:11.000','2021-02-02 15:49:11.000'),
(496,50,9,'2021-02-02 15:52:11.000','2021-02-02 16:41:11.000'),
(497,50,2,'2021-02-02 16:41:11.000','2021-02-02 17:30:11.000'),
(498,50,13,'2021-02-02 17:34:11.000','2021-02-02 18:53:11.000'),
(499,50,8,'2021-02-02 18:53:11.000','2021-02-02 20:22:11.000'),
(500,48,3, '2021-02-02 20:00:00.000','2021-02-02 21:00.000');

-- select * from close_contact;
-- close_contact;
insert into close_contact values(1,2,'2021-02-02 14:48:55.000',4,36),
(2,3,'2021-02-02 21:13:03.000',3,30),
(3,4,'2021-02-02 21:09:09.000',3,30),
(4,5,'2021-02-02 16:41:29.000',4,29),
(5,6,'2021-02-03 00:17:49.000',13,30),
(6,8,'2021-02-02 10:42:01.000',10,39),
(7,10,'2021-02-02 10:00:59.000',7,39),
(8,11,'2021-02-02 22:17:13.000',6,31),
(9,12,'2021-02-02 15:12:41.000',4,29),
(10,15,'2021-02-02 15:50:07.000',8,39),
(11,16,'2021-02-02 20:19:09.000',12,31),
(12,17,'2021-02-02 09:04:53.000',13,39),
(13,18,'2021-02-03 08:27:50.000',16,30),
(14,19,'2021-02-02 21:55:56.000',6,31),
(15,20,'2021-02-02 17:57:46.000',4,14),
(16,21,'2021-02-02 11:51:16.000',7,39),
(17,23,'2021-02-02 11:01:14.000',7,39),
(18,24,'2021-02-02 23:53:34.000',12,22),
(19,25,'2021-02-02 10:54:40.000',12,36),
(20,27,'2021-02-02 23:50:07.000',12,22),
(21,28,'2021-02-02 06:04:39.000',11,26),
(22,32,'2021-02-02 10:11:53.000',10,39),
(23,33,'2021-02-02 17:22:33.000',3,31),
(24,34,'2021-02-02 04:38:15.000',2,26),
(25,35,'2021-02-03 02:42:56.000',6,22),
(26,37,'2021-02-02 11:54:26.000',7,39),
(27,38,'2021-02-02 16:26:29.000',4,29),
(28,40,'2021-02-02 19:39:18.000',12,31),
(29,41,'2021-02-02 11:06:47.000',7,39),
(30,42,'2021-02-02 11:16:17.000',12,36),
(31,43,'2021-02-02 10:46:27.000',12,36),
(32,44,'2021-02-02 23:03:18.000',3,30),
(33,45,'2021-02-02 08:40:47.000',10,39),
(34,46,'2021-02-02 22:27:04.000',3,30),
(35,47,'2021-02-02 15:52:57.000',4,29),
(36,49,'2021-02-02 21:11:48.000',5,31),
(37,50,'2021-02-02 15:52:11.000',9,14),
(38,39,'2021-02-01 15:52:11.000',10,NULL),
(39,30,'2021-02-01 15:52:11.000',10,8),
(40,31,'2021-02-01 15:52:11.000',5,NULL);
-- select * from isolation_record
-- isolation_record
insert into isolation_record values(1,29,'2021-02-04 11:00:00.000','2021-02-18 11:00:00.000',4,1),
(2,39,'2021-02-04 11:00:00.000','2021-02-18 11:00:00.000',2,1),
(3,30,'2021-02-04 11:00:00.000','2021-02-18 11:00:00.000',5,1),
(4,22,'2021-02-04 11:00:00.000','2021-02-18 11:00:00.000',5,1),
(5,31,'2021-02-04 11:00:00.000','2021-02-18 11:00:00.000',4,1),
(6,14,'2021-02-04 11:00:00.000','2021-02-18 11:00:00.000',1,1),
(7,26,'2021-02-04 11:00:00.000','2021-02-18 11:00:00.000',3,1),
(8,36,'2021-02-04 11:00:00.000','2021-02-18 11:00:00.000',5,1),
(9,7,'2021-02-04 11:00:00.000','2021-02-18 11:00:00.000',3,1),
(10,2,'2021-02-04 11:00:00.000','2021-02-18 11:00:00.000',6,3);
/* **************************************************** */
 