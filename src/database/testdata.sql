SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE commission_distribution;
TRUNCATE commissions;
TRUNCATE customer_camp_periods;
TRUNCATE customers;
TRUNCATE user_promotion_history;
TRUNCATE promotion_applications;
TRUNCATE users;
TRUNCATE teams;
TRUNCATE camp_periods;
TRUNCATE camp_period_stats;
SET FOREIGN_KEY_CHECKS = 1;
SET SQL_SAFE_UPDATES = 0;

use kubeblocks;
select * from camp_periods;
DESC commissions;

INSERT INTO teams (id, team_name, leader_id, created_at, updated_at) VALUES
(1, '星辰探索队', NULL, NOW(), NOW()),
(2, '未来引航者', NULL, NOW(), NOW()),
(3, '极客先锋团', NULL, NOW(), NOW()),
(4, '梦想启航', NULL, NOW(), NOW()),
(5, '云端逐梦', NULL, NOW(), NOW()),
(6, '光速成长营', NULL, NOW(), NOW()),
(7, '创新火花', NULL, NOW(), NOW()),
(8, '蓝海智行', NULL, NOW(), NOW()),
(9, '极光之队', NULL, NOW(), NOW()),
(10, '星火联盟', NULL, NOW(), NOW()),
(11, '未来星辰', NULL, NOW(), NOW()),
(12, '云帆远航', NULL, NOW(), NOW()),
(13, '智汇营', NULL, NOW(), NOW()),
(14, '逐梦先锋', NULL, NOW(), NOW()),
(15, '光年团队', NULL, NOW(), NOW());


INSERT INTO camp_periods (id, start_date, end_date, description, created_at, updated_at) VALUES
(990, '2025-01-10', '2025-02-10', '2025年春季基础英语线上训练营', NOW(), NOW()),
(991, '2025-02-15', '2025-03-15', '2025年进阶口语线上训练营', NOW(), NOW()),
(992, '2025-03-20', '2025-04-20', '2025年商务英语线上训练营', NOW(), NOW()),
(993, '2025-04-25', '2025-05-25', '2025年青少年英语线上训练营', NOW(), NOW()),
(994, '2025-05-01', '2025-05-30', '2025年英语写作线上训练营', NOW(), NOW()),
(995, '2025-05-10', '2025-06-10', '2025年英语阅读线上训练营', NOW(), NOW()),
(996, '2025-05-15', '2025-06-15', '2025年英语听力线上训练营', NOW(), NOW()),
(997, '2025-05-20', '2025-06-20', '2025年雅思冲刺线上训练营', NOW(), NOW()),
(998, '2025-05-25', '2025-06-25', '2025年托福精英线上训练营', NOW(), NOW()),
(999, '2025-05-28', '2025-06-28', '2025年少儿英语线上训练营', NOW(), NOW()),
(1000, '2025-05-03', '2025-05-20', '2025年英语口语提升线上训练营', NOW(), NOW()),
(1001, '2025-06-03', '2025-07-03', '2025年英语综合能力线上训练营', NOW(), NOW()),
(1002, '2025-06-10', '2025-07-10', '2025年英语演讲线上训练营', NOW(), NOW()),
(1003, '2025-06-15', '2025-07-15', '2025年英语写作精进线上训练营', NOW(), NOW()),
(1004, '2025-06-20', '2025-07-20', '2025年英语词汇拓展线上训练营', NOW(), NOW()),
(1005, '2025-06-25', '2025-07-25', '2025年英语语法精讲线上训练营', NOW(), NOW());

-- 1. 星辰探索队
INSERT INTO users (id, username, password, email, phone, role, team_id, created_at, updated_at) VALUES
(1, '赵琳', '$2b$10$testhash1', 'zhaolin@example.com', '13800000001', 'leader', 1, NOW(), NOW()),
(2, '林若溪', '$2b$10$testhash2', 'linruoxi@example.com', '13800000002', 'ambassador', 1, NOW(), NOW()),
(3, '苏婉儿', '$2b$10$testhash3', 'suwaner@example.com', '13800000003', 'ambassador', 1, NOW(), NOW()),
(4, '顾子墨', '$2b$10$testhash4', 'guzimo@example.com', '13800000004', 'ambassador', 1, NOW(), NOW()),
(5, '叶思远', '$2b$10$testhash5', 'yesiyuan@example.com', '13800000005', 'ambassador', 1, NOW(), NOW());

-- 2. 未来引航者
INSERT INTO users VALUES
(6, '沈星辰', '$2b$10$testhash6', 'shenxingchen@example.com', '13800000006', 'leader', 2, NOW(), NOW()),
(7, '唐婉清', '$2b$10$testhash7', 'tangwanqing@example.com', '13800000007', 'ambassador', 2, NOW(), NOW()),
(8, '许墨', '$2b$10$testhash8', 'xumu@example.com', '13800000008', 'ambassador', 2, NOW(), NOW()),
(9, '江语晨', '$2b$10$testhash9', 'jiangyuchen@example.com', '13800000009', 'ambassador', 2, NOW(), NOW()),
(10, '林子然', '$2b$10$testhash10', 'linziran@example.com', '13800000010', 'ambassador', 2, NOW(), NOW());

-- 3. 极客先锋团
INSERT INTO users VALUES
(11, '韩子昂', '$2b$10$testhash11', 'hanzia@example.com', '13800000011', 'leader', 3, NOW(), NOW()),
(12, '宋雨桐', '$2b$10$testhash12', 'songyutong@example.com', '13800000012', 'ambassador', 3, NOW(), NOW()),
(13, '秦若雪', '$2b$10$testhash13', 'qinruoxue@example.com', '13800000013', 'ambassador', 3, NOW(), NOW()),
(14, '陆思源', '$2b$10$testhash14', 'lusiyaun@example.com', '13800000014', 'ambassador', 3, NOW(), NOW()),
(15, '白子瑜', '$2b$10$testhash15', 'baiziyu@example.com', '13800000015', 'ambassador', 3, NOW(), NOW()),
(16, '温梓萱', '$2b$10$testhash16', 'wenzixuan@example.com', '13800000016', 'ambassador', 3, NOW(), NOW());

-- 4. 梦想启航
INSERT INTO users VALUES
(17, '周子琪', '$2b$10$testhash17', 'zhouziqi@example.com', '13800000017', 'leader', 4, NOW(), NOW()),
(18, '李思涵', '$2b$10$testhash18', 'lisihaan@example.com', '13800000018', 'ambassador', 4, NOW(), NOW()),
(19, '陈嘉言', '$2b$10$testhash19', 'chenjiayan@example.com', '13800000019', 'ambassador', 4, NOW(), NOW()),
(20, '王梓萱', '$2b$10$testhash20', 'wangzixuan@example.com', '13800000020', 'ambassador', 4, NOW(), NOW());

-- 5. 云端逐梦
INSERT INTO users VALUES
(21, '徐子墨', '$2b$10$testhash21', 'xuzimo@example.com', '13800000021', 'leader', 5, NOW(), NOW()),
(22, '宋语嫣', '$2b$10$testhash22', 'songyuyan@example.com', '13800000022', 'ambassador', 5, NOW(), NOW()),
(23, '杜梓涵', '$2b$10$testhash23', 'duzihan@example.com', '13800000023', 'ambassador', 5, NOW(), NOW()),
(24, '高思远', '$2b$10$testhash24', 'gaosiyuan@example.com', '13800000024', 'ambassador', 5, NOW(), NOW()),
(25, '林嘉悦', '$2b$10$testhash25', 'linjiayue@example.com', '13800000025', 'ambassador', 5, NOW(), NOW());

-- 6. 光速成长营
INSERT INTO users VALUES
(26, '王子恒', '$2b$10$testhash26', 'wangziheng@example.com', '13800000026', 'leader', 6, NOW(), NOW()),
(27, '赵思琪', '$2b$10$testhash27', 'zhaosiqi@example.com', '13800000027', 'ambassador', 6, NOW(), NOW()),
(28, '钱梓萱', '$2b$10$testhash28', 'qianzixuan@example.com', '13800000028', 'ambassador', 6, NOW(), NOW()),
(29, '孙嘉怡', '$2b$10$testhash29', 'sunjiaji@example.com', '13800000029', 'ambassador', 6, NOW(), NOW()),
(30, '李思远', '$2b$10$testhash30', 'lisiyaun@example.com', '13800000030', 'ambassador', 6, NOW(), NOW()),
(31, '周梓涵', '$2b$10$testhash31', 'zhouzihan@example.com', '13800000031', 'ambassador', 6, NOW(), NOW());

-- 7. 创新火花
INSERT INTO users VALUES
(32, '陈思源', '$2b$10$testhash32', 'chensiyuan@example.com', '13800000032', 'leader', 7, NOW(), NOW()),
(33, '吴嘉悦', '$2b$10$testhash33', 'wujiaiyue@example.com', '13800000033', 'ambassador', 7, NOW(), NOW()),
(34, '郑梓萱', '$2b$10$testhash34', 'zhengzixuan@example.com', '13800000034', 'ambassador', 7, NOW(), NOW()),
(35, '冯思涵', '$2b$10$testhash35', 'fengsihan@example.com', '13800000035', 'ambassador', 7, NOW(), NOW()),
(36, '褚子墨', '$2b$10$testhash36', 'chuzimo@example.com', '13800000036', 'ambassador', 7, NOW(), NOW());

-- 8. 蓝海智行
INSERT INTO users VALUES
(37, '杨梓萱', '$2b$10$testhash37', 'yangzixuan@example.com', '13800000037', 'leader', 8, NOW(), NOW()),
(38, '朱思远', '$2b$10$testhash38', 'zhusiyuan@example.com', '13800000038', 'ambassador', 8, NOW(), NOW()),
(39, '秦嘉怡', '$2b$10$testhash39', 'qinjiaji@example.com', '13800000039', 'ambassador', 8, NOW(), NOW()),
(40, '尤思琪', '$2b$10$testhash40', 'yousiqi@example.com', '13800000040', 'ambassador', 8, NOW(), NOW()),
(41, '许子墨', '$2b$10$testhash41', 'xuzimo2@example.com', '13800000041', 'ambassador', 8, NOW(), NOW());

-- 9. 极光之队
INSERT INTO users VALUES
(42, '张嘉言', '$2b$10$testhash42', 'zhangjiayan@example.com', '13800000042', 'leader', 9, NOW(), NOW()),
(43, '魏思远', '$2b$10$testhash43', 'weisiyuan@example.com', '13800000043', 'ambassador', 9, NOW(), NOW()),
(44, '蒋梓萱', '$2b$10$testhash44', 'jiangzixuan@example.com', '13800000044', 'ambassador', 9, NOW(), NOW()),
(45, '沈嘉怡', '$2b$10$testhash45', 'shenjiayi@example.com', '13800000045', 'ambassador', 9, NOW(), NOW()),
(46, '邹思琪', '$2b$10$testhash46', 'zousiqi@example.com', '13800000046', 'ambassador', 9, NOW(), NOW());

-- 10. 星火联盟
INSERT INTO users VALUES
(47, '胡子墨', '$2b$10$testhash47', 'huzimo@example.com', '13800000047', 'leader', 10, NOW(), NOW()),
(48, '贾思远', '$2b$10$testhash48', 'jiasiyuan@example.com', '13800000048', 'ambassador', 10, NOW(), NOW()),
(49, '罗嘉怡', '$2b$10$testhash49', 'luojiaji@example.com', '13800000049', 'ambassador', 10, NOW(), NOW()),
(50, '毕梓萱', '$2b$10$testhash50', 'bizixuan@example.com', '13800000050', 'ambassador', 10, NOW(), NOW()),
(51, '龚思琪', '$2b$10$testhash51', 'gongsq@example.com', '13800000051', 'ambassador', 10, NOW(), NOW());

-- 11. 未来星辰
INSERT INTO users VALUES
(52, '石嘉言', '$2b$10$testhash52', 'shijiayan@example.com', '13800000052', 'leader', 11, NOW(), NOW()),
(53, '黎思远', '$2b$10$testhash53', 'lisiyaun2@example.com', '13800000053', 'ambassador', 11, NOW(), NOW()),
(54, '潘梓萱', '$2b$10$testhash54', 'panzixuan@example.com', '13800000054', 'ambassador', 11, NOW(), NOW()),
(55, '毛嘉怡', '$2b$10$testhash55', 'maojiaji@example.com', '13800000055', 'ambassador', 11, NOW(), NOW());

-- 12. 云帆远航
INSERT INTO users VALUES
(56, '邱子墨', '$2b$10$testhash56', 'qiuzimo@example.com', '13800000056', 'leader', 12, NOW(), NOW()),
(57, '侯思远', '$2b$10$testhash57', 'housiyuan@example.com', '13800000057', 'ambassador', 12, NOW(), NOW()),
(58, '江梓萱', '$2b$10$testhash58', 'jiangzixuan2@example.com', '13800000058', 'ambassador', 12, NOW(), NOW()),
(59, '汤嘉怡', '$2b$10$testhash59', 'tangjiayi@example.com', '13800000059', 'ambassador', 12, NOW(), NOW()),
(60, '邢思琪', '$2b$10$testhash60', 'xingsiqi@example.com', '13800000060', 'ambassador', 12, NOW(), NOW());

-- 13. 智汇营
INSERT INTO users VALUES
(61, '蓝子墨', '$2b$10$testhash61', 'lanzimo@example.com', '13800000061', 'leader', 13, NOW(), NOW()),
(62, '冉思远', '$2b$10$testhash62', 'ransiyuan@example.com', '13800000062', 'ambassador', 13, NOW(), NOW()),
(63, '谭梓萱', '$2b$10$testhash63', 'tanzixuan@example.com', '13800000063', 'ambassador', 13, NOW(), NOW()),
(64, '裴嘉怡', '$2b$10$testhash64', 'peijiayi@example.com', '13800000064', 'ambassador', 13, NOW(), NOW());

-- 14. 逐梦先锋
INSERT INTO users VALUES
(65, '钟嘉言', '$2b$10$testhash65', 'zhongjiayan@example.com', '13800000065', 'leader', 14, NOW(), NOW()),
(66, '赖思远', '$2b$10$testhash66', 'laisiyuan@example.com', '13800000066', 'ambassador', 14, NOW(), NOW()),
(67, '文梓萱', '$2b$10$testhash67', 'wenzixuan2@example.com', '13800000067', 'ambassador', 14, NOW(), NOW()),
(68, '贺嘉怡', '$2b$10$testhash68', 'hejiayi@example.com', '13800000068', 'ambassador', 14, NOW(), NOW()),
(69, '邓思琪', '$2b$10$testhash69', 'dengsiqi@example.com', '13800000069', 'ambassador', 14, NOW(), NOW());

-- 15. 光年团队
INSERT INTO users VALUES
(70, '裘子墨', '$2b$10$testhash70', 'qiuzimo2@example.com', '13800000070', 'leader', 15, NOW(), NOW()),
(71, '屈思远', '$2b$10$testhash71', 'qusiyuan@example.com', '13800000071', 'ambassador', 15, NOW(), NOW()),
(72, '鲍梓萱', '$2b$10$testhash72', 'baozixuan@example.com', '13800000072', 'ambassador', 15, NOW(), NOW()),
(73, '苗嘉怡', '$2b$10$testhash73', 'miaojiaji@example.com', '13800000073', 'ambassador', 15, NOW(), NOW()),
(74, '盛思琪', '$2b$10$testhash74', 'shengsiqi@example.com', '13800000074', 'ambassador', 15, NOW(), NOW());

UPDATE teams SET leader_id = 1 WHERE id = 1;
UPDATE teams SET leader_id = 6 WHERE id = 2;
UPDATE teams SET leader_id = 11 WHERE id = 3;
UPDATE teams SET leader_id = 17 WHERE id = 4;
UPDATE teams SET leader_id = 21 WHERE id = 5;
UPDATE teams SET leader_id = 26 WHERE id = 6;
UPDATE teams SET leader_id = 32 WHERE id = 7;
UPDATE teams SET leader_id = 37 WHERE id = 8;
UPDATE teams SET leader_id = 42 WHERE id = 9;
UPDATE teams SET leader_id = 47 WHERE id = 10;
UPDATE teams SET leader_id = 52 WHERE id = 11;
UPDATE teams SET leader_id = 56 WHERE id = 12;
UPDATE teams SET leader_id = 61 WHERE id = 13;
UPDATE teams SET leader_id = 65 WHERE id = 14;
UPDATE teams SET leader_id = 70 WHERE id = 15;



INSERT INTO users (id, username, password, email, phone, role, team_id, created_at, updated_at) VALUES
(75, '林若彤', '$2b$10$testhash75', 'linruotong@example.com', '13800000075', 'ambassador', NULL, NOW(), NOW()),
(76, '宋嘉宁', '$2b$10$testhash76', 'songjianing@example.com', '13800000076', 'ambassador', NULL, NOW(), NOW()),
(77, '杜思辰', '$2b$10$testhash77', 'dusichen@example.com', '13800000077', 'ambassador', NULL, NOW(), NOW()),
(78, '高梓琪', '$2b$10$testhash78', 'gaozq@example.com', '13800000078', 'ambassador', NULL, NOW(), NOW()),
(79, '叶嘉妍', '$2b$10$testhash79', 'yejiayan@example.com', '13800000079', 'ambassador', NULL, NOW(), NOW()),
(80, '温思源', '$2b$10$testhash80', 'wensiyuan@example.com', '13800000080', 'ambassador', NULL, NOW(), NOW()),
(81, '顾子涵', '$2b$10$testhash81', 'guzihan@example.com', '13800000081', 'ambassador', NULL, NOW(), NOW()),
(82, '许梓萌', '$2b$10$testhash82', 'xuzimeng@example.com', '13800000082', 'ambassador', NULL, NOW(), NOW()),
(83, '韩嘉乐', '$2b$10$testhash83', 'hanjiale@example.com', '13800000083', 'ambassador', NULL, NOW(), NOW()),
(84, '秦思妍', '$2b$10$testhash84', 'qinsiyan@example.com', '13800000084', 'ambassador', NULL, NOW(), NOW()),
(85, '罗梓涵', '$2b$10$testhash85', 'luozihan@example.com', '13800000085', 'ambassador', NULL, NOW(), NOW()),
(86, '毕嘉怡', '$2b$10$testhash86', 'bijiayi2@example.com', '13800000086', 'ambassador', NULL, NOW(), NOW());

INSERT INTO customers (id, name, phone, email, status, created_at, updated_at) VALUES
(1, '李明', '13900000001', 'liming@example.com', 'potential', NOW(), NOW()),
(2, '王芳', '13900000002', 'wangfang@example.com', 'converted', NOW(), NOW()),
(3, '张伟', '13900000003', 'zhangwei@example.com', 'potential', NOW(), NOW()),
(4, '刘洋', '13900000004', 'liuyang@example.com', 'converted', NOW(), NOW()),
(5, '陈静', '13900000005', 'chenjing@example.com', 'potential', NOW(), NOW()),
(6, '赵磊', '13900000006', 'zhaolei@example.com', 'converted', NOW(), NOW()),
(7, '孙悦', '13900000007', 'sunyue@example.com', 'potential', NOW(), NOW()),
(8, '周婷', '13900000008', 'zhouting@example.com', 'converted', NOW(), NOW()),
(9, '吴昊', '13900000009', 'wuhao@example.com', 'potential', NOW(), NOW()),
(10, '郑爽', '13900000010', 'zhengshuang@example.com', 'converted', NOW(), NOW()),
(11, '冯晨', '13900000011', 'fengchen@example.com', 'potential', NOW(), NOW()),
(12, '褚琳', '13900000012', 'chulin@example.com', 'converted', NOW(), NOW()),
(13, '卫东', '13900000013', 'weidong@example.com', 'potential', NOW(), NOW()),
(14, '蒋楠', '13900000014', 'jiangnan@example.com', 'converted', NOW(), NOW()),
(15, '沈冰', '13900000015', 'shenbing@example.com', 'potential', NOW(), NOW()),
(16, '韩雪', '13900000016', 'hanxue@example.com', 'converted', NOW(), NOW()),
(17, '杨帆', '13900000017', 'yangfan@example.com', 'potential', NOW(), NOW()),
(18, '朱琳', '13900000018', 'zhulin@example.com', 'converted', NOW(), NOW()),
(19, '秦川', '13900000019', 'qinchan@example.com', 'potential', NOW(), NOW()),
(20, '尤佳', '13900000020', 'youjia@example.com', 'converted', NOW(), NOW()),
(21, '许诺', '13900000021', 'xunuo@example.com', 'potential', NOW(), NOW()),
(22, '贾思远', '13900000022', 'jiasiyuan@example.com', 'converted', NOW(), NOW()),
(23, '罗嘉怡', '13900000023', 'luojiayi@example.com', 'potential', NOW(), NOW()),
(24, '毕梓萱', '13900000024', 'bizixuan@example.com', 'converted', NOW(), NOW()),
(25, '龚思琪', '13900000025', 'gongsq@example.com', 'potential', NOW(), NOW()),
(26, '石嘉言', '13900000026', 'shijiayan@example.com', 'converted', NOW(), NOW()),
(27, '黎思远', '13900000027', 'lisiyaun2@example.com', 'potential', NOW(), NOW()),
(28, '潘梓萱', '13900000028', 'panzixuan@example.com', 'converted', NOW(), NOW()),
(29, '毛嘉怡', '13900000029', 'maojiaji@example.com', 'potential', NOW(), NOW()),
(30, '邱子墨', '13900000030', 'qiuzimo@example.com', 'converted', NOW(), NOW()),
(31, '侯思远', '13900000031', 'housiyuan@example.com', 'potential', NOW(), NOW()),
(32, '江梓萱', '13900000032', 'jiangzixuan2@example.com', 'converted', NOW(), NOW()),
(33, '汤嘉怡', '13900000033', 'tangjiayi@example.com', 'potential', NOW(), NOW()),
(34, '邢思琪', '13900000034', 'xingsiqi@example.com', 'converted', NOW(), NOW()),
(35, '蓝子墨', '13900000035', 'lanzimo@example.com', 'potential', NOW(), NOW()),
(36, '冉思远', '13900000036', 'ransiyuan@example.com', 'converted', NOW(), NOW()),
(37, '谭梓萱', '13900000037', 'tanzixuan@example.com', 'potential', NOW(), NOW()),
(38, '裴嘉怡', '13900000038', 'peijiayi@example.com', 'converted', NOW(), NOW()),
(39, '钟嘉言', '13900000039', 'zhongjiayan@example.com', 'potential', NOW(), NOW()),
(40, '赖思远', '13900000040', 'laisiyuan@example.com', 'converted', NOW(), NOW()),
(41, '文梓萱', '13900000041', 'wenzixuan2@example.com', 'potential', NOW(), NOW()),
(42, '贺嘉怡', '13900000042', 'hejiayi@example.com', 'converted', NOW(), NOW()),
(43, '邓思琪', '13900000043', 'dengsiqi@example.com', 'potential', NOW(), NOW()),
(44, '裘子墨', '13900000044', 'qiuzimo2@example.com', 'converted', NOW(), NOW()),
(45, '屈思远', '13900000045', 'qusiyuan@example.com', 'potential', NOW(), NOW()),
(46, '鲍梓萱', '13900000046', 'baozixuan@example.com', 'converted', NOW(), NOW()),
(47, '苗嘉怡', '13900000047', 'miaojiaji@example.com', 'potential', NOW(), NOW()),
(48, '盛思琪', '13900000048', 'shengsiqi@example.com', 'converted', NOW(), NOW()),
(49, '林若彤', '13900000049', 'linruotong@example.com', 'potential', NOW(), NOW()),
(50, '宋嘉宁', '13900000050', 'songjianing@example.com', 'converted', NOW(), NOW()),
(51, '杜子涵', '13900000051', 'duzihan@example.com', 'potential', NOW(), NOW()),
(52, '高梓萌', '13900000052', 'gaozimeng@example.com', 'converted', NOW(), NOW()),
(53, '叶嘉乐', '13900000053', 'yejiale@example.com', 'potential', NOW(), NOW()),
(54, '温思妍', '13900000054', 'wensiyan@example.com', 'converted', NOW(), NOW()),
(55, '顾子彤', '13900000055', 'guzitong@example.com', 'potential', NOW(), NOW()),
(56, '许梓琪', '13900000056', 'xuzq@example.com', 'converted', NOW(), NOW()),
(57, '韩嘉妍', '13900000057', 'hanjiayan@example.com', 'potential', NOW(), NOW()),
(58, '秦思源', '13900000058', 'qinsiyuan@example.com', 'converted', NOW(), NOW()),
(59, '罗梓妍', '13900000059', 'luoziyan@example.com', 'potential', NOW(), NOW()),
(60, '毕嘉萌', '13900000060', 'bijiameng@example.com', 'converted', NOW(), NOW()),
(61, '林思琪', '13900000061', 'linsiqi@example.com', 'potential', NOW(), NOW()),
(62, '宋嘉萌', '13900000062', 'songjiameng@example.com', 'converted', NOW(), NOW()),
(63, '杜思妍', '13900000063', 'dusiyan@example.com', 'potential', NOW(), NOW()),
(64, '高梓乐', '13900000064', 'gaozile@example.com', 'converted', NOW(), NOW()),
(65, '叶嘉源', '13900000065', 'yejiayuan@example.com', 'potential', NOW(), NOW()),
(66, '温思萌', '13900000066', 'wensimeng@example.com', 'converted', NOW(), NOW()),
(67, '顾子乐', '13900000067', 'guzile@example.com', 'potential', NOW(), NOW()),
(68, '许梓妍', '13900000068', 'xuziyan@example.com', 'converted', NOW(), NOW()),
(69, '韩嘉源', '13900000069', 'hanjiayuan@example.com', 'potential', NOW(), NOW()),
(70, '秦思萌', '13900000070', 'qinsimeng@example.com', 'converted', NOW(), NOW()),
(71, '罗梓乐', '13900000071', 'luozile@example.com', 'potential', NOW(), NOW()),
(72, '毕嘉源', '13900000072', 'bijiayuan@example.com', 'converted', NOW(), NOW()),
(73, '林思妍', '13900000073', 'linsiyan@example.com', 'potential', NOW(), NOW()),
(74, '宋嘉源', '13900000074', 'songjiayuan@example.com', 'converted', NOW(), NOW()),
(75, '杜思乐', '13900000075', 'dusile@example.com', 'potential', NOW(), NOW()),
(76, '高梓源', '13900000076', 'gaoziyuan@example.com', 'converted', NOW(), NOW()),
(77, '叶嘉妍', '13900000077', 'yejiayan2@example.com', 'potential', NOW(), NOW()),
(78, '温思源', '13900000078', 'wensiyuan2@example.com', 'converted', NOW(), NOW()),
(79, '顾子妍', '13900000079', 'guziyan@example.com', 'potential', NOW(), NOW()),
(80, '许梓乐', '13900000080', 'xuzile@example.com', 'converted', NOW(), NOW()),
(81, '韩嘉萌', '13900000081', 'hanjiameng@example.com', 'potential', NOW(), NOW()),
(82, '秦思妍', '13900000082', 'qinsiyan2@example.com', 'converted', NOW(), NOW()),
(83, '罗梓源', '13900000083', 'luoziyuan@example.com', 'potential', NOW(), NOW()),
(84, '毕嘉妍', '13900000084', 'bijiayan@example.com', 'converted', NOW(), NOW()),
(85, '林思萌', '13900000085', 'linsimeng@example.com', 'potential', NOW(), NOW()),
(86, '宋嘉妍', '13900000086', 'songjiayan@example.com', 'converted', NOW(), NOW()),
(87, '杜思源', '13900000087', 'dusiyuan@example.com', 'potential', NOW(), NOW()),
(88, '高梓妍', '13900000088', 'gaozhiyan@example.com', 'converted', NOW(), NOW()),
(89, '叶嘉萌', '13900000089', 'yejiameng@example.com', 'potential', NOW(), NOW()),
(90, '温思乐', '13900000090', 'wensile@example.com', 'converted', NOW(), NOW()),
(91, '顾子源', '13900000091', 'guziyuan@example.com', 'potential', NOW(), NOW()),
(92, '许梓萌', '13900000092', 'xuzimeng2@example.com', 'converted', NOW(), NOW()),
(93, '韩嘉乐', '13900000093', 'hanjiale2@example.com', 'potential', NOW(), NOW()),
(94, '秦思乐', '13900000094', 'qinsile@example.com', 'converted', NOW(), NOW()),
(95, '罗梓萌', '13900000095', 'luozimeng@example.com', 'potential', NOW(), NOW()),
(96, '毕嘉乐', '13900000096', 'bijiale@example.com', 'converted', NOW(), NOW()),
(97, '林思源', '13900000097', 'linsiyuan2@example.com', 'potential', NOW(), NOW()),
(98, '宋嘉乐', '13900000098', 'songjiale@example.com', 'converted', NOW(), NOW()),
(99, '杜思萌', '13900000099', 'dusimeng@example.com', 'potential', NOW(), NOW()),
(100, '高梓乐', '13900000100', 'gaozile2@example.com', 'converted', NOW(), NOW()),
(101, '欧阳晨曦', '13900000101', 'ouyangchenxi@example.com', 'potential', NOW(), NOW()),
(102, '司徒若彤', '13900000102', 'situruotong@example.com', 'converted', NOW(), NOW()),
(103, '东方梓涵', '13900000103', 'dongfangzihan@example.com', 'potential', NOW(), NOW()),
(104, '上官嘉乐', '13900000104', 'shangguanjiale@example.com', 'converted', NOW(), NOW()),
(105, '夏侯思妍', '13900000105', 'xiahousiyan@example.com', 'potential', NOW(), NOW()),
(106, '诸葛梓萌', '13900000106', 'zhugezimeng@example.com', 'converted', NOW(), NOW()),
(107, '尉迟嘉妍', '13900000107', 'weichijiayan@example.com', 'potential', NOW(), NOW()),
(108, '公孙思源', '13900000108', 'gongsunsiyuan@example.com', 'converted', NOW(), NOW()),
(109, '慕容梓乐', '13900000109', 'murongzile@example.com', 'potential', NOW(), NOW()),
(110, '令狐嘉源', '13900000110', 'linghujiayuan@example.com', 'converted', NOW(), NOW()),
(111, '宇文思琪', '13900000111', 'yuwensiqi@example.com', 'potential', NOW(), NOW()),
(112, '长孙嘉萌', '13900000112', 'zhangsunjiameng@example.com', 'converted', NOW(), NOW()),
(113, '司空思妍', '13900000113', 'sikongsiyan@example.com', 'potential', NOW(), NOW()),
(114, '西门梓源', '13900000114', 'ximenziyuan@example.com', 'converted', NOW(), NOW()),
(115, '南宫嘉乐', '13900000115', 'nangongjiale@example.com', 'potential', NOW(), NOW()),
(116, '百里思萌', '13900000116', 'bailisimeng@example.com', 'converted', NOW(), NOW()),
(117, '端木梓妍', '13900000117', 'duanmuzhiyan@example.com', 'potential', NOW(), NOW()),
(118, '呼延嘉源', '13900000118', 'huyuanjiayuan@example.com', 'converted', NOW(), NOW()),
(119, '轩辕思乐', '13900000119', 'xuanyuansile@example.com', 'potential', NOW(), NOW()),
(120, '令狐梓涵', '13900000120', 'linghuzihan@example.com', 'converted', NOW(), NOW()),
(121, '东方嘉妍', '13900000121', 'dongfangjiayan@example.com', 'potential', NOW(), NOW()),
(122, '欧阳思源', '13900000122', 'ouyangsiyuan@example.com', 'converted', NOW(), NOW()),
(123, '司徒梓乐', '13900000123', 'situzile@example.com', 'potential', NOW(), NOW()),
(124, '上官嘉萌', '13900000124', 'shangguanjiameng@example.com', 'converted', NOW(), NOW()),
(125, '夏侯思妍', '13900000125', 'xiahousiyan2@example.com', 'potential', NOW(), NOW()),
(126, '诸葛梓源', '13900000126', 'zhugeziyuan@example.com', 'converted', NOW(), NOW()),
(127, '尉迟嘉乐', '13900000127', 'weichijiale@example.com', 'potential', NOW(), NOW()),
(128, '公孙思萌', '13900000128', 'gongsunsimeng@example.com', 'converted', NOW(), NOW()),
(129, '慕容梓妍', '13900000129', 'murongziyan@example.com', 'potential', NOW(), NOW()),
(130, '令狐嘉源', '13900000130', 'linghujiayuan2@example.com', 'converted', NOW(), NOW()),
(131, '宇文思乐', '13900000131', 'yuwensile@example.com', 'potential', NOW(), NOW()),
(132, '长孙梓涵', '13900000132', 'zhangsunzihan@example.com', 'converted', NOW(), NOW()),
(133, '司空嘉妍', '13900000133', 'sikongjiayan@example.com', 'potential', NOW(), NOW()),
(134, '西门思源', '13900000134', 'ximensiyuan@example.com', 'converted', NOW(), NOW()),
(135, '南宫梓乐', '13900000135', 'nangongzile@example.com', 'potential', NOW(), NOW()),
(136, '百里嘉萌', '13900000136', 'bailijiameng@example.com', 'converted', NOW(), NOW()),
(137, '端木思妍', '13900000137', 'duanmusiyan@example.com', 'potential', NOW(), NOW()),
(138, '呼延梓源', '13900000138', 'huyuanziyuan@example.com', 'converted', NOW(), NOW()),
(139, '轩辕嘉乐', '13900000139', 'xuanyuanjiale@example.com', 'potential', NOW(), NOW()),
(140, '令狐思萌', '13900000140', 'linghusimeng@example.com', 'converted', NOW(), NOW()),
(141, '东方梓妍', '13900000141', 'dongfangziyan@example.com', 'potential', NOW(), NOW()),
(142, '欧阳嘉源', '13900000142', 'ouyangjiayuan@example.com', 'converted', NOW(), NOW()),
(143, '司徒思乐', '13900000143', 'situsile@example.com', 'potential', NOW(), NOW()),
(144, '上官梓涵', '13900000144', 'shangguanzihan@example.com', 'converted', NOW(), NOW()),
(145, '夏侯嘉妍', '13900000145', 'xiahoujiayan@example.com', 'potential', NOW(), NOW()),
(146, '诸葛思源', '13900000146', 'zhugeziyuan2@example.com', 'converted', NOW(), NOW()),
(147, '尉迟梓乐', '13900000147', 'weichizile@example.com', 'potential', NOW(), NOW()),
(148, '公孙嘉萌', '13900000148', 'gongsunjiameng@example.com', 'converted', NOW(), NOW()),
(149, '慕容思妍', '13900000149', 'murongsiyan@example.com', 'potential', NOW(), NOW()),
(150, '令狐梓源', '13900000150', 'linghuziyuan@example.com', 'converted', NOW(), NOW()),
(151, '宇文嘉乐', '13900000151', 'yuwenjiale@example.com', 'potential', NOW(), NOW()),
(152, '长孙思萌', '13900000152', 'zhangsunximeng@example.com', 'converted', NOW(), NOW()),
(153, '司空梓妍', '13900000153', 'sikongziyan@example.com', 'potential', NOW(), NOW()),
(154, '西门嘉源', '13900000154', 'ximenjiayuan@example.com', 'converted', NOW(), NOW()),
(155, '南宫思乐', '13900000155', 'nangongsile@example.com', 'potential', NOW(), NOW()),
(156, '百里梓涵', '13900000156', 'bailizihan@example.com', 'converted', NOW(), NOW()),
(157, '端木嘉妍', '13900000157', 'duanmujia2@example.com', 'potential', NOW(), NOW()),
(158, '呼延思源', '13900000158', 'huyuansiyuan@example.com', 'converted', NOW(), NOW()),
(159, '轩辕梓乐', '13900000159', 'xuanyuanzile@example.com', 'potential', NOW(), NOW()),
(160, '令狐嘉萌', '13900000160', 'linghujiameng@example.com', 'converted', NOW(), NOW()),
(161, '东方思妍', '13900000161', 'dongfangsiyan@example.com', 'potential', NOW(), NOW()),
(162, '欧阳梓源', '13900000162', 'ouyangziyuan@example.com', 'converted', NOW(), NOW()),
(163, '司徒嘉乐', '13900000163', 'situjiale@example.com', 'potential', NOW(), NOW()),
(164, '上官思萌', '13900000164', 'shangguansimeng@example.com', 'converted', NOW(), NOW()),
(165, '夏侯梓妍', '13900000165', 'xiahouziyan@example.com', 'potential', NOW(), NOW()),
(166, '诸葛嘉源', '13900000166', 'zhugejiayuan@example.com', 'converted', NOW(), NOW()),
(167, '尉迟思乐', '13900000167', 'weichisile@example.com', 'potential', NOW(), NOW()),
(168, '公孙梓涵', '13900000168', 'gongsunzihan@example.com', 'converted', NOW(), NOW()),
(169, '慕容嘉妍', '13900000169', 'murongjiayan@example.com', 'potential', NOW(), NOW()),
(170, '令狐思源', '13900000170', 'linghusiyuan@example.com', 'converted', NOW(), NOW()),
(171, '宇文梓乐', '13900000171', 'yuwenzile@example.com', 'potential', NOW(), NOW()),
(172, '长孙嘉萌', '13900000172', 'zhangsunjiameng2@example.com', 'converted', NOW(), NOW()),
(173, '司空思妍', '13900000173', 'sikongsiyan2@example.com', 'potential', NOW(), NOW()),
(174, '西门梓源', '13900000174', 'ximenziyuan@example.com', 'converted', NOW(), NOW()),
(175, '南宫嘉乐', '13900000175', 'nangongjiale2@example.com', 'potential', NOW(), NOW()),
(176, '百里思萌', '13900000176', 'bailisimeng2@example.com', 'converted', NOW(), NOW()),
(177, '端木梓妍', '13900000177', 'duanmuzhiyan2@example.com', 'potential', NOW(), NOW()),
(178, '呼延嘉源', '13900000178', 'huyuanjiayuan2@example.com', 'converted', NOW(), NOW()),
(179, '轩辕思乐', '13900000179', 'xuanyuansile2@example.com', 'potential', NOW(), NOW()),
(180, '令狐梓涵', '13900000180', 'linghuzihan2@example.com', 'converted', NOW(), NOW()),
(181, '东方嘉妍', '13900000181', 'dongfangjiayan2@example.com', 'potential', NOW(), NOW()),
(182, '欧阳思源', '13900000182', 'ouyangsiyuan2@example.com', 'converted', NOW(), NOW()),
(183, '司徒梓乐', '13900000183', 'situzile2@example.com', 'potential', NOW(), NOW()),
(184, '上官嘉萌', '13900000184', 'shangguanjiameng2@example.com', 'converted', NOW(), NOW()),
(185, '夏侯思妍', '13900000185', 'xiahoujian2@example.com', 'potential', NOW(), NOW()),
(186, '诸葛梓源', '13900000186', 'zhugeziyuan3@example.com', 'converted', NOW(), NOW()),
(187, '尉迟嘉乐', '13900000187', 'weichijiale2@example.com', 'potential', NOW(), NOW()),
(188, '公孙思萌', '13900000188', 'gongsunsimeng2@example.com', 'converted', NOW(), NOW()),
(189, '慕容梓妍', '13900000189', 'murongziyan2@example.com', 'potential', NOW(), NOW()),
(190, '令狐嘉源', '13900000190', 'linghujiayuan3@example.com', 'converted', NOW(), NOW()),
(191, '宇文思乐', '13900000191', 'yuwensile2@example.com', 'potential', NOW(), NOW()),
(192, '长孙梓涵', '13900000192', 'zhangsunzihan2@example.com', 'converted', NOW(), NOW()),
(193, '司空嘉妍', '13900000193', 'sikongjiayan2@example.com', 'potential', NOW(), NOW()),
(194, '西门思源', '13900000194', 'ximensiyuan2@example.com', 'converted', NOW(), NOW()),
(195, '南宫梓乐', '13900000195', 'nangongzile2@example.com', 'potential', NOW(), NOW()),
(196, '百里嘉萌', '13900000196', 'bailijiameng2@example.com', 'converted', NOW(), NOW()),
(197, '端木思妍', '13900000197', 'duanmusiyan2@example.com', 'potential', NOW(), NOW()),
(198, '呼延梓源', '13900000198', 'huyuanziyuan2@example.com', 'converted', NOW(), NOW()),
(199, '轩辕嘉乐', '13900000199', 'xuanyuanjiale2@example.com', 'potential', NOW(), NOW()),
(200, '令狐思萌', '13900000200', 'linghusimeng2@example.com', 'converted', NOW(), NOW()),
(201, '章梓琪', '13900000201', 'zhangziqi@example.com', 'potential', NOW(), NOW()),
(202, '殷嘉怡', '13900000202', 'yinjiaji@example.com', 'converted', NOW(), NOW()),
(203, '蓝思远', '13900000203', 'lansiyuan@example.com', 'potential', NOW(), NOW()),
(204, '苗梓萱', '13900000204', 'miaozixuan@example.com', 'converted', NOW(), NOW()),
(205, '盛嘉言', '13900000205', 'shengjiayan@example.com', 'potential', NOW(), NOW()),
(206, '鲍思琪', '13900000206', 'baosiqi@example.com', 'converted', NOW(), NOW()),
(207, '屈嘉乐', '13900000207', 'qujiale@example.com', 'potential', NOW(), NOW()),
(208, '裘思妍', '13900000208', 'qiusiyan@example.com', 'converted', NOW(), NOW()),
(209, '贺梓源', '13900000209', 'heziyuan@example.com', 'potential', NOW(), NOW()),
(210, '邓嘉萌', '13900000210', 'dengjiameng@example.com', 'converted', NOW(), NOW()),
(211, '赖思妍', '13900000211', 'laisiyan@example.com', 'potential', NOW(), NOW()),
(212, '钟梓涵', '13900000212', 'zhongzihan@example.com', 'converted', NOW(), NOW()),
(213, '文嘉妍', '13900000213', 'wenjiayan@example.com', 'potential', NOW(), NOW()),
(214, '贾思萌', '13900000214', 'jiasimeng@example.com', 'converted', NOW(), NOW()),
(215, '罗嘉源', '13900000215', 'luojiayuan@example.com', 'potential', NOW(), NOW()),
(216, '毕思乐', '13900000216', 'bisile@example.com', 'converted', NOW(), NOW()),
(217, '龚梓妍', '13900000217', 'gongziyan@example.com', 'potential', NOW(), NOW()),
(218, '石嘉萌', '13900000218', 'shijiameng@example.com', 'converted', NOW(), NOW()),
(219, '黎思琪', '13900000219', 'lisiqi@example.com', 'potential', NOW(), NOW()),
(220, '潘嘉妍', '13900000220', 'panjiayan@example.com', 'converted', NOW(), NOW()),
(221, '毛思源', '13900000221', 'maosiyuan@example.com', 'potential', NOW(), NOW()),
(222, '邱梓乐', '13900000222', 'qiuzile@example.com', 'converted', NOW(), NOW()),
(223, '侯嘉妍', '13900000223', 'houjiayan@example.com', 'potential', NOW(), NOW()),
(224, '江思萌', '13900000224', 'jiangsimeng@example.com', 'converted', NOW(), NOW()),
(225, '汤梓琪', '13900000225', 'tangziqi@example.com', 'potential', NOW(), NOW()),
(226, '邢嘉乐', '13900000226', 'xingjiale@example.com', 'converted', NOW(), NOW()),
(227, '蓝思妍', '13900000227', 'lansiyan@example.com', 'potential', NOW(), NOW()),
(228, '冉梓涵', '13900000228', 'ranzihan@example.com', 'converted', NOW(), NOW()),
(229, '谭嘉萌', '13900000229', 'tanjiameng@example.com', 'potential', NOW(), NOW()),
(230, '裴思乐', '13900000230', 'peisile@example.com', 'converted', NOW(), NOW()),
(231, '钟嘉源', '13900000231', 'zhongjiayuan@example.com', 'potential', NOW(), NOW()),
(232, '赖梓妍', '13900000232', 'laiziyan@example.com', 'converted', NOW(), NOW()),
(233, '文思琪', '13900000233', 'wensiqi2@example.com', 'potential', NOW(), NOW()),
(234, '贺嘉妍', '13900000234', 'hejiayan2@example.com', 'converted', NOW(), NOW()),
(235, '邓思萌', '13900000235', 'dengsimeng@example.com', 'potential', NOW(), NOW()),
(236, '裘梓涵', '13900000236', 'qiuzihan@example.com', 'converted', NOW(), NOW()),
(237, '屈嘉萌', '13900000237', 'qujiameng@example.com', 'potential', NOW(), NOW()),
(238, '鲍思乐', '13900000238', 'baosile@example.com', 'converted', NOW(), NOW()),
(239, '盛梓妍', '13900000239', 'shengziyan@example.com', 'potential', NOW(), NOW()),
(240, '苗嘉乐', '13900000240', 'miaojiale@example.com', 'converted', NOW(), NOW()),
(241, '殷思妍', '13900000241', 'yinsiyan@example.com', 'potential', NOW(), NOW()),
(242, '章梓乐', '13900000242', 'zhangzile@example.com', 'converted', NOW(), NOW()),
(243, '蓝嘉妍', '13900000243', 'lanjiayan@example.com', 'potential', NOW(), NOW()),
(244, '苗思琪', '13900000244', 'miaosiqi@example.com', 'converted', NOW(), NOW()),
(245, '盛嘉萌', '13900000245', 'shengjiameng@example.com', 'potential', NOW(), NOW()),
(246, '鲍梓琪', '13900000246', 'baoziqi@example.com', 'converted', NOW(), NOW()),
(247, '屈思乐', '13900000247', 'qusile@example.com', 'potential', NOW(), NOW()),
(248, '裘嘉妍', '13900000248', 'qiujiayan@example.com', 'converted', NOW(), NOW()),
(249, '贺思源', '13900000249', 'hesiyuan@example.com', 'potential', NOW(), NOW()),
(250, '邓梓乐', '13900000250', 'dengzile@example.com', 'converted', NOW(), NOW()),
(251, '赖嘉萌', '13900000251', 'laijiameng@example.com', 'potential', NOW(), NOW()),
(252, '钟思妍', '13900000252', 'zhongsiyan@example.com', 'converted', NOW(), NOW()),
(253, '文梓琪', '13900000253', 'wenziqi@example.com', 'potential', NOW(), NOW()),
(254, '贾嘉乐', '13900000254', 'jiajiale@example.com', 'converted', NOW(), NOW()),
(255, '罗思妍', '13900000255', 'luosiyan@example.com', 'potential', NOW(), NOW()),
(256, '毕梓涵', '13900000256', 'bizihan@example.com', 'converted', NOW(), NOW()),
(257, '龚嘉萌', '13900000257', 'gongjiameng@example.com', 'potential', NOW(), NOW()),
(258, '石思乐', '13900000258', 'shisile@example.com', 'converted', NOW(), NOW()),
(259, '黎梓妍', '13900000259', 'liziyan@example.com', 'potential', NOW(), NOW()),
(260, '潘嘉乐', '13900000260', 'panjiale@example.com', 'converted', NOW(), NOW()),
(261, '毛思妍', '13900000261', 'maosiyan@example.com', 'potential', NOW(), NOW()),
(262, '邱梓琪', '13900000262', 'qiuziqi@example.com', 'converted', NOW(), NOW()),
(263, '侯嘉萌', '13900000263', 'houjiameng@example.com', 'potential', NOW(), NOW()),
(264, '江思乐', '13900000264', 'jiangsile@example.com', 'converted', NOW(), NOW()),
(265, '汤梓妍', '13900000265', 'tangziyan@example.com', 'potential', NOW(), NOW()),
(266, '邢嘉萌', '13900000266', 'xingjiameng@example.com', 'converted', NOW(), NOW()),
(267, '蓝思乐', '13900000267', 'lansile@example.com', 'potential', NOW(), NOW()),
(268, '冉梓琪', '13900000268', 'ranziki@example.com', 'converted', NOW(), NOW()),
(269, '谭嘉妍', '13900000269', 'tanjiayan@example.com', 'potential', NOW(), NOW()),
(270, '裴思萌', '13900000270', 'peisimeng@example.com', 'converted', NOW(), NOW()),
(271, '钟嘉萌', '13900000271', 'zhongjiameng@example.com', 'potential', NOW(), NOW()),
(272, '赖思乐', '13900000272', 'laisile@example.com', 'converted', NOW(), NOW()),
(273, '文梓妍', '13900000273', 'wenzhiyan@example.com', 'potential', NOW(), NOW()),
(274, '贺嘉乐', '13900000274', 'hejiale@example.com', 'converted', NOW(), NOW()),
(275, '邓思妍', '13900000275', 'dengsiyan@example.com', 'potential', NOW(), NOW()),
(276, '裘梓乐', '13900000276', 'qiuzile2@example.com', 'converted', NOW(), NOW()),
(277, '屈嘉妍', '13900000277', 'qujiayan2@example.com', 'potential', NOW(), NOW()),
(278, '鲍思琪', '13900000278', 'baosiqi2@example.com', 'converted', NOW(), NOW()),
(279, '盛嘉乐', '13900000279', 'shengjiale@example.com', 'potential', NOW(), NOW()),
(280, '苗思妍', '13900000280', 'miaosiyan@example.com', 'converted', NOW(), NOW()),
(281, '殷梓琪', '13900000281', 'yinziki@example.com', 'potential', NOW(), NOW()),
(282, '章嘉妍', '13900000282', 'zhangjiayan2@example.com', 'converted', NOW(), NOW()),
(283, '蓝梓乐', '13900000283', 'lanzile@example.com', 'potential', NOW(), NOW()),
(284, '苗嘉萌', '13900000284', 'miaojiameng@example.com', 'converted', NOW(), NOW()),
(285, '盛思乐', '13900000285', 'shengsile@example.com', 'potential', NOW(), NOW()),
(286, '鲍梓妍', '13900000286', 'baozhiyan@example.com', 'converted', NOW(), NOW()),
(287, '屈思琪', '13900000287', 'qusiqi@example.com', 'potential', NOW(), NOW()),
(288, '裘嘉萌', '13900000288', 'qiujiameng@example.com', 'converted', NOW(), NOW()),
(289, '贺思妍', '13900000289', 'hesiyan@example.com', 'potential', NOW(), NOW()),
(290, '邓梓琪', '13900000290', 'dengziqi@example.com', 'converted', NOW(), NOW()),
(291, '赖嘉妍', '13900000291', 'laijiayan@example.com', 'potential', NOW(), NOW()),
(292, '钟思萌', '13900000292', 'zhongsimeng@example.com', 'converted', NOW(), NOW()),
(293, '文嘉乐', '13900000293', 'wenjiale@example.com', 'potential', NOW(), NOW()),
(294, '贾梓妍', '13900000294', 'jiaziyan@example.com', 'converted', NOW(), NOW()),
(295, '罗思琪', '13900000295', 'luosiqi@example.com', 'potential', NOW(), NOW()),
(296, '毕嘉妍', '13900000296', 'bijiayan2@example.com', 'converted', NOW(), NOW()),
(297, '龚思乐', '13900000297', 'gongsile@example.com', 'potential', NOW(), NOW()),
(298, '石梓琪', '13900000298', 'shiziki@example.com', 'converted', NOW(), NOW()),
(299, '黎嘉乐', '13900000299', 'lijiale@example.com', 'potential', NOW(), NOW()),
(300, '潘思妍', '13900000300', 'pansiyan@example.com', 'converted', NOW(), NOW()),
(301, '李小二', '13900000301', 'lixiaoer@example.com', 'potential', NOW(), NOW()),
(302, '王大锤', '13900000302', 'wangdachui@example.com', 'converted', NOW(), NOW()),
(303, '张三丰', '13900000303', 'zhangsanfeng@example.com', 'potential', NOW(), NOW()),
(304, '刘铁柱', '13900000304', 'liutiezhu@example.com', 'converted', NOW(), NOW()),
(305, '陈皮蛋', '13900000305', 'chenpidan@example.com', 'potential', NOW(), NOW()),
(306, '赵小刚', '13900000306', 'zhaoxiaogang@example.com', 'converted', NOW(), NOW()),
(307, '孙大力', '13900000307', 'sundali@example.com', 'potential', NOW(), NOW()),
(308, '周小明', '13900000308', 'zhouxiaoming@example.com', 'converted', NOW(), NOW()),
(309, '吴小花', '13900000309', 'wuxiaohua@example.com', 'potential', NOW(), NOW()),
(310, '郑大牛', '13900000310', 'zhengdaniu@example.com', 'converted', NOW(), NOW()),
(311, '冯小刚', '13900000311', 'fengxiaogang@example.com', 'potential', NOW(), NOW()),
(312, '褚大伟', '13900000312', 'chudawei@example.com', 'converted', NOW(), NOW()),
(313, '卫小东', '13900000313', 'weixiaodong@example.com', 'potential', NOW(), NOW()),
(314, '蒋大鹏', '13900000314', 'jiangdapeng@example.com', 'converted', NOW(), NOW()),
(315, '沈小翠', '13900000315', 'shenxiaocui@example.com', 'potential', NOW(), NOW()),
(316, '韩大志', '13900000316', 'handazhi@example.com', 'converted', NOW(), NOW()),
(317, '杨小军', '13900000317', 'yangxiaojun@example.com', 'potential', NOW(), NOW()),
(318, '朱大明', '13900000318', 'zhudaming@example.com', 'converted', NOW(), NOW()),
(319, '秦小刚', '13900000319', 'qinxiaogang@example.com', 'potential', NOW(), NOW()),
(320, '尤大伟', '13900000320', 'youdawei@example.com', 'converted', NOW(), NOW()),
(321, '许小红', '13900000321', 'xuxiaohong@example.com', 'potential', NOW(), NOW()),
(322, '贾大林', '13900000322', 'jiadalin@example.com', 'converted', NOW(), NOW()),
(323, '罗小明', '13900000323', 'luoxiaoming@example.com', 'potential', NOW(), NOW()),
(324, '毕大成', '13900000324', 'bidacheng@example.com', 'converted', NOW(), NOW()),
(325, '龚小刚', '13900000325', 'gongxiaogang@example.com', 'potential', NOW(), NOW()),
(326, '石大力', '13900000326', 'shidali@example.com', 'converted', NOW(), NOW()),
(327, '黎小明', '13900000327', 'lixiaoming@example.com', 'potential', NOW(), NOW()),
(328, '潘大伟', '13900000328', 'pandawei@example.com', 'converted', NOW(), NOW()),
(329, '毛小东', '13900000329', 'maoxiaodong@example.com', 'potential', NOW(), NOW()),
(330, '邱大鹏', '13900000330', 'qiudapeng@example.com', 'converted', NOW(), NOW()),
(331, '侯小翠', '13900000331', 'houxiaocui@example.com', 'potential', NOW(), NOW()),
(332, '江大志', '13900000332', 'jiangdazhi@example.com', 'converted', NOW(), NOW()),
(333, '汤小军', '13900000333', 'tangxiaojun@example.com', 'potential', NOW(), NOW()),
(334, '邢大明', '13900000334', 'xingdaming@example.com', 'converted', NOW(), NOW()),
(335, '蓝小刚', '13900000335', 'lanxiaogang@example.com', 'potential', NOW(), NOW()),
(336, '冉大林', '13900000336', 'randalin@example.com', 'converted', NOW(), NOW()),
(337, '谭小明', '13900000337', 'tanxiaoming@example.com', 'potential', NOW(), NOW()),
(338, '裴大成', '13900000338', 'peidacheng@example.com', 'converted', NOW(), NOW()),
(339, '钟小刚', '13900000339', 'zhongxiaogang@example.com', 'potential', NOW(), NOW()),
(340, '赖大力', '13900000340', 'laidali@example.com', 'converted', NOW(), NOW()),
(341, '文小明', '13900000341', 'wenxiaoming@example.com', 'potential', NOW(), NOW()),
(342, '贺大伟', '13900000342', 'hedawei@example.com', 'converted', NOW(), NOW()),
(343, '邓小东', '13900000343', 'dengxiaodong@example.com', 'potential', NOW(), NOW()),
(344, '裘大鹏', '13900000344', 'qiudapeng2@example.com', 'converted', NOW(), NOW()),
(345, '屈小翠', '13900000345', 'quxiaocui@example.com', 'potential', NOW(), NOW()),
(346, '鲍大志', '13900000346', 'baodazhi@example.com', 'converted', NOW(), NOW()),
(347, '盛小军', '13900000347', 'shengxiaojun@example.com', 'potential', NOW(), NOW()),
(348, '苗大明', '13900000348', 'miaodaming@example.com', 'converted', NOW(), NOW()),
(349, '殷小刚', '13900000349', 'yinxiaogang@example.com', 'potential', NOW(), NOW()),
(350, '章大林', '13900000350', 'zhangdalin@example.com', 'converted', NOW(), NOW()),
(351, '蓝大成', '13900000351', 'landacheng@example.com', 'potential', NOW(), NOW()),
(352, '苗小明', '13900000352', 'miaoxiaoming@example.com', 'converted', NOW(), NOW()),
(353, '盛大伟', '13900000353', 'shengdawei@example.com', 'potential', NOW(), NOW()),
(354, '鲍小东', '13900000354', 'baoxiaodong@example.com', 'converted', NOW(), NOW()),
(355, '屈大鹏', '13900000355', 'qudapeng@example.com', 'potential', NOW(), NOW()),
(356, '裘小翠', '13900000356', 'qiuxiaocui@example.com', 'converted', NOW(), NOW()),
(357, '贺大志', '13900000357', 'hedazhi@example.com', 'potential', NOW(), NOW()),
(358, '邓小军', '13900000358', 'dengxiaojun@example.com', 'converted', NOW(), NOW()),
(359, '裘大明', '13900000359', 'qiudaming@example.com', 'potential', NOW(), NOW()),
(360, '屈小刚', '13900000360', 'quxiaogang@example.com', 'converted', NOW(), NOW()),
(361, '鲍大林', '13900000361', 'baodalin@example.com', 'potential', NOW(), NOW()),
(362, '盛小明', '13900000362', 'shengxiaoming@example.com', 'converted', NOW(), NOW()),
(363, '苗大成', '13900000363', 'miaodacheng@example.com', 'potential', NOW(), NOW()),
(364, '殷小军', '13900000364', 'yinxiaojun@example.com', 'converted', NOW(), NOW()),
(365, '章大明', '13900000365', 'zhangdaming@example.com', 'potential', NOW(), NOW()),
(366, '蓝小刚2', '13900000366', 'lanxiaogang2@example.com', 'converted', NOW(), NOW()),
(367, '苗大林', '13900000367', 'miaodalin@example.com', 'potential', NOW(), NOW()),
(368, '盛大成', '13900000368', 'shengdacheng@example.com', 'converted', NOW(), NOW()),
(369, '鲍小明', '13900000369', 'baoxiaoming@example.com', 'potential', NOW(), NOW()),
(370, '屈大伟', '13900000370', 'qudawei@example.com', 'converted', NOW(), NOW()),
(371, '裘小东', '13900000371', 'qiuxiaodong@example.com', 'potential', NOW(), NOW()),
(372, '贺大鹏', '13900000372', 'hedapeng@example.com', 'converted', NOW(), NOW()),
(373, '邓小翠', '13900000373', 'dengxiaocui@example.com', 'potential', NOW(), NOW()),
(374, '裘大志', '13900000374', 'qiudazhi@example.com', 'converted', NOW(), NOW()),
(375, '屈小军', '13900000375', 'quxiaojun@example.com', 'potential', NOW(), NOW()),
(376, '鲍大明', '13900000376', 'baodaming@example.com', 'converted', NOW(), NOW()),
(377, '盛小刚', '13900000377', 'shengxiaogang@example.com', 'potential', NOW(), NOW()),
(378, '苗大鹏', '13900000378', 'miaodapeng@example.com', 'converted', NOW(), NOW()),
(379, '殷小翠', '13900000379', 'yinxiaocui@example.com', 'potential', NOW(), NOW()),
(380, '章大志', '13900000380', 'zhangdazhi@example.com', 'converted', NOW(), NOW()),
(381, '蓝小军', '13900000381', 'lanxiaojun@example.com', 'potential', NOW(), NOW()),
(382, '苗大明2', '13900000382', 'miaodaming2@example.com', 'converted', NOW(), NOW()),
(383, '盛大林', '13900000383', 'shengdalin@example.com', 'potential', NOW(), NOW()),
(384, '鲍小刚', '13900000384', 'baoxiaogang@example.com', 'converted', NOW(), NOW()),
(385, '屈大成', '13900000385', 'qudacheng@example.com', 'potential', NOW(), NOW()),
(386, '裘小明', '13900000386', 'qiuxiaoming@example.com', 'converted', NOW(), NOW()),
(387, '贺大林', '13900000387', 'hedalin@example.com', 'potential', NOW(), NOW()),
(388, '邓小刚', '13900000388', 'dengxiaogang@example.com', 'converted', NOW(), NOW()),
(389, '裘大成', '13900000389', 'qiudacheng@example.com', 'potential', NOW(), NOW()),
(390, '屈小明', '13900000390', 'quxiaoming@example.com', 'converted', NOW(), NOW()),
(391, '鲍大伟', '13900000391', 'baodawei@example.com', 'potential', NOW(), NOW()),
(392, '盛小东', '13900000392', 'shengxiaodong@example.com', 'converted', NOW(), NOW()),
(393, '苗大志', '13900000393', 'miaodazhi@example.com', 'potential', NOW(), NOW()),
(394, '殷小明', '13900000394', 'yinxiaoming@example.com', 'converted', NOW(), NOW()),
(395, '章大鹏', '13900000395', 'zhangdapeng@example.com', 'potential', NOW(), NOW()),
(396, '蓝小翠', '13900000396', 'lanxiaocui@example.com', 'converted', NOW(), NOW()),
(397, '苗大志2', '13900000397', 'miaodazhi2@example.com', 'potential', NOW(), NOW()),
(398, '盛大明2', '13900000398', 'shengdaming2@example.com', 'converted', NOW(), NOW()),
(399, '鲍小军', '13900000399', 'baoxiaojun@example.com', 'potential', NOW(), NOW()),
(400, '屈大林', '13900000400', 'qudalin@example.com', 'converted', NOW(), NOW()),
(401, '李大壮', '13900000401', 'lidakzhuang@example.com', 'potential', NOW(), NOW()),
(402, '王小虎', '13900000402', 'wangxiaohu@example.com', 'converted', NOW(), NOW()),
(403, '张大山', '13900000403', 'zhangdashan@example.com', 'potential', NOW(), NOW()),
(404, '刘小宝', '13900000404', 'liuxiaobao@example.com', 'converted', NOW(), NOW()),
(405, '陈大龙', '13900000405', 'chendalong@example.com', 'potential', NOW(), NOW()),
(406, '赵小飞', '13900000406', 'zhaoxiaofei@example.com', 'converted', NOW(), NOW()),
(407, '孙大鹏2', '13900000407', 'sundapeng2@example.com', 'potential', NOW(), NOW()),
(408, '周小刚', '13900000408', 'zhouxiaogang2@example.com', 'converted', NOW(), NOW()),
(409, '吴大明2', '13900000409', 'wudaming2@example.com', 'potential', NOW(), NOW()),
(410, '郑小林', '13900000410', 'zhengxiaolin@example.com', 'converted', NOW(), NOW()),
(411, '冯大成2', '13900000411', 'fengdacheng2@example.com', 'potential', NOW(), NOW()),
(412, '褚小明2', '13900000412', 'chuxiaoming2@example.com', 'converted', NOW(), NOW()),
(413, '卫大伟2', '13900000413', 'weidawei2@example.com', 'potential', NOW(), NOW()),
(414, '蒋小东', '13900000414', 'jiangxiaodong2@example.com', 'converted', NOW(), NOW()),
(415, '沈大志2', '13900000415', 'shendazhi2@example.com', 'potential', NOW(), NOW()),
(416, '韩小军', '13900000416', 'hanxiaojun2@example.com', 'converted', NOW(), NOW()),
(417, '杨大明2', '13900000417', 'yangdaming2@example.com', 'potential', NOW(), NOW()),
(418, '朱小林', '13900000418', 'zhuxiaolin@example.com', 'converted', NOW(), NOW()),
(419, '秦大宝', '13900000419', 'qindabao@example.com', 'potential', NOW(), NOW()),
(420, '尤小龙', '13900000420', 'youxiaolong@example.com', 'converted', NOW(), NOW()),
(421, '许大鹏2', '13900000421', 'xudapeng2@example.com', 'potential', NOW(), NOW()),
(422, '贾小虎', '13900000422', 'jiaxiaohu@example.com', 'potential', NOW(), NOW()),
(423, '罗大山2', '13900000423', 'luodashan2@example.com', 'potential', NOW(), NOW()),
(424, '毕小宝', '13900000424', 'bixiaobao@example.com', 'converted', NOW(), NOW()),
(425, '龚大龙', '13900000425', 'gongdalong@example.com', 'potential', NOW(), NOW()),
(426, '石小飞', '13900000426', 'shixiaofei@example.com', 'converted', NOW(), NOW()),
(427, '黎大鹏3', '13900000427', 'lidapeng3@example.com', 'potential', NOW(), NOW()),
(428, '潘小刚', '13900000428', 'panxiaogang@example.com', 'converted', NOW(), NOW()),
(429, '毛大明3', '13900000429', 'maodaming3@example.com', 'potential', NOW(), NOW()),
(430, '邱小林', '13900000430', 'qiuxiaolin@example.com', 'converted', NOW(), NOW()),
(431, '侯大成3', '13900000431', 'houdacheng3@example.com', 'potential', NOW(), NOW()),
(432, '江小明3', '13900000432', 'jiangxiaoming3@example.com', 'potential', NOW(), NOW()),
(433, '汤大伟3', '13900000433', 'tangdawei3@example.com', 'potential', NOW(), NOW()),
(434, '邢小东', '13900000434', 'xingxiaodong@example.com', 'converted', NOW(), NOW()),
(435, '蓝大志3', '13900000435', 'landazhi3@example.com', 'potential', NOW(), NOW()),
(436, '冉小军', '13900000436', 'ranxiaojun@example.com', 'potential', NOW(), NOW()),
(437, '谭大明3', '13900000437', 'tandaming3@example.com', 'potential', NOW(), NOW()),
(438, '裴小林', '13900000438', 'peixiaolin@example.com', 'converted', NOW(), NOW()),
(439, '钟大宝', '13900000439', 'zhongdabao@example.com', 'potential', NOW(), NOW()),
(440, '赖小龙', '13900000440', 'laixiaolong@example.com', 'converted', NOW(), NOW()),
(441, '文大鹏4', '13900000441', 'wendapeng4@example.com', 'potential', NOW(), NOW()),
(442, '贺小虎', '13900000442', 'hexiaohu@example.com', 'converted', NOW(), NOW()),
(443, '邓大山3', '13900000443', 'dengdashan3@example.com', 'potential', NOW(), NOW()),
(444, '裘小宝', '13900000444', 'qiuxiaobao@example.com', 'converted', NOW(), NOW()),
(445, '屈大龙', '13900000445', 'qudalong@example.com', 'potential', NOW(), NOW()),
(446, '鲍小飞', '13900000446', 'baoxiaofei@example.com', 'converted', NOW(), NOW()),
(447, '盛大鹏5', '13900000447', 'shengdapeng5@example.com', 'potential', NOW(), NOW()),
(448, '苗小刚', '13900000448', 'miaoxiaogang@example.com', 'converted', NOW(), NOW()),
(449, '殷大明4', '13900000449', 'yindaming4@example.com', 'potential', NOW(), NOW()),
(450, '章小林', '13900000450', 'zhangxiaolin@example.com', 'converted', NOW(), NOW()),
(451, '蓝大成2', '13900000451', 'landacheng2@example.com', 'potential', NOW(), NOW()),
(452, '苗小明2', '13900000452', 'miaoxiaoming2@example.com', 'converted', NOW(), NOW()),
(453, '盛大伟4', '13900000453', 'shengdawei4@example.com', 'potential', NOW(), NOW()),
(454, '鲍小东2', '13900000454', 'baoxiaodong2@example.com', 'converted', NOW(), NOW()),
(455, '屈大鹏2', '13900000455', 'qudapeng2@example.com', 'potential', NOW(), NOW()),
(456, '裘小翠2', '13900000456', 'qiuxiaocui2@example.com', 'converted', NOW(), NOW()),
(457, '贺大志2', '13900000457', 'hedazhi2@example.com', 'potential', NOW(), NOW()),
(458, '邓小军2', '13900000458', 'dengxiaojun2@example.com', 'converted', NOW(), NOW()),
(459, '裘大明2', '13900000459', 'qiudaming2@example.com', 'potential', NOW(), NOW()),
(460, '屈小刚2', '13900000460', 'quxiaogang2@example.com', 'converted', NOW(), NOW()),
(461, '鲍大林2', '13900000461', 'baodalin2@example.com', 'potential', NOW(), NOW()),
(462, '盛小明2', '13900000462', 'shengxiaoming2@example.com', 'converted', NOW(), NOW()),
(463, '苗大成2', '13900000463', 'miaodacheng2@example.com', 'potential', NOW(), NOW()),
(464, '殷小军2', '13900000464', 'yinxiaojun2@example.com', 'converted', NOW(), NOW()),


(465, '章大明2', '13900000465', 'zhangdaming2@example.com', 'potential', NOW(), NOW()),
(466, '蓝小刚3', '13900000466', 'lanxiaogang3@example.com', 'potential', NOW(), NOW()),
(467, '苗大林2', '13900000467', 'miaodalin2@example.com', 'potential', NOW(), NOW()),
(468, '盛大成2', '13900000468', 'shengdacheng2@example.com', 'potential', NOW(), NOW()),
(469, '鲍小明2', '13900000469', 'baoxiaoming2@example.com', 'potential', NOW(), NOW()),
(470, '屈大伟2', '13900000470', 'qudawei2@example.com', 'potential', NOW(), NOW()),
(471, '裘小东2', '13900000471', 'qiuxiaodong2@example.com', 'potential', NOW(), NOW()),
(472, '贺大鹏2', '13900000472', 'hedapeng2@example.com', 'potential', NOW(), NOW()),
(473, '邓小翠2', '13900000473', 'dengxiaocui2@example.com', 'potential', NOW(), NOW()),
(474, '裘大志2', '13900000474', 'qiudazhi2@example.com', 'potential', NOW(), NOW()),
(475, '屈小军2', '13900000475', 'quxiaojun2@example.com', 'potential', NOW(), NOW()),
(476, '鲍大明2', '13900000476', 'baodaming2@example.com', 'potential', NOW(), NOW()),
(477, '盛小刚2', '13900000477', 'shengxiaogang2@example.com', 'potential', NOW(), NOW()),
(478, '苗大鹏2', '13900000478', 'miaodapeng2@example.com', 'potential', NOW(), NOW()),
(479, '殷小翠2', '13900000479', 'yinxiaocui2@example.com', 'potential', NOW(), NOW()),
(480, '章大志2', '13900000480', 'zhangdazhi2@example.com', 'potential', NOW(), NOW()),
(481, '蓝小军2', '13900000481', 'lanxiaojun2@example.com', 'potential', NOW(), NOW()),
(482, '苗大明3', '13900000482', 'miaodaming3@example.com', 'potential', NOW(), NOW()),
(483, '盛大林2', '13900000483', 'shengdalin2@example.com', 'potential', NOW(), NOW()),
(484, '鲍小刚2', '13900000484', 'baoxiaogang2@example.com', 'potential', NOW(), NOW()),
(485, '屈大成2', '13900000485', 'qudacheng2@example.com', 'potential', NOW(), NOW()),
(486, '裘小明2', '13900000486', 'qiuxiaoming2@example.com', 'potential', NOW(), NOW()),
(487, '贺大林2', '13900000487', 'hedalin2@example.com', 'potential', NOW(), NOW()),
(488, '邓小刚2', '13900000488', 'dengxiaogang2@example.com', 'potential', NOW(), NOW()),
(489, '裘大成2', '13900000489', 'qiudacheng2@example.com', 'potential', NOW(), NOW()),
(490, '屈小明2', '13900000490', 'quxiaoming2@example.com', 'potential', NOW(), NOW()),
(491, '鲍大伟2', '13900000491', 'baodawei2@example.com', 'potential', NOW(), NOW()),
(492, '盛小东2', '13900000492', 'shengxiaodong2@example.com', 'potential', NOW(), NOW()),
(493, '苗大志3', '13900000493', 'miaodazhi3@example.com', 'potential', NOW(), NOW()),
(494, '殷小明2', '13900000494', 'yinxiaoming2@example.com', 'potential', NOW(), NOW()),
(495, '章大鹏2', '13900000495', 'zhangdapeng2@example.com', 'potential', NOW(), NOW()),
(496, '蓝小翠2', '13900000496', 'lanxiaocui2@example.com', 'potential', NOW(), NOW()),
(497, '苗大志4', '13900000497', 'miaodazhi4@example.com', 'potential', NOW(), NOW()),
(498, '盛大明3', '13900000498', 'shengdaming3@example.com', 'potential', NOW(), NOW()),
(499, '鲍小军2', '13900000499', 'baoxiaojun2@example.com', 'potential', NOW(), NOW()),
(500, '屈大林2', '13900000500', 'qudalin2@example.com', 'potential', NOW(), NOW());

-- 插入团队1的佣金记录
INSERT INTO commissions (id, user_id, order_id, camp_period_id, commission_type, tier, commission_amount, created_at, updated_at, remarks, customer_id, user_promoted_id)
VALUES
(101, 1, 20001, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 2, NULL),
(102, 1, 20002, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 4, NULL),
(103, 1, 20003, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 6, NULL),
(104, 1, 20004, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 8, NULL),
(105, 1, 20005, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 10, NULL),
(106, 1, 20006, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 12, NULL),
(107, 1, 20007, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 14, NULL),
(108, 1, 20008, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 16, NULL),
(109, 1, 20009, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 18, NULL),
(110, 1, 20010, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 20, NULL),
(111, 1, 20011, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 22, NULL),
(112, 1, 20012, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 24, NULL),
(113, 1, 20013, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 26, NULL),
(114, 1, 20014, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 28, NULL),
(115, 1, 20015, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 30, NULL),
(116, 1, 20016, 1001, 'ambassador_conversion', 'intermediate', 400.00, NOW(), NOW(), '中级转化', 32, NULL),

-- 团队成员的ambassador_conversion记录
(117, 2, 20017, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 34, NULL),
(118, 2, 20018, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 36, NULL),
(119, 2, 20019, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 38, NULL),
(120, 3, 20020, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 40, NULL),
(121, 3, 20021, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 42, NULL),
(122, 3, 20022, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 44, NULL),
(123, 3, 20023, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 46, NULL),
(124, 3, 20024, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 48, NULL),
(125, 3, 20025, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 50, NULL),
(126, 3, 20026, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 52, NULL),
(127, 3, 20027, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 54, NULL),
(128, 3, 20028, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 56, NULL),
(129, 3, 20029, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 58, NULL),
(130, 4, 20030, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 60, NULL),
(131, 4, 20031, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 62, NULL),
(132, 4, 20032, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 64, NULL),
(133, 4, 20033, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 66, NULL),
(134, 4, 20034, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 68, NULL),
(135, 4, 20035, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 70, NULL),

-- 为每个团队成员的ambassador_conversion添加对应的团队长leader_team_conversion记录
-- user_id=2的记录对应的团队长记录
(136, 1, 20017, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 34, NULL),
(137, 1, 20018, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 36, NULL),
(138, 1, 20019, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 38, NULL),

-- user_id=3的记录对应的团队长记录
(139, 1, 20020, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 40, NULL),
(140, 1, 20021, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 42, NULL),
(141, 1, 20022, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 44, NULL),
(142, 1, 20023, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 46, NULL),
(143, 1, 20024, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 48, NULL),
(144, 1, 20025, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 50, NULL),
(145, 1, 20026, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 52, NULL),
(146, 1, 20027, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 54, NULL),
(147, 1, 20028, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 56, NULL),
(148, 1, 20029, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 58, NULL),

-- user_id=4的记录对应的团队长记录
(149, 1, 20030, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 60, NULL),
(150, 1, 20031, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 62, NULL),
(151, 1, 20032, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 64, NULL),
(152, 1, 20033, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 66, NULL),
(153, 1, 20034, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 68, NULL),
(154, 1, 20035, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 70, NULL);



-- 插入团队2的佣金记录
INSERT INTO commissions (id, user_id, order_id, camp_period_id, commission_type, tier, commission_amount, created_at, updated_at, remarks, customer_id, user_promoted_id)
VALUES
-- 团队长(user_id=6)的直接转化记录
(155, 6, 21001, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 72, NULL),
(156, 6, 21002, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 74, NULL),
(157, 6, 21003, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 76, NULL),
(158, 6, 21004, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 78, NULL),
(159, 6, 21005, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 80, NULL),
(160, 6, 21006, 1001, 'ambassador_conversion', 'intermediate', 400.00, NOW(), NOW(), '中级转化', 82, NULL),

-- 团队成员(user_id=7)的转化记录
(161, 7, 21007, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 84, NULL),
(162, 7, 21008, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 86, NULL),
(163, 7, 21009, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 88, NULL),

-- 团队成员(user_id=8)的转化记录
(164, 8, 21010, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 90, NULL),
(165, 8, 21011, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 92, NULL),
(166, 8, 21012, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 94, NULL),

-- 团队成员(user_id=9)的转化记录
(167, 9, 21013, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 96, NULL),
(168, 9, 21014, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 98, NULL),

-- 团队成员(user_id=10)的转化记录
(169, 10, 21015, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 100, NULL),
(170, 10, 21016, 1001, 'ambassador_conversion', 'intermediate', 400.00, NOW(), NOW(), '中级转化', 102, NULL),

-- 为团队成员的ambassador_conversion添加对应的团队长leader_team_conversion记录
-- user_id=7的记录对应的团队长记录
(171, 6, 21007, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 84, NULL),
(172, 6, 21008, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 86, NULL),
(173, 6, 21009, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 88, NULL),

-- user_id=8的记录对应的团队长记录
(174, 6, 21010, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 90, NULL),
(175, 6, 21011, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 92, NULL),
(176, 6, 21012, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 94, NULL),

-- user_id=9的记录对应的团队长记录
(177, 6, 21013, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 96, NULL),
(178, 6, 21014, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 98, NULL),

-- user_id=10的记录对应的团队长记录
(179, 6, 21015, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 100, NULL),
(180, 6, 21016, 1001, 'leader_team_conversion', 'intermediate', 40.00, NOW(), NOW(), '团队中级转化', 102, NULL);

INSERT INTO commissions (id, user_id, order_id, camp_period_id, commission_type, tier, commission_amount, created_at, updated_at, remarks, customer_id, user_promoted_id)
VALUES
(181, 1, 22001, 1001, 'promotion_bonus_percentage', NULL, 188.50, NOW(), NOW(), '团队2大使长晋升比例奖励(5%)', NULL, 6);



-- 插入团队3的佣金记录
INSERT INTO commissions (id, user_id, order_id, camp_period_id, commission_type, tier, commission_amount, created_at, updated_at, remarks, customer_id, user_promoted_id)
VALUES
-- 团队长(user_id=11)的直接转化记录
(182, 11, 23001, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 104, NULL),
(183, 11, 23002, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 106, NULL),
(184, 11, 23003, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 108, NULL),
(185, 11, 23004, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 110, NULL),
(186, 11, 23005, 1001, 'ambassador_conversion', 'junior', 400.00, NOW(), NOW(), '初级转化', 112, NULL),

-- 团队成员(user_id=12)的转化记录
(187, 12, 23006, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 114, NULL),
(188, 12, 23007, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 116, NULL),
(189, 12, 23008, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 118, NULL),

-- 团队成员(user_id=13)的转化记录
(190, 13, 23009, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 120, NULL),
(191, 13, 23010, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 122, NULL),
(192, 13, 23011, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 124, NULL),

-- 团队成员(user_id=14)的转化记录
(193, 14, 23012, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 126, NULL),
(194, 14, 23013, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 128, NULL),

-- 团队成员(user_id=15)的转化记录
(195, 15, 23014, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 130, NULL),
(196, 15, 23015, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 132, NULL),

-- 团队成员(user_id=16)的转化记录
(197, 16, 23016, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 134, NULL),
(198, 16, 23017, 1001, 'ambassador_conversion', 'intermediate', 400.00, NOW(), NOW(), '初级转化', 136, NULL),

-- 为团队成员的ambassador_conversion添加对应的团队长leader_team_conversion记录
-- user_id=12的记录对应的团队长记录
(199, 11, 23006, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 114, NULL),
(200, 11, 23007, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 116, NULL),
(201, 11, 23008, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 118, NULL),

-- user_id=13的记录对应的团队长记录
(202, 11, 23009, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 120, NULL),
(203, 11, 23010, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 122, NULL),
(204, 11, 23011, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 124, NULL),

-- user_id=14的记录对应的团队长记录
(205, 11, 23012, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 126, NULL),
(206, 11, 23013, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 128, NULL),

-- user_id=15的记录对应的团队长记录
(207, 11, 23014, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 130, NULL),
(208, 11, 23015, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 132, NULL),

-- user_id=16的记录对应的团队长记录
(209, 11, 23016, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 134, NULL),
(210, 11, 23017, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 136, NULL);


-- 插入团队4的佣金记录
INSERT INTO commissions (id, user_id, order_id, camp_period_id, commission_type, tier, commission_amount, created_at, updated_at, remarks, customer_id, user_promoted_id)
VALUES
-- 团队长(user_id=17)的直接转化记录
(211, 17, 24001, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 138, NULL),
(212, 17, 24002, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 140, NULL),
(213, 17, 24003, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 142, NULL),
(214, 17, 24004, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 144, NULL),
(215, 17, 24005, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 146, NULL),

-- 团队成员(user_id=18)的转化记录
(216, 18, 24006, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 148, NULL),
(217, 18, 24007, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 150, NULL),
(218, 18, 24008, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 152, NULL),

-- 团队成员(user_id=19)的转化记录
(219, 19, 24009, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 154, NULL),
(220, 19, 24010, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 156, NULL),
(221, 19, 24011, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 158, NULL),

-- 团队成员(user_id=20)的转化记录
(222, 20, 24012, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 160, NULL),
(223, 20, 24013, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 162, NULL),
(224, 20, 24014, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 164, NULL),

-- 为团队成员的ambassador_conversion添加对应的团队长leader_team_conversion记录
-- user_id=18的记录对应的团队长记录
(225, 17, 24006, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 148, NULL),
(226, 17, 24007, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 150, NULL),
(227, 17, 24008, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 152, NULL),

-- user_id=19的记录对应的团队长记录
(228, 17, 24009, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 154, NULL),
(229, 17, 24010, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 156, NULL),
(230, 17, 24011, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 158, NULL),

-- user_id=20的记录对应的团队长记录
(231, 17, 24012, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 160, NULL),
(232, 17, 24013, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 162, NULL),
(233, 17, 24014, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 164, NULL);


-- 插入团队5的佣金记录
INSERT INTO commissions (id, user_id, order_id, camp_period_id, commission_type, tier, commission_amount, created_at, updated_at, remarks, customer_id, user_promoted_id)
VALUES
-- 团队长(user_id=21)的直接转化记录
(234, 21, 25001, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 166, NULL),
(235, 21, 25002, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 168, NULL),
(236, 21, 25003, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 170, NULL),
(237, 21, 25004, 1001, 'ambassador_conversion', 'intermediate', 400.00, NOW(), NOW(), '中级转化', 172, NULL),

-- 团队成员(user_id=22)的转化记录
(238, 22, 25005, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 174, NULL),
(239, 22, 25006, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 176, NULL),
(240, 22, 25007, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 178, NULL),

-- 团队成员(user_id=23)的转化记录
(241, 23, 25008, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 180, NULL),
(242, 23, 25009, 1001, 'ambassador_conversion', 'intermediate', 400.00, NOW(), NOW(), '初级转化', 182, NULL),

-- 团队成员(user_id=24)的转化记录
(243, 24, 25010, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 184, NULL),
(244, 24, 25011, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 186, NULL),
(245, 24, 25012, 1001, 'ambassador_conversion', 'junior', 400.00, NOW(), NOW(), '初级转化', 188, NULL),

-- 团队成员(user_id=25)的转化记录
(246, 25, 25013, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 190, NULL),
(247, 25, 25014, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 192, NULL),

-- 为团队成员的ambassador_conversion添加对应的团队长leader_team_conversion记录
-- user_id=22的记录对应的团队长记录
(248, 21, 25005, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 174, NULL),
(249, 21, 25006, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 176, NULL),
(250, 21, 25007, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 178, NULL),

-- user_id=23的记录对应的团队长记录
(251, 21, 25008, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 180, NULL),
(252, 21, 25009, 1001, 'leader_team_conversion', 'junior', 40.00, NOW(), NOW(), '团队初级转化', 182, NULL),

-- user_id=24的记录对应的团队长记录
(253, 21, 25010, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 184, NULL),
(254, 21, 25011, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 186, NULL),
(255, 21, 25012, 1001, 'leader_team_conversion', 'junior', 40.00, NOW(), NOW(), '团队中级转化', 188, NULL),

-- user_id=25的记录对应的团队长记录
(256, 21, 25013, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 190, NULL),
(257, 21, 25014, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 192, NULL);



-- 插入团队6的佣金记录
INSERT INTO commissions (id, user_id, order_id, camp_period_id, commission_type, tier, commission_amount, created_at, updated_at, remarks, customer_id, user_promoted_id)
VALUES
-- 团队长(user_id=26)的直接转化记录
(258, 26, 26001, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 194, NULL),
(259, 26, 26002, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 196, NULL),
(260, 26, 26003, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 198, NULL),

-- 团队成员(user_id=27)的转化记录
(261, 27, 26004, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 200, NULL),
(262, 27, 26005, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 202, NULL),

-- 团队成员(user_id=28)的转化记录
(263, 28, 26006, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 204, NULL),

-- 团队成员(user_id=29)的转化记录
(264, 29, 26007, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 206, NULL),

-- 团队成员(user_id=30)的转化记录
(265, 30, 26008, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 208, NULL),

-- 为团队成员的ambassador_conversion添加对应的团队长leader_team_conversion记录
-- user_id=27的记录对应的团队长记录
(266, 26, 26004, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 200, NULL),
(267, 26, 26005, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 202, NULL),

-- user_id=28的记录对应的团队长记录
(268, 26, 26006, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 204, NULL),

-- user_id=29的记录对应的团队长记录
(269, 26, 26007, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 206, NULL),

-- user_id=30的记录对应的团队长记录
(270, 26, 26008, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 208, NULL);

-- 插入团队7的佣金记录
INSERT INTO commissions (id, user_id, order_id, camp_period_id, commission_type, tier, commission_amount, created_at, updated_at, remarks, customer_id, user_promoted_id)
VALUES
-- 团队长(user_id=32)的直接转化记录
(271, 32, 27001, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 210, NULL),
(272, 32, 27002, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 212, NULL),
(273, 32, 27003, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 214, NULL),

-- 团队成员(user_id=33)的转化记录
(274, 33, 27004, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 216, NULL),
(275, 33, 27005, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 218, NULL),

-- 团队成员(user_id=34)的转化记录
(276, 34, 27006, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 220, NULL),

-- 团队成员(user_id=35)的转化记录
(277, 35, 27007, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 222, NULL),

-- 团队成员(user_id=36)的转化记录
(278, 36, 27008, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 224, NULL),

-- 为团队成员的ambassador_conversion添加对应的团队长leader_team_conversion记录
-- user_id=33的记录对应的团队长记录
(279, 32, 27004, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 216, NULL),
(280, 32, 27005, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 218, NULL),

-- user_id=34的记录对应的团队长记录
(281, 32, 27006, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 220, NULL),

-- user_id=35的记录对应的团队长记录
(282, 32, 27007, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 222, NULL),

-- user_id=36的记录对应的团队长记录
(283, 32, 27008, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 224, NULL);




-- 插入团队8的佣金记录
INSERT INTO commissions (id, user_id, order_id, camp_period_id, commission_type, tier, commission_amount, created_at, updated_at, remarks, customer_id, user_promoted_id)
VALUES
-- 团队长(user_id=37)的直接转化记录
(284, 37, 28001, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 226, NULL),
(285, 37, 28002, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 228, NULL),

-- 团队成员(user_id=38)的转化记录
(286, 38, 28003, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 230, NULL),
(287, 38, 28004, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 232, NULL),

-- 团队成员(user_id=39)的转化记录
(288, 39, 28005, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 234, NULL),

-- 团队成员(user_id=40)的转化记录
(289, 40, 28006, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 236, NULL),

-- 团队成员(user_id=41)的转化记录
(290, 41, 28007, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 238, NULL),

-- 为团队成员的ambassador_conversion添加对应的团队长leader_team_conversion记录
-- user_id=38的记录对应的团队长记录
(291, 37, 28003, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 230, NULL),
(292, 37, 28004, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 232, NULL),

-- user_id=39的记录对应的团队长记录
(293, 37, 28005, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 234, NULL),

-- user_id=40的记录对应的团队长记录
(294, 37, 28006, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 236, NULL),

-- user_id=41的记录对应的团队长记录
(295, 37, 28007, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 238, NULL);



-- 插入团队9的佣金记录
INSERT INTO commissions (id, user_id, order_id, camp_period_id, commission_type, tier, commission_amount, created_at, updated_at, remarks, customer_id, user_promoted_id)
VALUES
-- 团队长(user_id=42)的直接转化记录
(296, 42, 29001, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 240, NULL),
(297, 42, 29002, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 242, NULL),

-- 团队成员(user_id=43)的转化记录
(298, 43, 29003, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 244, NULL),

-- 团队成员(user_id=44)的转化记录
(299, 44, 29004, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 246, NULL),
(300, 44, 29005, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 248, NULL),

-- 团队成员(user_id=45)的转化记录
(301, 45, 29006, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 250, NULL),

-- 团队成员(user_id=46)的转化记录
(302, 46, 29007, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 252, NULL),

-- 为团队成员的ambassador_conversion添加对应的团队长leader_team_conversion记录
-- user_id=43的记录对应的团队长记录
(303, 42, 29003, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 244, NULL),

-- user_id=44的记录对应的团队长记录
(304, 42, 29004, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 246, NULL),
(305, 42, 29005, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 248, NULL),

-- user_id=45的记录对应的团队长记录
(306, 42, 29006, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 250, NULL),

-- user_id=46的记录对应的团队长记录
(307, 42, 29007, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 252, NULL);



-- 插入团队10的佣金记录
INSERT INTO commissions (id, user_id, order_id, camp_period_id, commission_type, tier, commission_amount, created_at, updated_at, remarks, customer_id, user_promoted_id)
VALUES
-- 团队长(user_id=47)的直接转化记录
(308, 47, 30001, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 254, NULL),
(309, 47, 30002, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 256, NULL),

-- 团队成员(user_id=48)的转化记录
(310, 48, 30003, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 258, NULL),

-- 团队成员(user_id=49)的转化记录
(311, 49, 30004, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 260, NULL),
(312, 49, 30005, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 262, NULL),

-- 团队成员(user_id=50)的转化记录
(313, 50, 30006, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 264, NULL),

-- 团队成员(user_id=51)的转化记录
(314, 51, 30007, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 266, NULL),

-- 为团队成员的ambassador_conversion添加对应的团队长leader_team_conversion记录
-- user_id=48的记录对应的团队长记录
(315, 47, 30003, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 258, NULL),

-- user_id=49的记录对应的团队长记录
(316, 47, 30004, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 260, NULL),
(317, 47, 30005, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 262, NULL),

-- user_id=50的记录对应的团队长记录
(318, 47, 30006, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 264, NULL),

-- user_id=51的记录对应的团队长记录
(319, 47, 30007, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 266, NULL);

-- 插入团队11的佣金记录
INSERT INTO commissions (id, user_id, order_id, camp_period_id, commission_type, tier, commission_amount, created_at, updated_at, remarks, customer_id, user_promoted_id)
VALUES
-- 团队长(user_id=52)的直接转化记录
(320, 52, 31001, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 268, NULL),
(321, 52, 31002, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 270, NULL),

-- 团队成员(user_id=53)的转化记录
(322, 53, 31003, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 272, NULL),
(323, 53, 31004, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 274, NULL),

-- 团队成员(user_id=54)的转化记录
(324, 54, 31005, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 276, NULL),

-- 团队成员(user_id=55)的转化记录
(325, 55, 31006, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 278, NULL),

-- 为团队成员的ambassador_conversion添加对应的团队长leader_team_conversion记录
-- user_id=53的记录对应的团队长记录
(326, 52, 31003, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 272, NULL),
(327, 52, 31004, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 274, NULL),

-- user_id=54的记录对应的团队长记录
(328, 52, 31005, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 276, NULL),

-- user_id=55的记录对应的团队长记录
(329, 52, 31006, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 278, NULL);


-- 插入团队12的佣金记录
INSERT INTO commissions (id, user_id, order_id, camp_period_id, commission_type, tier, commission_amount, created_at, updated_at, remarks, customer_id, user_promoted_id)
VALUES
-- 团队长(user_id=56)的直接转化记录
(330, 56, 32001, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 280, NULL),
(331, 56, 32002, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 282, NULL),

-- 团队成员(user_id=57)的转化记录
(332, 57, 32003, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 284, NULL),

-- 团队成员(user_id=58)的转化记录
(333, 58, 32004, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 286, NULL),

-- 团队成员(user_id=59)的转化记录
(334, 59, 32005, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 288, NULL),

-- 团队成员(user_id=60)的转化记录
(335, 60, 32006, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 290, NULL),

-- 为团队成员的ambassador_conversion添加对应的团队长leader_team_conversion记录
-- user_id=57的记录对应的团队长记录
(336, 56, 32003, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 284, NULL),

-- user_id=58的记录对应的团队长记录
(337, 56, 32004, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 286, NULL),

-- user_id=59的记录对应的团队长记录
(338, 56, 32005, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 288, NULL),

-- user_id=60的记录对应的团队长记录
(339, 56, 32006, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 290, NULL);

-- 插入团队13的佣金记录
INSERT INTO commissions (id, user_id, order_id, camp_period_id, commission_type, tier, commission_amount, created_at, updated_at, remarks, customer_id, user_promoted_id)
VALUES
-- 团队长(user_id=61)的直接转化记录
(340, 61, 33001, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 292, NULL),
(341, 61, 33002, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 294, NULL),

-- 团队成员(user_id=62)的转化记录
(342, 62, 33003, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 296, NULL),
(343, 62, 33004, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 298, NULL),

-- 团队成员(user_id=63)的转化记录
(344, 63, 33005, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 300, NULL),

-- 团队成员(user_id=64)的转化记录
(345, 64, 33006, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 302, NULL),

-- 为团队成员的ambassador_conversion添加对应的团队长leader_team_conversion记录
-- user_id=62的记录对应的团队长记录
(346, 61, 33003, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 296, NULL),
(347, 61, 33004, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 298, NULL),

-- user_id=63的记录对应的团队长记录
(348, 61, 33005, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 300, NULL),

-- user_id=64的记录对应的团队长记录
(349, 61, 33006, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 302, NULL);

-- 插入团队14的佣金记录
INSERT INTO commissions (id, user_id, order_id, camp_period_id, commission_type, tier, commission_amount, created_at, updated_at, remarks, customer_id, user_promoted_id)
VALUES
-- 团队长(user_id=65)的直接转化记录
(350, 65, 34001, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 304, NULL),
(351, 65, 34002, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 306, NULL),
(352, 65, 34003, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 308, NULL),
(353, 65, 34004, 1001, 'ambassador_conversion', 'intermediate', 400.00, NOW(), NOW(), '中级转化', 310, NULL),
(354, 65, 34005, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 312, NULL),
(355, 65, 34006, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 314, NULL),

-- 团队成员(user_id=66)的转化记录
(356, 66, 34007, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 316, NULL),
(357, 66, 34008, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 318, NULL),
(358, 66, 34009, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 320, NULL),
(359, 66, 34010, 1001, 'ambassador_conversion', 'intermediate', 400.00, NOW(), NOW(), '中级转化', 322, NULL),

-- 团队成员(user_id=67)的转化记录
(360, 67, 34011, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 324, NULL),
(361, 67, 34012, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 326, NULL),
(362, 67, 34013, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 328, NULL),
(363, 67, 34014, 1001, 'ambassador_conversion', 'intermediate', 400.00, NOW(), NOW(), '中级转化', 330, NULL),
(364, 67, 34015, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 332, NULL),

-- 团队成员(user_id=68)的转化记录
(365, 68, 34016, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 334, NULL),
(366, 68, 34017, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 336, NULL),
(367, 68, 34018, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 338, NULL),
(368, 68, 34019, 1001, 'ambassador_conversion', 'intermediate', 400.00, NOW(), NOW(), '中级转化', 340, NULL),

-- 团队成员(user_id=69)的转化记录
(369, 69, 34020, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 342, NULL),
(370, 69, 34021, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 344, NULL),
(371, 69, 34022, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 346, NULL),
(372, 69, 34023, 1001, 'ambassador_conversion', 'intermediate', 400.00, NOW(), NOW(), '中级转化', 348, NULL),
(373, 69, 34024, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 350, NULL),

-- 为团队成员的ambassador_conversion添加对应的团队长leader_team_conversion记录
-- user_id=66的记录对应的团队长记录
(374, 65, 34007, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 316, NULL),
(375, 65, 34008, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 318, NULL),
(376, 65, 34009, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 320, NULL),
(377, 65, 34010, 1001, 'leader_team_conversion', 'intermediate', 40.00, NOW(), NOW(), '团队中级转化', 322, NULL),

-- user_id=67的记录对应的团队长记录
(378, 65, 34011, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 324, NULL),
(379, 65, 34012, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 326, NULL),
(380, 65, 34013, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 328, NULL),
(381, 65, 34014, 1001, 'leader_team_conversion', 'intermediate', 40.00, NOW(), NOW(), '团队中级转化', 330, NULL),
(382, 65, 34015, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 332, NULL),

-- user_id=68的记录对应的团队长记录
(383, 65, 34016, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 334, NULL),
(384, 65, 34017, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 336, NULL),
(385, 65, 34018, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 338, NULL),
(386, 65, 34019, 1001, 'leader_team_conversion', 'intermediate', 40.00, NOW(), NOW(), '团队中级转化', 340, NULL),

-- user_id=69的记录对应的团队长记录
(387, 65, 34020, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 342, NULL),
(388, 65, 34021, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 344, NULL),
(389, 65, 34022, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 346, NULL),
(390, 65, 34023, 1001, 'leader_team_conversion', 'intermediate', 40.00, NOW(), NOW(), '团队中级转化', 348, NULL),
(391, 65, 34024, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 350, NULL);

-- 插入团队15的佣金记录
INSERT INTO commissions (id, user_id, order_id, camp_period_id, commission_type, tier, commission_amount, created_at, updated_at, remarks, customer_id, user_promoted_id)
VALUES
-- 团队长(user_id=70)的直接转化记录
(392, 70, 35001, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 352, NULL),
(393, 70, 35002, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 354, NULL),

-- 团队成员(user_id=71)的转化记录
(394, 71, 35003, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 356, NULL),

-- 团队成员(user_id=72)的转化记录
(395, 72, 35004, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 358, NULL),

-- 团队成员(user_id=73)的转化记录
(396, 73, 35005, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 360, NULL),

-- 团队成员(user_id=74)的转化记录
(397, 74, 35006, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 362, NULL),

-- 为团队成员的ambassador_conversion添加对应的团队长leader_team_conversion记录
-- user_id=71的记录对应的团队长记录
(398, 70, 35003, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 356, NULL),

-- user_id=72的记录对应的团队长记录
(399, 70, 35004, 1001, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 358, NULL),

-- user_id=73的记录对应的团队长记录
(400, 70, 35005, 1001, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 360, NULL),

-- user_id=74的记录对应的团队长记录
(401, 70, 35006, 1001, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 362, NULL);


-- 插入独立推广大使的佣金记录
INSERT INTO commissions (id, user_id, order_id, camp_period_id, commission_type, tier, commission_amount, created_at, updated_at, remarks, customer_id, user_promoted_id)
VALUES
-- 林若彤(user_id=75)的转化记录
(402, 75, 40001, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 400, NULL),
(403, 75, 40002, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 402, NULL),
(404, 75, 40003, 1001, 'ambassador_conversion', 'intermediate', 400.00, NOW(), NOW(), '初级转化', 404, NULL),

-- 宋嘉宁(user_id=76)的转化记录
(405, 76, 40004, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 406, NULL),
(406, 76, 40005, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 408, NULL),

-- 杜思辰(user_id=77)的转化记录
(407, 77, 40006, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 410, NULL),
(408, 77, 40007, 1001, 'ambassador_conversion', 'intermediate', 400.00, NOW(), NOW(), '初级转化', 412, NULL),

-- 高梓琪(user_id=78)的转化记录
(409, 78, 40008, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 414, NULL),
(410, 78, 40009, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 416, NULL),

-- 叶嘉妍(user_id=79)的转化记录
(411, 79, 40010, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 418, NULL),
(412, 79, 40011, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 420, NULL),

-- 温思源(user_id=80)的转化记录
(413, 80, 40012, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 422, NULL),
(414, 80, 40013, 1001, 'ambassador_conversion', 'intermediate', 400.00, NOW(), NOW(), '初级转化', 424, NULL),

-- 顾子涵(user_id=81)的转化记录
(415, 81, 40014, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 426, NULL),
(416, 81, 40015, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 428, NULL),

-- 许梓萌(user_id=82)的转化记录
(417, 82, 40016, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 430, NULL),
(418, 82, 40017, 1001, 'ambassador_conversion', 'intermediate', 400.00, NOW(), NOW(), '中级转化', 432, NULL),

-- 韩嘉乐(user_id=83)的转化记录
(419, 83, 40018, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 434, NULL),
(420, 83, 40019, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 436, NULL),

-- 秦思妍(user_id=84)的转化记录
(421, 84, 40020, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 438, NULL),
(422, 84, 40021, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 440, NULL),

-- 罗梓涵(user_id=85)的转化记录
(423, 85, 40022, 1001, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 442, NULL),
(424, 85, 40023, 1001, 'ambassador_conversion', 'intermediate', 400.00, NOW(), NOW(), '初级转化', 444, NULL),

-- 毕嘉怡(user_id=86)的转化记录
(425, 86, 40024, 1001, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 446, NULL),
(426, 86, 40025, 1001, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 448, NULL);


-- 插入团队1在历史营期的佣金记录
INSERT INTO commissions (id, user_id, order_id, camp_period_id, commission_type, tier, commission_amount, created_at, updated_at, remarks, customer_id, user_promoted_id)
VALUES
-- 营期990：2025年春季基础英语线上训练营
-- 团队长(user_id=1)的直接转化记录
(427, 1, 50001, 990, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 480, NULL),
(428, 1, 50002, 990, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 481, NULL),
(429, 1, 50003, 990, 'ambassador_conversion', 'intermediate', 400.00, NOW(), NOW(), '中级转化', 482, NULL),

-- 团队成员(user_id=2)的转化记录和对应的团队长记录
(430, 2, 50004, 990, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 483, NULL),
(431, 1, 50004, 990, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 483, NULL),

(432, 2, 50005, 990, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 484, NULL),
(433, 1, 50005, 990, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 484, NULL),

-- 团队成员(user_id=3)的转化记录和对应的团队长记录
(434, 3, 50006, 990, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 485, NULL),
(435, 1, 50006, 990, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 485, NULL),

(436, 3, 50007, 990, 'ambassador_conversion', 'intermediate', 400.00, NOW(), NOW(), '中级转化', 486, NULL),
(437, 1, 50007, 990, 'leader_team_conversion', 'intermediate', 40.00, NOW(), NOW(), '团队中级转化', 486, NULL),

-- 营期991：2025年进阶口语线上训练营
-- 团队长(user_id=1)的直接转化记录
(438, 1, 50008, 991, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 487, NULL),
(439, 1, 50009, 991, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 488, NULL),

-- 团队成员(user_id=4)的转化记录和对应的团队长记录
(440, 4, 50010, 991, 'ambassador_conversion', 'junior', 150.00, NOW(), NOW(), '初级转化', 489, NULL),
(441, 1, 50010, 991, 'leader_team_conversion', 'junior', 15.00, NOW(), NOW(), '团队初级转化', 489, NULL),

(442, 4, 50011, 991, 'ambassador_conversion', 'intermediate', 400.00, NOW(), NOW(), '中级转化', 490, NULL),
(443, 1, 50011, 991, 'leader_team_conversion', 'intermediate', 40.00, NOW(), NOW(), '团队中级转化', 490, NULL),

-- 团队成员(user_id=5)的转化记录和对应的团队长记录
(444, 5, 50012, 991, 'ambassador_conversion', 'junior', 250.00, NOW(), NOW(), '初级转化', 491, NULL),
(445, 1, 50012, 991, 'leader_team_conversion', 'junior', 25.00, NOW(), NOW(), '团队初级转化', 491, NULL),

(446, 5, 50013, 991, 'ambassador_conversion', 'junior', 200.00, NOW(), NOW(), '初级转化', 492, NULL),
(447, 1, 50013, 991, 'leader_team_conversion', 'junior', 20.00, NOW(), NOW(), '团队初级转化', 492, NULL);

select * from customer_camp_periods;
select * from user_promotion_history;
UPDATE users SET password = '123456789' WHERE 1=1;

INSERT INTO users (id, username, password, email, phone, role, team_id, created_at, updated_at) 
VALUES (87, '冯安', '123456789', 'admin@system.com', '13800000087', 'admin', NULL, NOW(), NOW());
