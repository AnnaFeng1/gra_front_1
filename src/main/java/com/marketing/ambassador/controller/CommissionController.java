package com.marketing.ambassador.controller;

import com.marketing.ambassador.common.ApiResponse;
import com.marketing.ambassador.service.CommissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/ambassador")
public class CommissionController {

    @Autowired
    private CommissionService commissionService;

    /**
     * 获取佣金总额
     */
    @GetMapping("/commission/total")
    public ApiResponse getCommissionTotal(HttpServletRequest request, @RequestParam("camp_period_id") Integer campPeriodId) {
        try {
            // 从请求中获取当前登录用户ID
            Integer userId = (Integer) request.getAttribute("userId");
            if (userId == null) {
                return ApiResponse.error("未登录或登录已过期");
            }

            // 获取佣金总额
            BigDecimal totalAmount = commissionService.getCommissionTotal(userId, campPeriodId);
            
            // 构建返回数据
            Map<String, String> data = new HashMap<>();
            data.put("total_amount", "￥" + totalAmount.toString());
            
            return ApiResponse.success(data);
        } catch (Exception e) {
            e.printStackTrace();
            return ApiResponse.error("获取佣金总额失败: " + e.getMessage());
        }
    }

    /**
     * 获取佣金明细
     */
    @GetMapping("/commission/detail")
    public ApiResponse getCommissionDetail(HttpServletRequest request, @RequestParam("camp_period_id") Integer campPeriodId) {
        try {
            // 从请求中获取当前登录用户ID
            Integer userId = (Integer) request.getAttribute("userId");
            if (userId == null) {
                return ApiResponse.error("未登录或登录已过期");
            }

            // 获取佣金明细列表 - 修改为仅使用commissions表和customers表
            List<Map<String, Object>> details = commissionService.getCommissionDetailList(userId, campPeriodId);
            BigDecimal totalCommission = commissionService.getCommissionTotal(userId, campPeriodId);
            
            // 构建返回数据
            Map<String, Object> data = new HashMap<>();
            data.put("commission_type", "直接转化佣金");
            data.put("details", details);
            data.put("total_commission", totalCommission);
            
            return ApiResponse.success(data);
        } catch (Exception e) {
            e.printStackTrace();
            return ApiResponse.error("获取佣金明细失败: " + e.getMessage());
        }
    }
} 