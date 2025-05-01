package com.marketing.ambassador.service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * 佣金相关服务接口
 */
public interface CommissionService {
    
    /**
     * 获取用户在指定营期的佣金总额
     * 
     * @param userId 用户ID
     * @param campPeriodId 营期ID
     * @return 佣金总额
     */
    BigDecimal getCommissionTotal(Integer userId, Integer campPeriodId);
    
    /**
     * 获取用户在指定营期的佣金明细列表
     * 
     * @param userId 用户ID
     * @param campPeriodId 营期ID
     * @return 佣金明细列表
     */
    List<Map<String, Object>> getCommissionDetailList(Integer userId, Integer campPeriodId);
} 