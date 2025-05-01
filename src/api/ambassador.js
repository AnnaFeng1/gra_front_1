import request from '@/utils/request';

// 获取用户基础信息
export function getUserInfo() {
    return request({
        url: '/api/ambassador/info',
        method: 'get'
    }).then(res => {
        // 确保返回数据有正确的结构，即使后端出错
        if (!res.data) {
            console.warn('用户信息接口返回数据为空，使用默认值');
            res.data = { username: '用户', role: 'ambassador', team_name: '' };
        }
        return res;
    }).catch(error => {
        console.error('获取用户信息失败', error);
        // 返回格式化的错误结果，前端可以处理
        return {
            code: 0,
            msg: error.message || '获取用户信息失败',
            data: { username: '用户', role: 'ambassador', team_name: '' }
        };
    });
}

// 获取成长进度
export function getProgress() {
    return request({
        url: '/api/ambassador/progress',
        method: 'get'
    });
}

// 获取当前营期
export function getCurrentCamp(campId = 1001) {
    return request({
        url: '/api/ambassador/camp/current',
        method: 'get',
        params: { camp_id: campId }
    });
}

// 获取推广层级
export function getPromotionLevel(campPeriodId) {
    return request({
        url: '/api/ambassador/promotion/level',
        method: 'get',
        params: { camp_period_id: campPeriodId }
    });
}

// 获取成功推广数
export function getSuccessCount(campPeriodId) {
    return request({
        url: '/api/ambassador/camp/count',
        method: 'get',
        params: { camp_period_id: campPeriodId }
    });
}

// 获取佣金总额
export function getCommissionTotal(campPeriodId) {
    return request({
        url: '/api/ambassador/commission/total',
        method: 'get',
        params: { camp_period_id: campPeriodId }
    });
}

// 提交晋升申请
export function applyPromotion() {
    return request({
        url: '/api/ambassador/promotion/apply',
        method: 'post'
    });
}

// 离开团队
export function leaveTeam() {
    return request({
        url: '/api/ambassador/team/leave',
        method: 'post'
    });
}

/**
 * 获取佣金明细
 * @param {number} campPeriodId - 营期ID
 */
export function getCommissionDetail(campPeriodId) {
    return request({
        url: '/api/ambassador/commission/detail',
        method: 'get',
        params: {
            camp_period_id: campPeriodId
        }
    });
}

/**
 * 获取指定营期信息
 * @param {number} campPeriodId - 营期ID
 */
export function getCampPeriodById(campPeriodId) {
    return request({
        url: '/api/ambassador/camp/current',
        method: 'get',
        params: {
            camp_id: campPeriodId
        }
    });
}