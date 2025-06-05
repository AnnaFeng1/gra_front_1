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
    // 添加模拟数据
    // 如果环境变量是开发环境或者URL包含mock参数，返回模拟数据
    if (process.env.NODE_ENV === 'development' || window.location.href.includes('mock=true')) {
        console.log('使用模拟的晋升申请列表数据');

        // 模拟数据
        const mockData = generateMockPromotionApplications(params);

        // 返回Promise以模拟API调用
        return Promise.resolve({
            code: 1,
            data: mockData,
            msg: '获取成功(模拟数据)'
        });
    }

    // 正常API调用
    return request({
        url: '/api/admin/team/promotion-applications/pending',
        method: 'get',
        params
    });
}

/**
 * 生成模拟的晋升申请数据
 * @param {Object} params - 查询参数
 * @returns {Object} 模拟数据
 */
function generateMockPromotionApplications(params) {
    const { page = 1, size = 10, keyword = '', sort_field = 'created_at', sort_order = 'desc' } = params;

    // 模拟晋升申请列表
    const applications = [
        {
            id: 1001,
            user_id: 2001,
            user_name: '张晋升',
            user_email: 'zhang@example.com',
            user_phone: '13800138001',
            expected_team_name: '精英团队A',
            current_count: 52,
            required_count: 50,
            remarks: '我已完成所需的50个推广任务，希望能晋升为团队负责人。',
            created_at: '2023-05-15 09:23:45'
        },
        {
            id: 1002,
            user_id: 2002,
            user_name: '李申请',
            user_email: 'li@example.com',
            user_phone: '13900139002',
            expected_team_name: '王者团队B',
            current_count: 65,
            required_count: 50,
            remarks: '我的推广数量已超出要求15个，且都是高质量客户，请审核我的晋升申请。',
            created_at: '2023-05-16 14:37:21'
        },
        {
            id: 1003,
            user_id: 2003,
            user_name: '王大使',
            user_email: 'wang@example.com',
            user_phone: '13700137003',
            expected_team_name: '先锋团队',
            current_count: 51,
            required_count: 50,
            remarks: '刚刚达到晋升条件，希望能成为团队负责人开展更多工作。',
            created_at: '2023-05-17 11:42:18'
        },
        {
            id: 1004,
            user_id: 2004,
            user_name: '赵推广',
            user_email: 'zhao@example.com',
            user_phone: '13600136004',
            expected_team_name: '赵氏推广',
            current_count: 78,
            required_count: 50,
            remarks: '已经超额完成推广任务，希望创建自己的团队。',
            created_at: '2023-05-18 16:55:32'
        },
        {
            id: 1005,
            user_id: 2005,
            user_name: '钱明',
            user_email: 'qian@example.com',
            user_phone: '13500135005',
            expected_team_name: '钱氏营销',
            current_count: 53,
            required_count: 50,
            remarks: '完成了晋升要求，申请成为团队负责人。',
            created_at: '2023-05-19 08:19:27'
        },
        {
            id: 1006,
            user_id: 2006,
            user_name: '孙大才',
            user_email: 'sun@example.com',
            user_phone: '13400134006',
            expected_team_name: '孙氏联盟',
            current_count: 92,
            required_count: 50,
            remarks: '已完成大量推广工作，希望能建立自己的团队拓展业务。',
            created_at: '2023-05-20 10:33:51'
        },
        {
            id: 1007,
            user_id: 2007,
            user_name: '周小红',
            user_email: 'zhou@example.com',
            user_phone: '13300133007',
            expected_team_name: '红星团队',
            current_count: 56,
            required_count: 50,
            remarks: '已完成晋升条件，希望能尽快审批。',
            created_at: '2023-05-21 15:47:09'
        },
        {
            id: 1008,
            user_id: 2008,
            user_name: '吴大勇',
            user_email: 'wu@example.com',
            user_phone: '13200132008',
            expected_team_name: '勇往直前',
            current_count: 67,
            required_count: 50,
            remarks: '推广业绩优秀，希望成立团队扩大影响力。',
            created_at: '2023-05-22 09:15:38'
        },
        {
            id: 1009,
            user_id: 2009,
            user_name: '郑小明',
            user_email: 'zheng@example.com',
            user_phone: '13100131009',
            expected_team_name: '明日之星',
            current_count: 55,
            required_count: 50,
            remarks: '刚刚超过晋升门槛，希望能得到批准。',
            created_at: '2023-05-23 11:27:44'
        },
        {
            id: 1010,
            user_id: 2010,
            user_name: '冯小刚',
            user_email: 'feng@example.com',
            user_phone: '13000130010',
            expected_team_name: '刚强团队',
            current_count: 89,
            required_count: 50,
            remarks: '已大幅超过晋升要求，希望能尽快审批。',
            created_at: '2023-05-24 14:39:57'
        },
        {
            id: 1011,
            user_id: 2011,
            user_name: '陈小艾',
            user_email: 'chen@example.com',
            user_phone: '12900129011',
            expected_team_name: '艾特团队',
            current_count: 61,
            required_count: 50,
            remarks: '完成晋升条件，期待能开展团队工作。',
            created_at: '2023-05-25 16:51:23'
        },
        {
            id: 1012,
            user_id: 2012,
            user_name: '褚大海',
            user_email: 'chu@example.com',
            user_phone: '12800128012',
            expected_team_name: '海洋营销',
            current_count: 72,
            required_count: 50,
            remarks: '超额完成推广任务，申请晋升。',
            created_at: '2023-05-26 10:13:36'
        }
    ];

    // 根据关键词过滤
    let filteredList = applications;
    if (keyword) {
        const lowercaseKeyword = keyword.toLowerCase();
        filteredList = applications.filter(item =>
            String(item.user_id).includes(keyword) ||
            item.user_name.toLowerCase().includes(lowercaseKeyword) ||
            (item.user_email && item.user_email.toLowerCase().includes(lowercaseKeyword)) ||
            (item.user_phone && item.user_phone.includes(keyword))
        );
    }

    // 排序
    filteredList.sort((a, b) => {
        if (sort_field === 'created_at') {
            return sort_order === 'desc'
                ? new Date(b.created_at) - new Date(a.created_at)
                : new Date(a.created_at) - new Date(b.created_at);
        } else if (sort_field === 'user_id' || sort_field === 'id' || sort_field === 'current_count') {
            return sort_order === 'desc'
                ? b[sort_field] - a[sort_field]
                : a[sort_field] - b[sort_field];
        } else {
            return sort_order === 'desc'
                ? String(b[sort_field]).localeCompare(String(a[sort_field]))
                : String(a[sort_field]).localeCompare(String(b[sort_field]));
        }
    });

    // 分页
    const start = (page - 1) * size;
    const end = start + size;
    const paginatedList = filteredList.slice(start, end);

    return {
        records: paginatedList,
        total: filteredList.length,
        size: size,
        current: page,
        pages: Math.ceil(filteredList.length / size)
    };
}

/**
 * 审批晋升申请
 * @param {number} id - 申请ID
 * @param {string} action - 审批动作：approve(批准) 或 reject(拒绝)
 * @returns {Promise}
 */
export function approvePromotionApplication(id, action) {
    // 添加模拟数据
    if (process.env.NODE_ENV === 'development' || window.location.href.includes('mock=true')) {
        console.log(`模拟${action === 'approve' ? '批准' : '拒绝'}晋升申请, ID: ${id}`);

        // 返回Promise以模拟API调用
        return new Promise((resolve) => {
            // 延迟500ms模拟网络请求
            setTimeout(() => {
                if (action === 'approve') {
                    // 查找对应的申请数据
                    const applicationData = generateMockPromotionApplications({ page: 1, size: 100 })
                        .records.find(app => app.id === id);

                    // 如果找到申请数据，创建一个新团队
                    let newTeamData = null;
                    if (applicationData) {
                        // 创建一个新的团队数据
                        newTeamData = {
                            id: 10000 + Math.floor(Math.random() * 1000), // 生成随机ID
                            team_name: applicationData.expected_team_name || `新团队-${Date.now()}`,
                            leader_id: applicationData.user_id,
                            leader_name: applicationData.user_name,
                            member_count: 1, // 初始只有领导人一个成员
                            created_at: new Date().toISOString(),
                            updated_at: new Date().toISOString()
                        };
                    }

                    resolve({
                        code: 1,
                        data: {
                            success: true,
                            message: '已成功批准晋升申请，该推广大使将成为团队负责人',
                            newTeam: newTeamData // 返回新创建的团队数据
                        },
                        msg: '已成功批准晋升申请，该推广大使将成为团队负责人'
                    });
                } else {
                    resolve({
                        code: 1,
                        data: {
                            success: true,
                            message: '已拒绝该晋升申请'
                        },
                        msg: '已拒绝该晋升申请'
                    });
                }
            }, 500);
        });
    }

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