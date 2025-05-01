CREATE TABLE teams (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT '团队ID（唯一标识）',
  team_name VARCHAR(100) NOT NULL COMMENT '团队名称',
  leader_id INT COMMENT '推广大使长的用户ID（关联users表）',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间（自动维护）',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间（自动维护）',
  
  
  -- 唯一性约束（团队名称不可重复）
  UNIQUE KEY uniq_team_name (team_name)
);

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT '用户ID（唯一标识）',
  username VARCHAR(50) NOT NULL COMMENT '用户名（全平台唯一）',
  password VARCHAR(255) NOT NULL COMMENT '密码（BCrypt加密存储）',
  email VARCHAR(100) COMMENT '电子邮箱（可选）',
  phone VARCHAR(20) COMMENT '电话号码（可选）',
  role ENUM('admin', 'ambassador', 'leader') NOT NULL COMMENT '用户角色：【管理员/推广大使/推广大使长】',
  team_id INT COMMENT '所属团队ID（关联teams表，可选）',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间（自动维护）',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间（自动维护）',
  
  -- 唯一性约束
  UNIQUE KEY uniq_username (username),
  
  

);




ALTER TABLE users 
ADD FOREIGN KEY (team_id) REFERENCES teams(id) ON DELETE SET NULL;

ALTER TABLE teams 
ADD FOREIGN KEY (leader_id) REFERENCES users(id) ON DELETE SET NULL;

ALTER TABLE teams 
ADD CONSTRAINT chk_leader_role 
CHECK (EXISTS(SELECT 1 FROM users WHERE id = leader_id AND role = 'leader'));


CREATE TABLE customers (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT '客户ID（唯一标识）',
  name VARCHAR(100) NOT NULL COMMENT '客户姓名',
  phone VARCHAR(20) COMMENT '电话号码（可选，唯一）',
  email VARCHAR(100) COMMENT '电子邮箱（可选）',
  status ENUM('potential', 'converted') NOT NULL DEFAULT 'potential' COMMENT '客户状态：【潜在客户/已转化客户】',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间（自动维护）',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间（自动维护）',
  
  -- 唯一性约束
  UNIQUE KEY uniq_phone (phone)
);




CREATE TABLE camp_periods (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT '营期ID（唯一标识）',
  start_date DATETIME NOT NULL COMMENT '营期开始时间',
  end_date DATETIME NOT NULL COMMENT '营期结束时间',
  description TEXT COMMENT '营期描述或备注（可选）',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间（自动维护）',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间（自动维护）',
  
  -- 确保结束时间晚于开始时间
  CONSTRAINT chk_date_range CHECK (end_date > start_date)
);


CREATE TABLE customer_camp_periods (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT '记录ID（唯一标识）',
  customer_id INT NOT NULL COMMENT '客户ID（关联customers表）',
  camp_period_id INT NOT NULL COMMENT '营期ID（关联camp_periods表）',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间（自动维护）',
  
  -- 外键约束
  FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
  FOREIGN KEY (camp_period_id) REFERENCES camp_periods(id) ON DELETE CASCADE,
  
  -- 唯一性约束（防止重复关联）
  UNIQUE KEY uniq_customer_camp (customer_id, camp_period_id)
);





CREATE TABLE commissions (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT '佣金记录ID（唯一标识）',
  user_id INT NOT NULL COMMENT '推广大使或推广大使长ID（关联users表）',
  order_id INT NOT NULL COMMENT '外部系统订单ID（不可重复关联，可以为空）',
  camp_period_id INT NOT NULL COMMENT '营期ID（关联camp_periods表，不可为空）',
  commission_type ENUM(
    'ambassador_conversion', 
    'leader_team_conversion', 
    'promotion_bonus_fixed', 
    'promotion_bonus_percentage'
  ) NOT NULL COMMENT '佣金类型：【直接推广/团队推广/晋升固定奖励/晋升比例奖励】',
  tier ENUM('junior', 'intermediate', 'senior') NULL COMMENT '分级层级（仅转化佣金适用）',
  commission_amount DECIMAL(10,2) NOT NULL COMMENT '实际佣金金额（必须大于0）',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间（自动维护）',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间（自动维护）',
  remarks VARCHAR(255) COMMENT '备注信息（如佣金计算规则）',
 customer_id INT YES,
user_promoted_id INT YES,

  -- 外键约束
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (camp_period_id) REFERENCES camp_periods(id) ON DELETE RESTRICT,
  FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE RESTRICT,

  -- 数据完整性约束
  CONSTRAINT chk_amount CHECK (commission_amount > 0),
  CONSTRAINT chk_tier_required CHECK (
    (commission_type IN ('ambassador_conversion', 'leader_team_conversion') AND tier IS NOT NULL) OR
    (commission_type IN ('promotion_bonus_fixed', 'promotion_bonus_percentage') AND tier IS NULL)
  ),

  -- 唯一性约束（同一订单只能关联一次）
  UNIQUE KEY uniq_order (order_id)
);






CREATE TABLE commission_distribution (
  id INT AUTO_INCREMENT PRIMARY KEY COMMENT '唯一标识',
  leader_id INT NOT NULL COMMENT '推广大使长ID（关联users表）',
  sub_leader_id INT NOT NULL COMMENT '被晋升大使长ID（关联users表）',
  distribution_mode ENUM('fixed', 'percentage') NOT NULL COMMENT '分成方式：【固定奖励/比例分成】',
  fixed_amount DECIMAL(10,2) COMMENT '固定金额（仅当distribution_mode=fixed时必填）',
  percentage DECIMAL(5,2) COMMENT '分成比例（如5.00表示5%，仅当distribution_mode=percentage时必填）',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间（自动维护）',

  -- 外键约束
  FOREIGN KEY (leader_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (sub_leader_id) REFERENCES users(id) ON DELETE CASCADE,

  -- 数据完整性约束
  CONSTRAINT chk_mode_amount CHECK (
    (distribution_mode = 'fixed' AND fixed_amount IS NOT NULL AND percentage IS NULL) OR
    (distribution_mode = 'percentage' AND percentage IS NOT NULL AND fixed_amount IS NULL)
  ),
  CONSTRAINT chk_percentage_range CHECK (
    percentage IS NULL OR (percentage BETWEEN 0.00 AND 100.00)
  ),
  CONSTRAINT chk_fixed_positive CHECK (
    fixed_amount IS NULL OR fixed_amount > 0
  )
);


CREATE TABLE user_promotion_history (
  user_id INT NOT NULL COMMENT '用户ID',
  camp_period_id INT NOT NULL COMMENT '营期ID',
  success_count INT DEFAULT 0 COMMENT '成功推广数',
  total_commission DECIMAL(10,2) DEFAULT 0.00 COMMENT '总佣金',
  PRIMARY KEY (user_id, camp_period_id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (camp_period_id) REFERENCES camp_periods(id)
) COMMENT='用户历史推广汇总表';


CREATE TABLE promotion_applications (
    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '申请ID',
    user_id INT NOT NULL COMMENT '申请用户ID',
    status ENUM('PENDING', 'APPROVED', 'REJECTED') NOT NULL DEFAULT 'PENDING' COMMENT '申请状态',
    expected_team_name VARCHAR(100) NOT NULL COMMENT '预计晋升时间',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    remarks VARCHAR(255) COMMENT '备注信息',
    
    -- 外键约束
    FOREIGN KEY (user_id) REFERENCES users(id),
    
    -- 索引
    INDEX idx_user_status (user_id, status)
) COMMENT='晋升申请表';


DELIMITER $$
CREATE TRIGGER update_promotion_history 
AFTER INSERT ON commissions
FOR EACH ROW
BEGIN
  IF NEW.commission_type = 'ambassador_conversion' THEN
    INSERT INTO user_promotion_history 
      (user_id, camp_period_id, success_count, total_commission)
    VALUES 
      (NEW.user_id, NEW.camp_period_id, 1, NEW.commission_amount)
    ON DUPLICATE KEY UPDATE
      success_count = success_count + 1,
      total_commission = total_commission + NEW.commission_amount;
  END IF;
END
$$
DELIMITER ;



DELIMITER $$
CREATE TRIGGER trg_commissions_before_insert 
BEFORE INSERT ON commissions 
FOR EACH ROW
BEGIN
  -- 新增规则：字段必填性校验
  CASE 
    WHEN NEW.commission_type IN ('ambassador_conversion', 'leader_team_conversion') THEN
      IF NEW.tier IS NULL OR NEW.customer_id IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'ambassador_conversion/leader_team_conversion 类型必须填写 tier 和 customer_id';
      END IF;
      
    WHEN NEW.commission_type IN ('promotion_bonus_fixed', 'promotion_bonus_percentage') THEN
      IF NEW.user_promoted_id IS NULL THEN
        SIGNAL SQLSTATE '45001' 
        SET MESSAGE_TEXT = 'promotion_bonus_fixed/promotion_bonus_percentage 类型必须填写 user_promoted_id';
      END IF;
  END CASE;

  -- 保留原有逻辑（仅对转化类佣金生效）
  IF NEW.commission_type IN ('ambassador_conversion', 'leader_team_conversion') THEN
    -- 原客户有效性校验
    IF NOT EXISTS (
      SELECT 1 FROM customers 
      WHERE id = NEW.customer_id
    ) THEN
      SIGNAL SQLSTATE '45002' 
      SET MESSAGE_TEXT = '客户ID无效';
    END IF;

    -- 原防重复关联逻辑
    IF EXISTS (
      SELECT 1 FROM customer_camp_periods 
      WHERE customer_id = NEW.customer_id 
        AND camp_period_id = NEW.camp_period_id
    ) THEN
      SIGNAL SQLSTATE '45003' 
      SET MESSAGE_TEXT = '客户已关联当前营期';
    END IF;

    -- 原关联记录插入
    INSERT INTO customer_camp_periods (customer_id, camp_period_id)
    VALUES (NEW.customer_id, NEW.camp_period_id);
  END IF;
END
$$
DELIMITER ;


DELIMITER $$
CREATE TRIGGER trg_users_role_team_check BEFORE INSERT ON users
FOR EACH ROW
BEGIN
  -- 验证管理员不得关联团队
  IF NEW.role = 'admin' AND NEW.team_id IS NOT NULL THEN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = '管理员不得关联团队';
  END IF;

  -- 验证大使长必须关联团队
  IF NEW.role = 'leader' AND NEW.team_id IS NULL THEN
    SIGNAL SQLSTATE '45001' 
    SET MESSAGE_TEXT = '推广大使长必须关联团队';
  END IF;

  -- 验证推广大司的团队有效性（如果指定了团队）
  IF NEW.role = 'ambassador' AND NEW.team_id IS NOT NULL THEN
    IF NOT EXISTS (SELECT 1 FROM teams WHERE id = NEW.team_id) THEN
      SIGNAL SQLSTATE '45002' 
      SET MESSAGE_TEXT = '推广大司的团队ID无效';
    END IF;
  END IF;
END
$$
DELIMITER ;

CREATE TABLE camp_period_stats (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    camp_period_id INT NOT NULL UNIQUE,
    total_conversions INT NOT NULL DEFAULT 0,
    total_commission DECIMAL(12, 2) NOT NULL DEFAULT 0,
    active_ambassador_count INT NOT NULL DEFAULT 0,
    conversion_rate DECIMAL(5, 2) NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE PROCEDURE update_camp_period_stats()
BEGIN
    -- 声明变量
    DECLARE done INT DEFAULT FALSE;
    DECLARE camp_id INT;
    DECLARE cur CURSOR FOR SELECT id FROM camp_periods;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- 打开游标
    OPEN cur;
    
    read_loop: LOOP
        -- 获取下一个营期ID
        FETCH cur INTO camp_id;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- 更新或插入统计数据
        INSERT INTO camp_period_stats 
            (camp_period_id, total_conversions, total_commission, active_ambassador_count, conversion_rate)
        SELECT 
            cp.id,
            COALESCE(SUM(uph.success_count), 0) as total_conversions,
            COALESCE(SUM(uph.total_commission), 0) as total_commission,
            COUNT(DISTINCT uph.user_id) as active_ambassador_count,
            (COUNT(DISTINCT CASE WHEN uph.success_count > 0 THEN uph.user_id END) * 100.0 / 
             NULLIF(COUNT(DISTINCT uph.user_id), 0)) as conversion_rate
        FROM 
            camp_periods cp
            LEFT JOIN user_promotion_history uph ON cp.id = uph.camp_period_id
        WHERE 
            cp.id = camp_id
        GROUP BY 
            cp.id
        ON DUPLICATE KEY UPDATE 
            total_conversions = VALUES(total_conversions),
            total_commission = VALUES(total_commission),
            active_ambassador_count = VALUES(active_ambassador_count),
            conversion_rate = VALUES(conversion_rate),
            updated_at = CURRENT_TIMESTAMP;
            
    END LOOP;
    
    -- 关闭游标
    CLOSE cur;
    
    -- 记录日志
    INSERT INTO system_logs (log_type, message) 
    VALUES ('STATS_UPDATE', CONCAT('Camp period stats updated at ', NOW()));
END$$

DELIMITER ;


-- 启用事件调度器
SET GLOBAL event_scheduler = ON;

-- 创建每日凌晨2点执行的事件
CREATE EVENT IF NOT EXISTS event_update_camp_stats
ON SCHEDULE EVERY 1 DAY
STARTS (TIMESTAMP(CURRENT_DATE) + INTERVAL 2 HOUR)
DO
    CALL update_camp_period_stats();
    
DELIMITER $$

-- 插入触发器：当有新的推广记录时更新统计
CREATE TRIGGER trg_after_insert_promotion
AFTER INSERT ON user_promotion_history
FOR EACH ROW
BEGIN
    -- 插入或更新统计记录
    INSERT INTO camp_period_stats 
        (camp_period_id, total_conversions, total_commission, active_ambassador_count, conversion_rate)
    SELECT 
        NEW.camp_period_id,
        SUM(uph.success_count) as total_conversions,
        SUM(uph.total_commission) as total_commission,
        COUNT(DISTINCT uph.user_id) as active_ambassador_count,
        (COUNT(DISTINCT CASE WHEN uph.success_count > 0 THEN uph.user_id END) * 100.0 / 
         NULLIF(COUNT(DISTINCT uph.user_id), 0)) as conversion_rate
    FROM 
        user_promotion_history uph
    WHERE 
        uph.camp_period_id = NEW.camp_period_id
    GROUP BY 
        uph.camp_period_id
    ON DUPLICATE KEY UPDATE 
        total_conversions = VALUES(total_conversions),
        total_commission = VALUES(total_commission),
        active_ambassador_count = VALUES(active_ambassador_count),
        conversion_rate = VALUES(conversion_rate),
        updated_at = CURRENT_TIMESTAMP;
END$$

-- 更新触发器：当推广记录更新时同步更新统计
CREATE TRIGGER trg_after_update_promotion
AFTER UPDATE ON user_promotion_history
FOR EACH ROW
BEGIN
    -- 如果营期ID发生了变化，需要更新两个营期的统计
    IF NEW.camp_period_id <> OLD.camp_period_id THEN
        -- 更新旧营期统计
        INSERT INTO camp_period_stats 
            (camp_period_id, total_conversions, total_commission, active_ambassador_count, conversion_rate)
        SELECT 
            OLD.camp_period_id,
            SUM(uph.success_count) as total_conversions,
            SUM(uph.total_commission) as total_commission,
            COUNT(DISTINCT uph.user_id) as active_ambassador_count,
            (COUNT(DISTINCT CASE WHEN uph.success_count > 0 THEN uph.user_id END) * 100.0 / 
             NULLIF(COUNT(DISTINCT uph.user_id), 0)) as conversion_rate
        FROM 
            user_promotion_history uph
        WHERE 
            uph.camp_period_id = OLD.camp_period_id
        GROUP BY 
            uph.camp_period_id
        ON DUPLICATE KEY UPDATE 
            total_conversions = VALUES(total_conversions),
            total_commission = VALUES(total_commission),
            active_ambassador_count = VALUES(active_ambassador_count),
            conversion_rate = VALUES(conversion_rate),
            updated_at = CURRENT_TIMESTAMP;
    END IF;
    
    -- 更新新营期统计
    INSERT INTO camp_period_stats 
        (camp_period_id, total_conversions, total_commission, active_ambassador_count, conversion_rate)
    SELECT 
        NEW.camp_period_id,
        SUM(uph.success_count) as total_conversions,
        SUM(uph.total_commission) as total_commission,
        COUNT(DISTINCT uph.user_id) as active_ambassador_count,
        (COUNT(DISTINCT CASE WHEN uph.success_count > 0 THEN uph.user_id END) * 100.0 / 
         NULLIF(COUNT(DISTINCT uph.user_id), 0)) as conversion_rate
    FROM 
        user_promotion_history uph
    WHERE 
        uph.camp_period_id = NEW.camp_period_id
    GROUP BY 
        uph.camp_period_id
    ON DUPLICATE KEY UPDATE 
        total_conversions = VALUES(total_conversions),
        total_commission = VALUES(total_commission),
        active_ambassador_count = VALUES(active_ambassador_count),
        conversion_rate = VALUES(conversion_rate),
        updated_at = CURRENT_TIMESTAMP;
END$$

-- 删除触发器：当推广记录删除时更新统计
CREATE TRIGGER trg_after_delete_promotion
AFTER DELETE ON user_promotion_history
FOR EACH ROW
BEGIN
    -- 更新相关营期统计
    INSERT INTO camp_period_stats 
        (camp_period_id, total_conversions, total_commission, active_ambassador_count, conversion_rate)
    SELECT 
        OLD.camp_period_id,
        SUM(uph.success_count) as total_conversions,
        SUM(uph.total_commission) as total_commission,
        COUNT(DISTINCT uph.user_id) as active_ambassador_count,
        (COUNT(DISTINCT CASE WHEN uph.success_count > 0 THEN uph.user_id END) * 100.0 / 
         NULLIF(COUNT(DISTINCT uph.user_id), 0)) as conversion_rate
    FROM 
        user_promotion_history uph
    WHERE 
        uph.camp_period_id = OLD.camp_period_id
    GROUP BY 
        uph.camp_period_id
    ON DUPLICATE KEY UPDATE 
        total_conversions = VALUES(total_conversions),
        total_commission = VALUES(total_commission),
        active_ambassador_count = VALUES(active_ambassador_count),
        conversion_rate = VALUES(conversion_rate),
        updated_at = CURRENT_TIMESTAMP;
END$$

DELIMITER ;




