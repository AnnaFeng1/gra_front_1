import { createRouter, createWebHashHistory } from 'vue-router';
import NProgress from 'nprogress';
import 'nprogress/nprogress.css';

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
        redirect: '/dashboard'
    },
    {
        path: '/dashboard',
        name: 'Dashboard',
        component: () => import('@/views/AmbassadorDashboard.vue'),
        meta: { title: '首页', requiresAuth: true }
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
            next();
        } else {
            // 未登录，跳转到登录页
            next({
                path: '/login',
                query: { redirect: to.fullPath } // 将跳转的路由path作为参数，登录成功后跳转到该路由
            });
        }
    } else {
        // 不需要登录权限的路由
        // 如果已登录且要前往登录页，则重定向到首页
        if (to.path === '/login' && localStorage.getItem('token')) {
            next({ path: '/dashboard' });
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