import axios from 'axios';
import { ElMessage } from 'element-plus';
import router from '@/router';

// 创建axios实例
const service = axios.create({
    baseURL: import.meta.env.VITE_API_BASE_URL || '',
    timeout: 10000, // 请求超时时间
});

// 请求拦截器
service.interceptors.request.use(
    config => {
        // 从localStorage获取token
        const token = localStorage.getItem('token');
        // 如果有token，为每个请求头添加token
        if (token) {
            // 使用Bearer格式添加token，这是JWT的标准格式
            config.headers['Authorization'] = `Bearer ${token}`;
        }
        return config;
    },
    error => {
        console.log(error);
        return Promise.reject(error);
    }
);

// 响应拦截器
service.interceptors.response.use(
    response => {
        const res = response.data;

        // 检查响应数据是否符合预期格式
        if (typeof res !== 'object') {
            console.error('API返回格式错误:', res);
            ElMessage.error('API返回格式错误');
            return Promise.reject(new Error('API返回格式错误'));
        }

        // 确保响应数据中包含code字段，如果没有则添加默认值
        if (res.code === undefined) {
            console.warn('API响应中缺少code字段，设置默认值');
            res.code = 0;
        }

        // 确保响应数据中包含msg字段，如果没有则添加默认值
        if (res.msg === undefined) {
            res.msg = res.code === 1 ? '操作成功' : '操作失败';
        }

        // 确保响应数据中包含data字段，如果没有则添加默认值
        if (res.data === undefined) {
            res.data = null;
        }

        // 如果响应码不是1，则判断为错误
        if (res.code !== 1 && res.code !== undefined) {
            ElMessage({
                message: res.msg || '请求失败',
                type: 'error',
                duration: 3 * 1000
            });

            // 处理特定错误码
            if (res.code === 401) {
                // token过期或未登录
                ElMessage.confirm('登录状态已过期，请重新登录', '确认退出', {
                    confirmButtonText: '重新登录',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    // 清除token并跳转到登录页
                    localStorage.removeItem('token');
                    router.push('/login');
                });
            }

            return Promise.reject(new Error(res.msg || '请求失败'));
        } else {
            return res;
        }
    },
    error => {
        console.error('响应错误:', error);

        if (error.config) {
            console.error('请求URL:', error.config.url);
            console.error('请求方法:', error.config.method);
            console.error('请求头:', error.config.headers);
        }

        if (error.response) {
            console.error('响应状态:', error.response.status);
            console.error('响应数据:', error.response.data);
        }

        // 处理网络错误
        let message = '网络错误，请稍后重试';
        if (error.response) {
            switch (error.response.status) {
                case 400:
                    message = '请求错误';
                    break;
                case 401:
                    message = '未授权，请重新登录';
                    // 清除token并跳转到登录页
                    localStorage.removeItem('token');
                    router.push('/login');
                    break;
                case 403:
                    message = '拒绝访问';
                    break;
                case 404:
                    message = '请求的资源不存在';
                    break;
                case 500:
                    message = '服务器内部错误';
                    break;
                case 501:
                    message = '服务未实现';
                    break;
                case 502:
                    message = '网关错误';
                    break;
                case 503:
                    message = '服务不可用';
                    break;
                case 504:
                    message = '网关超时';
                    break;
                default:
                    message = `未知错误(${error.response.status})`;
            }
        } else if (error.request) {
            // 请求已发送但没有收到响应
            message = '服务器未响应，请检查网络';
        } else {
            // 请求配置错误
            message = '请求配置错误';
        }

        ElMessage({
            message: message,
            type: 'error',
            duration: 5 * 1000
        });

        // 返回一个格式化的错误对象，替代直接拒绝错误
        return Promise.reject({
            message,
            status: error.response ? error.response.status : null,
            error
        });
    }
);

export default service; 