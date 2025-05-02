import request from '@/utils/request';

/**
 * 获取推广大使长个人业绩统计
 * @param {number} campId - 营期ID，默认为1001
 * @returns {Promise}
 */
export function getLeaderPerformanceStatistics(campId = 1001) {
    return request({
        url: '/api/leader/performance/statistics',
        method: 'get',
        params: {
            camp_id: campId
        }
    });
}

/**
 * 获取团队总览信息
 * @param {number} campId - 营期ID，默认为1001
 * @returns {Promise}
 */
export function getTeamOverview(campId = 1001) {
    return request({
        url: '/api/leader/team/overview',
        method: 'get',
        params: {
            camp_id: campId
        }
    });
}

/**
 * 获取目标营期团队成员数据
 * @param {number} campId - 营期ID，默认为1001
 * @returns {Promise}
 */
export function getTeamMembers(campId = 1001) {
    return request({
        url: '/api/leader/team/member',
        method: 'get',
        params: {
            camp_id: campId
        }
    });
}

/**
 * 添加团队成员
 * @param {Object} data - 成员信息，包含username, email, phone等
 * @returns {Promise}
 */
export function addTeamMember(data) {
    return request({
        url: '/api/leader/team/members',
        method: 'post',
        data
    });
}

/**
 * 移除团队成员
 * @param {number} userId - 用户ID
 * @returns {Promise}
 */
export function removeTeamMember(userId) {
    return request({
        url: `/api/leader/team/members/${userId}`,
        method: 'delete'
    });
}

/**
 * 获取团队业绩统计
 * @param {number} campId - 营期ID，默认为1001
 * @returns {Promise}
 */
export function getTeamPerformanceStatistics(campId = 1001) {
    return request({
        url: '/api/leader/team/performance',
        method: 'get',
        params: {
            camp_id: campId
        }
    });
}

/**
 * 获取推广大使长个人佣金明细数据
 * @param {number} campId - 营期ID，默认为1001
 * @returns {Promise}
 */
export function getLeaderCommissions(campId = 1001) {
    return request({
        url: '/api/leader/commissions',
        method: 'get',
        params: {
            camp_id: campId
        }
    });
}

/**
 * 查看团队中成员的佣金明细
 * @param {number} campId - 营期ID，默认为1001
 * @param {number} userId - 团队成员ID
 * @returns {Promise}
 */
export function getMemberCommissions(campId = 1001, userId) {
    return request({
        url: '/api/leader/team/member-commissions',
        method: 'get',
        params: {
            camp_id: campId,
            user_id: userId
        }
    });
}

/**
 * 获取客户信息表单
 * @param {Object} params - 查询参数
 * @param {number} [params.page=1] - 当前页码
 * @param {number} [params.size=10] - 每页记录数，最大值50
 * @param {string} [params.keyword] - 搜索关键词（姓名/电话/邮箱）
 * @param {string} [params.sort='created_at'] - 排序字段，可选值：id, name, created_at
 * @param {string} [params.order='desc'] - 排序方式，可选值：asc(升序), desc(降序)
 * @param {boolean} [params.team_only=false] - 是否只显示团队相关客户
 * @returns {Promise}
 */
export function getCustomers(params = {}) {
    return request({
        url: '/api/leader/customer',
        method: 'get',
        params
    });
} 