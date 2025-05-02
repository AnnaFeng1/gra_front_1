import request from '@/utils/request';

// 用户登录
export function login(username, password) {
    return request({
        url: '/api/auth/login',
        method: 'post',
        data: {
            username,
            password
        }
    });
}

// 用户登出
export function logout() {
    // 由于后端没有实现登出接口，直接返回成功的Promise
    return Promise.resolve({
        code: 1,
        msg: '登出成功',
        data: null
    });
}

// 获取当前用户信息
export function getUserInfo() {
    return request({
        url: '/api/user/profile',
        method: 'get'
    });
} 