<template>
  <div class="login-container">
    <div class="login-box">
      <div class="login-header">
        <div class="logo">营销推广管理系统</div>
        <div class="subtitle">欢迎登录</div>
      </div>
      
      <el-form 
        ref="loginFormRef" 
        :model="loginForm" 
        :rules="loginRules" 
        class="login-form" 
        @keyup.enter="handleLogin"
      >
        <el-form-item prop="username">
          <el-input
            v-model="loginForm.username"
            placeholder="请输入用户名"
            prefix-icon="el-icon-user"
            clearable
            autofocus
          />
        </el-form-item>
        
        <el-form-item prop="password">
          <el-input
            v-model="loginForm.password"
            type="password"
            placeholder="请输入密码"
            prefix-icon="el-icon-lock"
            show-password
          />
        </el-form-item>
        
        <div class="login-options">
          <el-checkbox v-model="rememberMe">记住我</el-checkbox>
          <a href="#" class="forget-link">忘记密码?</a>
        </div>
        
        <el-form-item>
          <el-button 
            :loading="loading" 
            type="primary" 
            class="login-button" 
            @click="handleLogin"
          >
            {{ loading ? '登录中...' : '登录' }}
          </el-button>
        </el-form-item>
      </el-form>
      
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { ElMessage } from 'element-plus';
import { login, getUserInfo } from '@/api/auth';

const router = useRouter();
const loading = ref(false);
const rememberMe = ref(false);

// 登录表单数据
const loginForm = reactive({
  username: '',
  password: ''
});

// 表单验证规则
const loginRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度不能少于6个字符', trigger: 'blur' }
  ]
};

// 登录表单引用
const loginFormRef = ref(null);

// 处理登录
const handleLogin = async () => {
  if (loading.value) return;
  
  // 确保表单引用存在
  if (!loginFormRef.value) {
    console.error('登录表单引用不存在');
    return;
  }
  
  loginFormRef.value.validate(async (valid) => {
    if (!valid) return;
    
    try {
      loading.value = true;
      
      const response = await login(loginForm.username, loginForm.password);
      
      if (response.code === 1) {
        // 登录成功，保存token
        // 确保token值是正确的JWT字符串
        localStorage.setItem('token', response.data);
        
        // 如果选择了"记住我"，保存用户名
        if (rememberMe.value) {
          localStorage.setItem('rememberedUsername', loginForm.username);
        } else {
          localStorage.removeItem('rememberedUsername');
        }
        
        // 获取用户信息，包括角色
        const userInfoResponse = await getUserInfo();
        if (userInfoResponse.code === 1) {
          const userRole = userInfoResponse.data.role;
          // 保存用户角色到localStorage
          localStorage.setItem('userRole', userRole);
          localStorage.setItem('userInfo', JSON.stringify(userInfoResponse.data));
          
          ElMessage.success('登录成功');
          
          // 根据角色跳转到不同的首页
          if (userRole === 'admin') {
            router.push('/admin-dashboard');
          } else if (userRole === 'leader') {
            router.push('/leader-dashboard');
          } else if (userRole === 'ambassador') {
            router.push('/dashboard');
          } else {
            // 未知角色，默认跳转到首页，系统会根据角色重定向
            router.push('/');
          }
        } else {
          ElMessage.error('获取用户信息失败');
          // 清除登录状态
          localStorage.removeItem('token');
        }
      } else {
        ElMessage.error(response.msg || '登录失败，请检查用户名和密码');
      }
    } catch (error) {
      console.error('登录失败:', error);
      ElMessage.error('登录失败，请稍后重试');
    } finally {
      loading.value = false;
    }
  });
};

// 在组件挂载时检查是否有记住的用户名
onMounted(() => {
  const rememberedUsername = localStorage.getItem('rememberedUsername');
  if (rememberedUsername) {
    loginForm.username = rememberedUsername;
    rememberMe.value = true;
  }
});
</script>

<style scoped>
:root {
  --primary-color: #409EFF;
  --text-color: #2c3e50;
  --border-color: #dcdfe6;
  --background-color: #f5f9fc;
  --box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  --font-family: 'Microsoft YaHei', '微软雅黑', Arial, sans-serif;
}

.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  width: 100vw;
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  font-family: var(--font-family);
}

.login-box {
  width: 400px;
  padding: 30px;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
}

.login-box:hover {
  transform: translateY(-5px);
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
}

.login-header {
  text-align: center;
  margin-bottom: 30px;
}

.logo {
  font-size: 24px;
  font-weight: bold;
  color: var(--primary-color);
  margin-bottom: 10px;
}

.subtitle {
  font-size: 16px;
  color: #606266;
}

.login-form {
  margin-bottom: 20px;
}

.login-options {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  color: #606266;
}

.forget-link {
  color: var(--primary-color);
  text-decoration: none;
  font-size: 14px;
}

.forget-link:hover {
  text-decoration: underline;
}

.login-button {
  width: 100%;
  padding: 12px 20px;
  font-size: 16px;
  border-radius: 4px;
}

/* 响应式设计 */
@media (max-width: 480px) {
  .login-box {
    width: 90%;
    padding: 20px;
  }
}
</style> 