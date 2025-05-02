import { createRouter, createWebHashHistory } from 'vue-router';
import NProgress from 'nprogress';
import 'nprogress/nprogress.css';
import TeamManagement from '@/views/TeamManagement.vue'
import CustomerManagement from '@/views/CustomerManagement.vue'

// 路由配置
const routes = [
    {
        path: '/login',
        name: 'Login',
        component: () => import('@/views/Login.vue'),
        meta: { title: '登录', requiresAuth: false }
    },
    {
        path: '/',
        name: 'Root',
        redirect: (to) => {
            // 根据用户角色动态重定向
            const userRole = localStorage.getItem('userRole');
            if (userRole === 'leader') {
                return { path: '/leader-dashboard' };
            } else if (userRole === 'admin') {
                return { path: '/admin-dashboard' };
            } else if (userRole === 'ambassador') {
                return { path: '/dashboard' };
            } else {
                // 如果没有角色信息，先导向登录页
                return { path: '/login' };
            }
        }
    },
    {
        path: '/dashboard',
        name: 'Dashboard',
        component: () => import('@/views/AmbassadorDashboard.vue'),
        meta: { title: '大使首页', requiresAuth: true, roles: ['ambassador'] }
    },
    {
        path: '/leader-dashboard',
        name: 'LeaderDashboard',
        component: () => import('@/views/LeaderDashboard.vue'),
        meta: { title: '大使长首页', requiresAuth: true, roles: ['leader'] }
    },
    {
        path: '/team-management',
        name: 'TeamManagement',
        component: TeamManagement,
        meta: { title: '团队管理', requiresAuth: true, roles: ['leader'] }
    },
    {
        path: '/commission-data',
        name: 'CommissionData',
        component: () => import('@/views/CommissionData.vue'),
        meta: { title: '佣金数据展示', requiresAuth: true, roles: ['leader'] }
    },
    {
        path: '/customer-data',
        name: 'CustomerManagement',
        component: CustomerManagement,
        meta: { title: '客户管理', requiresAuth: true, roles: ['leader'] }
    },
    {
        path: '/profile',
        name: 'UserProfile',
        component: () => import('@/views/UserProfile.vue'),
        meta: { title: '个人中心', requiresAuth: true }
    },
    // 404页面
    {
        path: '/:pathMatch(.*)*',
        name: 'NotFound',
        component: () => import('@/views/NotFound.vue'),
        meta: { title: '404 Not Found', requiresAuth: false }
    }
];

const router = createRouter({
    history: createWebHashHistory(),
    routes
});

// 进度条配置
NProgress.configure({
    easing: 'ease',
    speed: 500,
    showSpinner: false,
    trickleSpeed: 200,
    minimum: 0.3
});

// 路由前置守卫
router.beforeEach((to, from, next) => {
    // 开始进度条
    NProgress.start();

    // 设置页面标题
    document.title = to.meta.title || '';

    // 判断该路由是否需要登录权限
    if (to.meta.requiresAuth) {
        const token = localStorage.getItem('token');
        if (token) {
            // 权限控制逻辑
            if (to.meta.roles && to.meta.roles.length > 0) {
                // 获取用户角色
                const userRole = localStorage.getItem('userRole');

                if (to.meta.roles.includes(userRole)) {
                    next(); // 有权限，放行
                } else {
                    // 无权限，跳转到对应的角色仪表盘
                    const currentPath = to.path;
                    let redirectPath;

                    if (userRole === 'leader') {
                        redirectPath = '/leader-dashboard';
                    } else if (userRole === 'admin') {
                        redirectPath = '/admin-dashboard';
                    } else {
                        redirectPath = '/dashboard';
                    }

                    // 避免重复重定向到相同路径
                    if (currentPath === redirectPath) {
                        // 如果目标路径和当前路径相同，可能是角色错误，返回登录页
                        localStorage.removeItem('token');
                        localStorage.removeItem('userRole');
                        localStorage.removeItem('userInfo');
                        next('/login');
                    } else {
                        next(redirectPath);
                    }
                }
            } else {
                next(); // 没有权限限制，放行
            }
        } else {
            // 未登录，跳转到登录页
            next({
                path: '/login',
                query: { redirect: to.fullPath } // 将跳转的路由path作为参数，登录成功后跳转到该路由
            });
        }
    } else {
        // 不需要登录权限的路由
        // 如果已登录且要前往登录页，则重定向到对应角色的首页
        if (to.path === '/login' && localStorage.getItem('token')) {
            const userRole = localStorage.getItem('userRole');
            if (userRole === 'leader') {
                next('/leader-dashboard');
            } else if (userRole === 'admin') {
                next('/admin-dashboard');
            } else {
                next('/dashboard');
            }
        } else {
            next();
        }
    }
});

// 路由后置守卫
router.afterEach(() => {
    // 结束进度条
    NProgress.done();
});

export default router; 