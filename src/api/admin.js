import request from '@/utils/request';

/**
 * 获取推广数据概览
 * @param {number} campId - 营期ID
 * @returns {Promise}
 */
export function getDashboardOverview(campId = 1001) {
    console.log('调用推广数据概览API，参数:', { camp_id: campId });
    return request({
        url: '/api/admin/dashboard/overview',
        method: 'get',
        params: { camp_id: campId }
    });
}

/**
 * 获取推广之星数据
 * @param {number} campId - 营期ID
 * @returns {Promise}
 */
export function getMarketingStars(campId = 1001) {
    return request({
        url: '/api/admin/dashboard/marketing_stars',
        method: 'get',
        params: { camp_id: campId }
    });
}

/**
 * 获取转化趋势分析
 * @param {number} currentId - 当前营期ID
 * @param {number} limit - 返回营期数量
 * @returns {Promise}
 */
export function getConversionTrends(currentId = 1001, limit = 10) {
    console.log('调用转化趋势分析API，参数:', { current_id: currentId, limit });
    return request({
        url: '/api/admin/dashboard/conversion_camp_trends',
        method: 'get',
        params: { current_id: currentId, limit }
    });
}

/**
 * 获取佣金分配分析
 * @param {string} dimension - 数据维度
 * @param {number} campId - 营期ID
 * @returns {Promise}
 */
export function getCommissionDistribution(dimension = 'all', campId = 1001) {
    return request({
        url: '/api/admin/dashboard/commission_Distribution',
        method: 'get',
        params: { dimension, camp_id: campId }
    });
}

/**
 * 获取推广大使团队列表
 * @param {Object} params - 查询参数
 * @returns {Promise}
 */
export function getTeamList(params) {
    return request({
        url: '/api/admin/team/list',
        method: 'get',
        params
    });
}

/**
 * 获取推广大使团队详情
 * @param {number} id - 团队ID
 * @returns {Promise}
 */
export function getTeamDetail(id) {
    return request({
        url: `/api/admin/team/${id}`,
        method: 'get'
    });
}

/**
 * 添加推广大使团队
 * @param {Object} data - 团队数据
 * @returns {Promise}
 */
export function addTeamAmbassador(data) {
    return request({
        url: '/api/admin/team/add',
        method: 'post',
        data
    });
}

/**
 * 删除推广大使团队
 * @param {number} id - 团队ID
 * @returns {Promise}
 */
export function deleteTeam(id) {
    return request({
        url: `/api/admin/team/delete/${id}`,
        method: 'delete'
    });
}

/**
 * 获取团队成员列表
 * @param {number} teamId - 团队ID
 * @returns {Promise}
 */
export function getTeamMembers(teamId) {
    return request({
        url: `/api/admin/ambassadors/teams/${teamId}/members`,
        method: 'get'
    });
}

/**
 * 添加团队成员
 * @param {number} teamId - 团队ID
 * @param {Object} memberData - 成员信息
 * @returns {Promise}
 */
export function addTeamMember(teamId, memberData) {
    return request({
        url: `/api/admin/team/${teamId}/members`,
        method: 'post',
        data: memberData
    });
}

/**
 * 删除团队成员
 * @param {number} teamId - 团队ID
 * @param {number} userId - 用户ID
 * @returns {Promise}
 */
export function deleteTeamMember(teamId, userId) {
    return request({
        url: `/api/admin/team/${teamId}/members/${userId}`,
        method: 'delete'
    });
}

/**
 * 获取团队佣金设置
 * @param {number} teamId - 团队ID
 * @returns {Promise}
 */
export function getTeamCommissionSettings(teamId) {
    return request({
        url: `/api/admin/ambassadors/teams/${teamId}/commission-settings`,
        method: 'get'
    });
}

/**
 * 更新团队佣金设置
 * @param {number} teamId - 团队ID
 * @param {Object} settings - 佣金设置数据
 * @returns {Promise}
 */
export function updateTeamCommissionSettings(teamId, settings) {
    return request({
        url: `/api/admin/ambassadors/teams/${teamId}/commission-settings`,
        method: 'put',
        data: settings
    });
}

/**
 * 获取团队佣金结算历史
 * @param {number} teamId - 团队ID
 * @returns {Promise}
 */
export function getTeamCommissionHistory(teamId) {
    return request({
        url: `/api/admin/ambassadors/teams/${teamId}/commission-history`,
        method: 'get'
    });
}

/**
 * 获取独立推广大使列表
 * @param {Object} params - 查询参数
 * @returns {Promise}
 */
export function getIndependentAmbassadorsList(params) {
    console.log('调用独立推广大使列表API，参数:', params);
    // 确保参数符合API文档规范
    const apiParams = {
        page: params.page || 1,
        size: params.size || 10,
        sort_field: params.sort_field || 'id',
        sort_order: params.sort_order || 'desc'
    };

    // 如果有关键词，添加到参数中
    if (params.keyword) {
        apiParams.keyword = params.keyword;
    }

    // 直接请求后端API
    return request({
        url: '/api/admin/ambassadors/independent/list',
        method: 'get',
        params: apiParams
    });
}

/**
 * 获取独立推广大使详情
 * @param {number} id - 推广大使ID
 * @returns {Promise}
 */
export function getIndependentAmbassadorDetail(id) {
    return request({
        url: `/api/admin/ambassadors/independent/details/${id}`,
        method: 'get'
    });
}

/**
 * 添加独立推广大使
 * @param {Object} data - 推广大使数据
 * @returns {Promise}
 */
export function addIndependentAmbassador(data) {
    return request({
        url: '/api/admin/ambassadors/independent/add',
        method: 'post',
        data
    });
}

/**
 * 更新独立推广大使信息
 * @param {number} id - 推广大使ID
 * @param {Object} data - 推广大使数据
 * @returns {Promise}
 */
export function updateIndependentAmbassador(id, data) {
    return request({
        url: `/api/admin/ambassadors/independent/update/${id}`,
        method: 'put',
        data
    });
}

/**
 * 删除独立推广大使
 * @param {number} id - 推广大使ID
 * @returns {Promise}
 */
export function deleteIndependentAmbassador(id) {
    return request({
        url: `/api/admin/ambassadors/independent/delete/${id}`,
        method: 'delete'
    });
}

/**
 * 获取未审批晋升申请列表
 * @param {Object} params - 查询参数
 * @returns {Promise}
 */
export function getPendingPromotionApplications(params) {
    return request({
        url: '/api/admin/team/promotion-applications/pending',
        method: 'get',
        params
    });
}

/**
 * 审批晋升申请
 * @param {number} id - 申请ID
 * @param {string} action - 审批动作：approve(批准) 或 reject(拒绝)
 * @returns {Promise}
 */
export function approvePromotionApplication(id, action) {
    return request({
        url: `/api/admin/team/promotion-applications/${id}`,
        method: 'post',
        data: { action }
    });
}

/**
 * 获取团队历史转化数据
 * @param {number} teamId - 团队ID
 * @param {number} limit - 返回的历史数据点数量
 * @returns {Promise}
 */
export function getTeamConversionHistory(teamId, limit = 6) {
    return request({
        url: `/api/admin/team/${teamId}/conversion-history`,
        method: 'get',
        params: { limit }
    });
}

/**
 * 获取团队内成员转化排名
 * @param {number} teamId - 团队ID
 * @param {Object} options - 选项参数
 * @param {number} options.limit - 返回的排名数量，默认为5
 * @returns {Promise}
 */
export function getTeamMemberRanking(teamId, options = {}) {
    return request({
        url: `/api/admin/team/${teamId}/member-ranking`,
        method: 'get',
        params: {
            limit: options.limit || 5
        }
    });
}

/**
 * 获取团队推广大使长个人佣金明细数据
 * @param {number} teamId - 团队ID
 * @param {number} campId - 营期ID，默认为1001
 * @returns {Promise}
 */
export function getTeamLeaderCommissions(teamId, campId = 1001) {
    return request({
        url: `/api/admin/team/${teamId}/leader_commissions`,
        method: 'get',
        params: { camp_id: campId }
    });
}

/**
 * 获取团队成员佣金明细
 * @param {number} teamId - 团队ID
 * @param {number} userId - 用户ID（团队成员）
 * @param {number} campId - 营期ID，默认为1001
 * @returns {Promise}
 */
export function getTeamMemberCommissions(teamId, userId, campId = 1001) {
    return request({
        url: `/api/admin/team/${teamId}/members/${userId}/commissions`,
        method: 'get',
        params: { camp_id: campId }
    });
}

/**
 * 获取客户列表
 * @param {Object} params - 查询参数
 * @returns {Promise}
 */
export function getCustomerList(params) {
    // 确保参数符合API文档规范
    const apiParams = {
        page: params.page || 1,
        size: params.size || 10,
        sort_field: params.sort_field || 'created_at',
        sort_order: params.sort_order || 'desc'
    };

    // 添加可选参数
    if (params.keyword) apiParams.keyword = params.keyword;
    if (params.status) apiParams.status = params.status;
    if (params.team_id) apiParams.team_id = params.team_id;

    return request({
        url: '/api/admin/customers',
        method: 'get',
        params: apiParams
    });
}

/**
 * 获取客户详情
 * @param {number} id - 客户ID
 * @returns {Promise}
 */
export function getCustomerDetail(id) {
    return request({
        url: `/api/admin/customers/${id}`,
        method: 'get'
    });
}

/**
 * 获取客户数据概览
 * @param {number} campId - 营期ID，不指定则查询全部
 * @returns {Promise}
 */
export function getCustomerStatistics(campId = null) {
    const params = {};
    if (campId) params.camp_id = campId;

    return request({
        url: '/api/admin/customers/statistics/overview',
        method: 'get',
        params
    });
} 