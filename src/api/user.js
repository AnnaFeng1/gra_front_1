import request from '@/utils/request';

/**
 * 获取用户个人信息
 * @returns {Promise}
 */
export function getUserProfile() {
    return request({
        url: '/api/user/profile',
        method: 'get'
    });
}

/**
 * 更新用户个人信息
 * @param {Object} data 要更新的用户信息
 * @returns {Promise}
 */
export function updateUserProfile(data) {
    return request({
        url: '/api/user/profile',
        method: 'put',
        data
    });
} 