<template>
  <div class="team-ambassador-management" @wheel.stop>
    <!-- 团队列表标签页 -->
    <div v-if="activeTab === 'teams'">
      <div class="team-header">
        <div class="left-section">
          <h2>推广大使团队管理</h2>
          <div class="button-group">
            <el-tooltip content="创建团队" placement="bottom">
              <el-button type="primary" circle @click="handleAddTeam">
                <el-icon><Plus /></el-icon>
              </el-button>
            </el-tooltip>
            <el-tooltip content="晋升申请" placement="bottom">
              <el-button 
                type="success" 
                circle 
                @click="handleTabClick('applications')"
                class="application-btn"
              >
                <el-icon><Promotion /></el-icon>
                <el-badge v-if="applicationCount > 0" :value="applicationCount" class="badge" />
              </el-button>
            </el-tooltip>
          </div>
        </div>
        <div class="right-section">
          <el-input
            v-model="searchQuery"
            placeholder="搜索团队名称/领导人名称"
            class="search-input"
            clearable
          >
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>
          </el-input>
        </div>
      </div>
      <!-- 表格区域 -->
      <div class="table-card">
    <el-table
      v-loading="loading"
          :data="teamList"
          style="width: 100%"
          @sort-change="handleSortChange"
          :header-cell-style="{ background: '#f5f7fa', color: '#606266' }"
          :cell-style="{ padding: '12px 0' }"
        >
          <el-table-column prop="id" label="ID" width="80" sortable="custom"></el-table-column>
          <el-table-column prop="team_name" label="团队名称" sortable="custom"></el-table-column>
          <el-table-column prop="leader_name" label="领导人名称" sortable="custom"></el-table-column>
          <el-table-column prop="member_count" label="成员数量" width="120" align="center"></el-table-column>
          <el-table-column prop="created_at" label="创建时间" min-width="180" sortable="custom">
        <template #default="scope">
              {{ formatDate(scope.row.created_at) }}
        </template>
      </el-table-column>
          <el-table-column prop="updated_at" label="更新时间" min-width="180">
        <template #default="scope">
              {{ formatDate(scope.row.updated_at) }}
        </template>
      </el-table-column>
          
          <!-- 操作列 -->
          <el-table-column label="操作" width="200" fixed="right" align="center">
        <template #default="scope">
              <div class="action-buttons-group">
                <el-tooltip content="查看详情" placement="top">
                  <el-button 
                    type="primary" 
                    circle 
                    size="small" 
                    @click="openTeamDetail(scope.row)"
                  >
                    <el-icon><View /></el-icon>
                  </el-button>
                </el-tooltip>
                <el-tooltip content="成员管理" placement="top">
                  <el-button 
                    type="success" 
                    circle 
                    size="small" 
                    @click="handleManageMembers(scope.row)"
                  >
                    <el-icon><UserFilled /></el-icon>
                  </el-button>
                </el-tooltip>
                <el-tooltip content="解散团队" placement="top">
                  <el-button 
                    type="danger" 
                    circle 
                    size="small" 
                    @click="handleDelete(scope.row)"
                  >
                    <el-icon><Delete /></el-icon>
                  </el-button>
                </el-tooltip>
              </div>
        </template>
      </el-table-column>
    </el-table>
      </div>

      <!-- 分页区域 -->
      <div class="pagination-card">
      <el-pagination
          background
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
        :current-page="currentPage"
          :page-sizes="[10, 20, 50]"
        :page-size="pageSize"
        layout="total, sizes, prev, pager, next, jumper"
          :total="total"
        >
        </el-pagination>
          </div>
    </div>

    <!-- 晋升申请标签页 -->
    <div v-else-if="activeTab === 'applications'">
      <!-- 返回按钮 -->
      <div class="return-header">
        <div class="left-section">
          <el-button @click="handleTabClick('teams')" type="primary" plain>
            <el-icon><ArrowLeft /></el-icon>
            返回
          </el-button>
          <h2 class="section-title">晋升申请列表</h2>
                </div>
        <div class="right-section">
          <el-input
            v-model="applicationSearchQuery"
            placeholder="搜索申请者用户名/ID"
            class="application-search"
            clearable
          >
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>
          </el-input>
      </div>
              </div>
      
      <!-- 申请列表表格 -->
      <div class="table-card">
              <el-table
          v-loading="loading"
          :data="applicationList"
          style="width: 100%"
          @sort-change="handleApplicationSortChange"
          :header-cell-style="{ background: '#f5f7fa', color: '#606266' }"
          :cell-style="{ padding: '12px 0' }"
        >
          <el-table-column prop="id" label="申请ID" width="80" sortable="custom"></el-table-column>
          <el-table-column prop="user_id" label="用户ID" width="80" sortable="custom"></el-table-column>
          <el-table-column prop="user_name" label="申请者" sortable="custom"></el-table-column>
          <el-table-column prop="user_email" label="电子邮箱">
                  <template #default="scope">
              {{ scope.row.user_email || '--' }}
                  </template>
                </el-table-column>
          <el-table-column prop="user_phone" label="电话">
                  <template #default="scope">
              {{ scope.row.user_phone || '--' }}
                  </template>
                </el-table-column>
          <el-table-column prop="expected_team_name" label="期望团队名称">
                  <template #default="scope">
              {{ scope.row.expected_team_name || '--' }}
            </template>
          </el-table-column>
          <el-table-column prop="created_at" label="申请时间" min-width="180" sortable="custom">
            <template #default="scope">
              {{ formatDate(scope.row.created_at) }}
            </template>
          </el-table-column>
          
          <!-- 操作列 -->
          <el-table-column label="操作" width="240" fixed="right">
            <template #default="scope">
              <div class="action-buttons-group">
                <el-tooltip content="查看申请备注" placement="top" :hide-after="2000">
                    <el-button
                    type="info" 
                      size="small"
                    plain 
                    circle
                    v-if="scope.row.remarks"
                    @click="showApplicationRemarks(scope.row)"
                  >
                    <el-icon><InfoFilled /></el-icon>
                  </el-button>
                </el-tooltip>
                <el-button type="success" size="small" @click="handleApprove(scope.row)">批准</el-button>
                <el-button type="danger" size="small" @click="handleReject(scope.row)">拒绝</el-button>
            </div>
                  </template>
                </el-table-column>
              </el-table>
          </div>
      
      <!-- 申请分页 -->
      <div class="pagination-card">
        <el-pagination
          background
          @size-change="handleApplicationSizeChange"
          @current-change="handleApplicationCurrentChange"
          :current-page="applicationPage"
          :page-sizes="[10, 20, 50]"
          :page-size="applicationPageSize"
          layout="total, sizes, prev, pager, next, jumper"
          :total="applicationTotal"
        >
        </el-pagination>
          </div>
        </div>
        
    <!-- 团队详情子界面 -->
    <div v-else-if="activeTab === 'teamDetail'" class="team-detail-view">
      <!-- 返回按钮和标题 -->
      <div class="return-header">
        <div class="left-section">
          <el-button @click="handleTabClick('teams')" type="primary" plain>
            <el-icon><ArrowLeft /></el-icon>
            返回团队列表
          </el-button>
          <h2 class="section-title">{{ currentTeam?.team_name || '团队详情' }}</h2>
        </div>
      </div>
              
      <div class="detail-container" v-loading="detailLoading">
        <!-- 团队基本信息卡片 -->
        <div class="detail-card">
          <div class="card-header">
            <h3>基本信息</h3>
                </div>
          <div class="card-content" v-if="teamDetail">
            <el-descriptions :column="2" border>
              <el-descriptions-item label="团队ID">{{ teamDetail.team_id }}</el-descriptions-item>
              <el-descriptions-item label="团队名称">{{ teamDetail.team_name }}</el-descriptions-item>
              <el-descriptions-item label="领导人ID">{{ teamDetail.leader_id }}</el-descriptions-item>
              <el-descriptions-item label="领导人名称">{{ teamDetail.leader_name }}</el-descriptions-item>
              <el-descriptions-item label="当前转化数">{{ teamDetail.current_camp_conversions || 0 }}</el-descriptions-item>
              <el-descriptions-item label="创建时间">{{ formatDate(teamDetail.created_at) }}</el-descriptions-item>
            </el-descriptions>
              </div>
            </div>

        <!-- 数据图表并排显示区域 -->
        <div class="charts-row">
          <!-- 转化历史数据卡片 -->
          <div class="detail-card chart-card">
            <div class="card-header">
              <h3>历史转化数据</h3>
            </div>
            <div class="card-content">
              <div ref="conversionChartRef" class="chart-container"></div>
              <div class="empty-data" v-if="!detailLoading && (!conversionHistory || !conversionHistory.history?.length)">
                <el-empty description="暂无历史转化数据"></el-empty>
              </div>
                </div>
              </div>
              
          <!-- 团队成员排名卡片 -->
          <div class="detail-card chart-card">
            <div class="card-header">
              <h3>团队成员排名</h3>
            </div>
            <div class="card-content">
              <div ref="memberChartRef" class="chart-container"></div>
              <div class="empty-data" v-if="!detailLoading && (!memberRanking || !memberRanking.rankings?.length)">
                <el-empty description="暂无团队成员排名数据"></el-empty>
              </div>
            </div>
          </div>
        </div>

        <!-- 团队成员列表卡片 -->
        <div class="detail-card">
          <div class="card-header">
            <h3>团队成员列表</h3>
            <div class="card-header-actions">
              <el-button 
                type="primary" 
                @click="showAddMemberDialog" 
                :disabled="detailLoading"
                circle
                class="add-member-btn"
              >
                <el-icon><Plus /></el-icon>
              </el-button>
              <el-input
                v-model="memberSearchKeyword"
                placeholder="搜索成员名称"
                clearable
                class="member-search-input"
                @input="filterMembers"
              >
                <template #prefix>
                  <el-icon><Search /></el-icon>
                </template>
              </el-input>
              </div>
          </div>
          <div class="card-content">
              <el-table
              v-loading="detailLoading"
              :data="filteredMembers"
              style="width: 100%"
                border
              stripe
              :header-cell-style="{background:'#f5f7fa',color:'#606266'}"
              @sort-change="handleMemberSortChange"
                >
              <el-table-column prop="user_id" label="用户ID" width="80" align="center" />
              <el-table-column label="用户名" min-width="120">
                  <template #default="scope">
                  <div class="user-info">
                    <span v-if="scope.row.is_leader" class="leader-tag">
                      <el-tag type="success" size="small">领导人</el-tag>
                    </span>
                    <span>{{ scope.row.username }}</span>
                  </div>
                  </template>
                </el-table-column>
              <el-table-column prop="email" label="邮箱" min-width="180" show-overflow-tooltip />
              <el-table-column prop="phone" label="手机号" width="130" />
              <el-table-column prop="conversions" label="转化数" width="100" align="center" sortable="custom">
                  <template #default="scope">
                  <span class="highlight-text">{{ scope.row.conversions || 0 }}</span>
                  </template>
                </el-table-column>
              <el-table-column prop="commission" label="佣金金额" width="130" align="right" sortable="custom">
                  <template #default="scope">
                  <span class="commission-text">{{ formatCurrency(scope.row.commission) }} 元</span>
                </template>
              </el-table-column>
              <el-table-column fixed="right" label="操作" width="170" align="center">
                <template #default="scope">
                  <el-tooltip content="查看佣金明细" placement="top">
                    <el-button
                      type="success" 
                      link 
                      @click="viewMemberCommissions(scope.row)"
                    >
                      <el-icon><Money /></el-icon>
                    </el-button>
                  </el-tooltip>
                  
                  <el-tooltip content="删除成员" placement="top" v-if="!scope.row.is_leader">
                    <el-button 
                      type="danger"
                      link 
                      @click="handleDeleteMember(scope.row)"
                    >
                      <el-icon><Delete /></el-icon>
                    </el-button>
                  </el-tooltip>
                  </template>
                </el-table-column>
              </el-table>
            <div class="empty-data" v-if="!detailLoading && filteredMembers.length === 0">
              <el-empty description="未找到匹配的团队成员"></el-empty>
            </div>
                </div>
                </div>
                </div>
                </div>
              
    <!-- 添加团队对话框 -->
    <el-dialog
      title="添加推广大使团队"
      v-model="formVisible"
      width="500px"
      destroy-on-close
    >
      <el-form 
        ref="formRef" 
        :model="formData" 
        :rules="formRules" 
        label-width="120px"
        label-position="right"
        class="team-form"
      >
        <el-form-item label="团队名称" prop="team_name">
          <el-input v-model="formData.team_name" placeholder="请输入团队名称"></el-input>
        </el-form-item>
        
        <el-form-item label="领导人姓名" prop="leader_name">
          <el-input v-model="formData.leader_name" placeholder="请输入领导人姓名"></el-input>
                    </el-form-item>
        
        <el-form-item label="领导人密码" prop="leader_password">
          <el-input
            v-model="formData.leader_password"
            type="password"
            placeholder="请输入领导人密码"
            show-password
          ></el-input>
                    </el-form-item>
        
        <el-form-item label="领导人电子邮箱" prop="leader_email">
          <el-input v-model="formData.leader_email" placeholder="请输入领导人电子邮箱"></el-input>
        </el-form-item>
        
        <el-form-item label="领导人电话" prop="leader_phone">
          <el-input v-model="formData.leader_phone" placeholder="请输入领导人电话号码"></el-input>
                    </el-form-item>
                  </el-form>
      
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="formVisible = false">取消</el-button>
          <el-button type="primary" @click="submitForm" :loading="submitting">提交</el-button>
        </span>
      </template>
    </el-dialog>

    <!-- 删除确认对话框 -->
    <el-dialog
      title="确认解散团队"
      v-model="deleteVisible"
      width="400px"
      destroy-on-close
    >
      <div class="delete-confirm-content">
        <p>确定要解散团队 <strong>{{ teamToDelete?.team_name }}</strong> 吗？</p>
        <p class="delete-warning">注意：只能解散没有任何推广记录的团队，解散后所有成员将变为独立推广大使！</p>
              </div>
              
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="deleteVisible = false">取消</el-button>
          <el-tooltip content="确认解散" placement="top">
            <el-button type="danger" circle @click="confirmDelete" :loading="deleting">
              <el-icon><Delete /></el-icon>
            </el-button>
          </el-tooltip>
        </span>
      </template>
    </el-dialog>

    <!-- 申请备注对话框 -->
    <el-dialog
      title="申请备注"
      v-model="remarksVisible"
      width="400px"
      destroy-on-close
    >
      <div class="remarks-content">
        <p>{{ currentRemarks }}</p>
                </div>
              
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="remarksVisible = false">关闭</el-button>
        </span>
      </template>
    </el-dialog>
    
    <!-- 批准申请确认对话框 -->
    <el-dialog
      title="确认批准晋升申请"
      v-model="approveVisible"
      width="450px"
      destroy-on-close
    >
      <div class="approve-confirm-content">
        <p>确定要批准用户 <strong>{{ applicationToApprove?.user_name }}</strong> 的晋升申请吗？</p>
        <p>批准后，该用户将成为推广大使长，并创建名为 <strong>{{ applicationToApprove?.expected_team_name || '(系统自动生成名称)' }}</strong> 的新团队。</p>
              </div>
      
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="approveVisible = false">取消</el-button>
          <el-button type="success" @click="confirmApprove" :loading="approving">确认批准</el-button>
        </span>
                    </template>
    </el-dialog>
    
    <!-- 拒绝申请确认对话框 -->
    <el-dialog
      title="确认拒绝晋升申请"
      v-model="rejectVisible"
      width="400px"
      destroy-on-close
    >
      <div class="reject-confirm-content">
        <p>确定要拒绝用户 <strong>{{ applicationToReject?.user_name }}</strong> 的晋升申请吗？</p>
            </div>
      
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="rejectVisible = false">取消</el-button>
          <el-button type="danger" @click="confirmReject" :loading="rejecting">确认拒绝</el-button>
        </span>
                    </template>
    </el-dialog>

    <!-- 添加成员对话框 -->
    <el-dialog
      title="添加团队成员"
      v-model="addMemberVisible"
      width="400px"
      destroy-on-close
    >
      <el-form 
        ref="memberFormRef" 
        :model="memberFormData" 
        :rules="memberFormRules" 
        label-width="100px"
        label-position="right"
        class="member-form"
      >
        <el-form-item label="用户名" prop="username">
          <el-input v-model="memberFormData.username" placeholder="请输入用户名"></el-input>
                    </el-form-item>
        
        <el-form-item label="电子邮箱" prop="email">
          <el-input v-model="memberFormData.email" placeholder="请输入电子邮箱"></el-input>
                    </el-form-item>
        
        <el-form-item label="手机号码" prop="phone">
          <el-input v-model="memberFormData.phone" placeholder="请输入手机号码"></el-input>
        </el-form-item>
        
        <el-form-item label="密码" prop="password">
          <el-input
            v-model="memberFormData.password"
            type="password"
            placeholder="默认密码: 88888888"
            show-password
          ></el-input>
                    </el-form-item>
                  </el-form>
      
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="addMemberVisible = false">取消</el-button>
          <el-button type="primary" @click="submitMemberForm" :loading="addingMember">添加</el-button>
        </span>
                    </template>
    </el-dialog>

    <!-- 删除成员确认对话框 -->
    <el-dialog
      title="确认删除成员"
      v-model="deleteMemberVisible"
      width="400px"
      destroy-on-close
    >
      <div class="delete-confirm-content">
        <p>确定要删除成员 <strong>{{ memberToDelete?.username }}</strong> 吗？</p>
        <p class="delete-warning">注意：删除后将无法恢复！</p>
                </div>
      
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="deleteMemberVisible = false">取消</el-button>
          <el-button type="danger" @click="confirmDeleteMember" :loading="deletingMember">确认删除</el-button>
        </span>
      </template>
    </el-dialog>

    <!-- 团队领导人佣金明细对话框 -->
    <el-dialog
      v-if="leaderCommissionsVisible !== undefined"
      v-model="leaderCommissionsVisible"
      :title="`${currentTeam ? (currentTeam.leader_name || '团队领导人') : '团队领导人'}的佣金明细`"
      width="80%"
      destroy-on-close
      class="leader-commissions-dialog"
    >
      <el-skeleton :loading="loadingLeaderCommissions" animated>
        <template #default>
          <div v-if="leaderCommissionsData && leaderCommissionsData.campInfo" class="camp-info-section">
            <h3>营期信息</h3>
            <el-descriptions :column="2" border>
              <el-descriptions-item label="营期ID">
                {{ leaderCommissionsData.campInfo.camp_id || leaderCommissionsData.campInfo.campId }}
              </el-descriptions-item>
              <el-descriptions-item label="营期名称">
                {{ leaderCommissionsData.campInfo.camp_name || leaderCommissionsData.campInfo.campName }}
              </el-descriptions-item>
              <el-descriptions-item label="开始日期">
                {{ formatDate(leaderCommissionsData.campInfo.start_date || leaderCommissionsData.campInfo.startDate) }}
              </el-descriptions-item>
              <el-descriptions-item label="结束日期">
                {{ formatDate(leaderCommissionsData.campInfo.end_date || leaderCommissionsData.campInfo.endDate) }}
              </el-descriptions-item>
            </el-descriptions>
              </div>
              
          <div class="commissions-section">
            <h3>佣金明细</h3>
                <el-table
              :data="leaderCommissionsData ? leaderCommissionsData.commissions : []"
              stripe
              style="width: 100%"
              v-if="leaderCommissionsData && leaderCommissionsData.commissions && leaderCommissionsData.commissions.length > 0"
              max-height="400px"
            >
              <el-table-column prop="commission_id" label="佣金ID" width="120">
                    <template #default="scope">
                  {{ scope.row.commission_id || scope.row.commissionId || scope.row.id || '-' }}
                    </template>
                  </el-table-column>
              <el-table-column prop="type" label="佣金类型" width="150">
                    <template #default="scope">
                  <el-tag :type="getCommissionTypeTag(scope.row.type || scope.row.commissionType)" effect="plain">
                    {{ getCommissionTypeName(scope.row.type || scope.row.commissionType) }}
                  </el-tag>
                    </template>
                  </el-table-column>
              <el-table-column prop="order_id" label="订单ID" width="120">
                    <template #default="scope">
                  {{ scope.row.order_id || scope.row.orderId || '-' }}
                    </template>
                  </el-table-column>
              <el-table-column prop="customer_id" label="客户ID" width="120">
                    <template #default="scope">
                  {{ scope.row.customer_id || scope.row.customerId || '-' }}
                    </template>
                  </el-table-column>
              <el-table-column prop="promoted_ambassador_id" label="被推广大使ID" width="150">
                    <template #default="scope">
                  {{ scope.row.promoted_ambassador_id || scope.row.promotedAmbassadorId || '-' }}
                </template>
              </el-table-column>
              <el-table-column prop="tier" label="层级" width="80">
                <template #default="scope">
                  {{ scope.row.tier || '-' }}
                </template>
              </el-table-column>
              <el-table-column prop="amount" label="佣金金额" width="150">
                <template #default="scope">
                  {{ formatCurrency(scope.row.amount || scope.row.commission_amount || scope.row.commissionAmount || scope.row.commission) }} 元
                </template>
              </el-table-column>
              <el-table-column prop="created_at" label="创建时间" width="180">
                <template #default="scope">
                  {{ formatDate(scope.row.created_at || scope.row.createdTime || scope.row.created_time) }}
                </template>
              </el-table-column>
              <el-table-column prop="description" label="描述" min-width="200">
                <template #default="scope">
                  {{ scope.row.description || scope.row.desc || '-' }}
                    </template>
                  </el-table-column>
                </el-table>
            <el-empty v-else description="暂无佣金明细数据" />
              </div>
        </template>
      </el-skeleton>
    </el-dialog>

    <!-- 团队成员佣金明细对话框 -->
    <el-dialog
      v-if="memberCommissionsVisible !== undefined"
      v-model="memberCommissionsVisible"
      :title="`${currentMember ? currentMember.username : '团队成员'}的佣金明细`"
      width="80%"
      destroy-on-close
      class="member-commissions-dialog"
    >
      <el-skeleton :loading="loadingMemberCommissions" animated>
        <template #default>
          <div v-if="memberCommissionsData && memberCommissionsData.campInfo" class="camp-info-section">
            <h3>营期信息</h3>
            <el-descriptions :column="2" border>
              <el-descriptions-item label="营期ID">
                {{ memberCommissionsData.campInfo.camp_id || memberCommissionsData.campInfo.campId }}
              </el-descriptions-item>
              <el-descriptions-item label="营期名称">
                {{ memberCommissionsData.campInfo.camp_name || memberCommissionsData.campInfo.campName }}
              </el-descriptions-item>
              <el-descriptions-item label="开始日期">
                {{ formatDate(memberCommissionsData.campInfo.start_date || memberCommissionsData.campInfo.startDate) }}
              </el-descriptions-item>
              <el-descriptions-item label="结束日期">
                {{ formatDate(memberCommissionsData.campInfo.end_date || memberCommissionsData.campInfo.endDate) }}
              </el-descriptions-item>
            </el-descriptions>
            </div>
          
          <div class="member-stats-section" v-if="memberCommissionsData && memberCommissionsData.stats">
            <h3>佣金统计</h3>
            <el-descriptions :column="2" border>
              <el-descriptions-item label="总佣金">
                {{ formatCurrency(memberCommissionsData.stats.total_commission || memberCommissionsData.stats.totalCommission) }} 元
              </el-descriptions-item>
              <el-descriptions-item label="转化数">
                {{ memberCommissionsData.stats.conversion_count || memberCommissionsData.stats.conversionCount || 0 }}
              </el-descriptions-item>
            </el-descriptions>
      </div>
          
          <div class="commissions-section">
            <h3>佣金明细</h3>
            <el-table
              :data="memberCommissionsData ? memberCommissionsData.commissions : []"
              stripe
              style="width: 100%"
              v-if="memberCommissionsData && memberCommissionsData.commissions && memberCommissionsData.commissions.length > 0"
              max-height="400px"
            >
              <el-table-column prop="commission_id" label="佣金ID" width="120">
                <template #default="scope">
                  {{ scope.row.commission_id || scope.row.commissionId || scope.row.id || '-' }}
                </template>
              </el-table-column>
              <el-table-column prop="type" label="佣金类型" width="150">
                <template #default="scope">
                  <el-tag :type="getCommissionTypeTag(scope.row.type || scope.row.commission_type || scope.row.commissionType)" effect="plain">
                    {{ getCommissionTypeName(scope.row.type || scope.row.commission_type || scope.row.commissionType) }}
                  </el-tag>
                </template>
              </el-table-column>
              <el-table-column prop="order_id" label="订单ID" width="120">
                <template #default="scope">
                  {{ scope.row.order_id || scope.row.orderId || '-' }}
                </template>
              </el-table-column>
              <el-table-column prop="customer_id" label="客户ID" width="120">
                <template #default="scope">
                  {{ scope.row.customer_id || scope.row.customerId || '-' }}
                </template>
              </el-table-column>
              <el-table-column prop="tier" label="层级" width="80">
                <template #default="scope">
                  {{ scope.row.tier || '-' }}
                </template>
              </el-table-column>
              <el-table-column prop="amount" label="佣金金额" width="150">
                <template #default="scope">
                  {{ formatCurrency(scope.row.amount || scope.row.commission_amount || scope.row.commissionAmount || 0) }} 元
                </template>
              </el-table-column>
              <el-table-column prop="created_at" label="创建时间" width="180">
                <template #default="scope">
                  {{ formatDate(scope.row.created_at || scope.row.createdTime || scope.row.created_time) }}
                </template>
              </el-table-column>
              <el-table-column prop="description" label="描述" min-width="200">
                <template #default="scope">
                  {{ scope.row.description || scope.row.desc || '-' }}
                </template>
              </el-table-column>
            </el-table>
            <el-empty v-else description="暂无佣金明细数据" />
          </div>
        </template>
      </el-skeleton>
    </el-dialog>
  </div>
</template>

<script>
import { getTeamList, addTeamAmbassador, getTeamDetail, deleteTeam, getPendingPromotionApplications, approvePromotionApplication, getTeamConversionHistory, getTeamMemberRanking, addTeamMember, deleteTeamMember, getTeamLeaderCommissions, getTeamMemberCommissions } from '@/api/admin';
import { ref, reactive, onMounted, onBeforeUnmount, watch, markRaw, nextTick } from 'vue';
import { ArrowLeft, Search, Plus, MoreFilled, Delete, Edit, Check, Close, Refresh, InfoFilled, Money, Promotion, View, UserFilled } from '@element-plus/icons-vue';
import { ElMessage, ElMessageBox } from 'element-plus';
import * as echarts from 'echarts/core';
import { LineChart, BarChart } from 'echarts/charts';
import { TooltipComponent, GridComponent, LegendComponent, TitleComponent } from 'echarts/components';
import { CanvasRenderer } from 'echarts/renderers';

// 注册必须的组件
echarts.use([
  LineChart,
  BarChart,
  TooltipComponent,
  GridComponent,
  LegendComponent,
  TitleComponent,
  CanvasRenderer
]);

export default {
  name: 'TeamAmbassadorManagement',
  components: {
    // 使用markRaw保证图标组件不会被Vue包装成响应式对象
    ArrowLeft: markRaw(ArrowLeft),
    Search: markRaw(Search),
    Plus: markRaw(Plus),
    MoreFilled: markRaw(MoreFilled),
    Delete: markRaw(Delete),
    Edit: markRaw(Edit),
    Check: markRaw(Check),
    Close: markRaw(Close),
    Refresh: markRaw(Refresh),
    InfoFilled: markRaw(InfoFilled),
    Money: markRaw(Money),
    Promotion: markRaw(Promotion),
    View: markRaw(View),
    UserFilled: markRaw(UserFilled)
  },
  setup() {
    // 选项卡控制
    const activeTab = ref('teams');
    const applicationCount = ref(0);
    
    // 图表相关
    const conversionChartRef = ref(null);
    const memberChartRef = ref(null);
    let conversionChart = null;
    let memberChart = null;
    
    // 团队列表数据
    const teamList = ref([]);
    const loading = ref(false);
    const total = ref(0);
const currentPage = ref(1);
const pageSize = ref(10);
    const searchQuery = ref('');
    const sortField = ref('id');
    const sortOrder = ref('desc');
    
    // 晋升申请列表数据
    const applicationList = ref([]);
    const applicationTotal = ref(0);
    const applicationPage = ref(1);
    const applicationPageSize = ref(10);
    const applicationSortField = ref('created_at');
    const applicationSortOrder = ref('desc');
    
    // 团队详情数据
    const currentTeam = ref(null);
    const teamDetail = ref(null);
    const conversionHistory = ref(null);
    const memberRanking = ref(null);
    const detailLoading = ref(false);
    
    // 申请备注对话框
    const remarksVisible = ref(false);
    const currentRemarks = ref('');
    
    // 批准申请对话框
    const approveVisible = ref(false);
    const applicationToApprove = ref(null);
    const approving = ref(false);
    
    // 拒绝申请对话框
    const rejectVisible = ref(false);
    const applicationToReject = ref(null);
    const rejecting = ref(false);
    
    // 表单相关
    const formRef = ref(null);
    const formVisible = ref(false);
    const submitting = ref(false);
    
    const formData = reactive({
      team_name: '',
      leader_name: '',
      leader_password: '',
      leader_email: '',
      leader_phone: ''
    });
    
    const formRules = {
      team_name: [
        { required: true, message: '请输入团队名称', trigger: 'blur' },
        { min: 2, max: 30, message: '团队名称长度需在2到30个字符之间', trigger: 'blur' }
      ],
      leader_name: [
        { required: true, message: '请输入领导人姓名', trigger: 'blur' },
        { min: 2, max: 20, message: '领导人姓名长度需在2到20个字符之间', trigger: 'blur' }
      ],
      leader_password: [
        { required: true, message: '请输入领导人密码', trigger: 'blur' },
        { min: 8, message: '密码长度不能少于8个字符', trigger: 'blur' }
      ],
      leader_email: [
        { type: 'email', message: '请输入正确的电子邮箱格式', trigger: 'blur' }
      ],
      leader_phone: [
        { pattern: /^1[3456789]\d{9}$/, message: '请输入正确的手机号码', trigger: 'blur' }
      ]
    };
    
    // 删除相关
    const deleteVisible = ref(false);
    const teamToDelete = ref(null);
    const deleting = ref(false);
    
    // 搜索相关
    const applicationSearchQuery = ref('');
    
    // 标签页切换
    const handleTabClick = (tabName) => {
      activeTab.value = tabName;
      if (tabName === 'applications') {
        loadApplicationData();
      } else if (tabName === 'teams') {
        loadTeamData();
      } else if (tabName === 'teamDetail' && currentTeam.value) {
        loadTeamDetailData(currentTeam.value.id);
      }
    };
    
    // 刷新当前标签页
    const refreshCurrentTab = () => {
      if (activeTab.value === 'applications') {
        loadApplicationData();
      } else if (activeTab.value === 'teams') {
        loadTeamData();
      } else if (activeTab.value === 'teamDetail') {
        if (currentTeam.value && currentTeam.value.id) {
          loadTeamDetailData(currentTeam.value.id);
        } else {
          ElMessage.warning('无法刷新团队详情，团队信息不完整');
          // 如果团队信息不存在，回到团队列表
          activeTab.value = 'teams';
          loadTeamData();
        }
      }
    };
    
    // 加载团队列表数据
    const loadTeamData = async () => {
      if (activeTab.value !== 'teams') return;
      
      loading.value = true;
      
      // 构建请求参数
      const params = {
        page: currentPage.value,
        size: pageSize.value,
        sort_field: sortField.value,
        sort_order: sortOrder.value
      };
      
      // 添加搜索关键词（如果有）
      if (searchQuery.value && searchQuery.value.trim() !== '') {
        params.keyword = searchQuery.value.trim();
      }
      
      console.log('开始请求推广大使团队列表数据，参数:', params);
      
      // 调用API获取数据
      try {
        const response = await getTeamList(params);
        console.log('获取推广大使团队列表响应:', response);
        
        // 处理返回的数据结构
        if (!response.data) {
          ElMessage.warning('API返回了成功状态，但没有数据');
          teamList.value = [];
          total.value = 0;
          return;
        }
        
        const data = response.data;
        
        // 处理返回的数据结构
        if (data.records) {
          teamList.value = data.records;
          total.value = data.total || data.records.length;
          currentPage.value = data.current || currentPage.value;
        } else if (data.list) {
          teamList.value = data.list;
          total.value = data.total || data.list.length;
          currentPage.value = data.current || currentPage.value;
        } else if (Array.isArray(data)) {
          teamList.value = data;
          total.value = data.length;
        } else {
          const possibleListFields = Object.keys(data).filter(key => 
            Array.isArray(data[key]) && data[key].length > 0
          );
          
          if (possibleListFields.length > 0) {
            const listField = possibleListFields[0];
            teamList.value = data[listField];
            total.value = teamList.value.length;
          } else {
            ElMessage.warning('无法识别的数据结构，显示空列表');
            teamList.value = [];
            total.value = 0;
          }
        }
      } catch (error) {
        console.error('获取推广大使团队列表失败:', error);
        teamList.value = [];
        total.value = 0;
      } finally {
        loading.value = false;
      }
    };
    
    // 加载晋升申请列表数据
    const loadApplicationData = async () => {
      if (activeTab.value !== 'applications') return;
      
      loading.value = true;
      
      const params = {
        page: applicationPage.value,
        size: applicationPageSize.value,
        sort_field: applicationSortField.value,
        sort_order: applicationSortOrder.value
      };
      
      if (applicationSearchQuery.value && applicationSearchQuery.value.trim() !== '') {
        params.keyword = applicationSearchQuery.value.trim();
      }
      
      console.log('开始请求未审批晋升申请列表数据，参数:', params);
      
      try {
        const response = await getPendingPromotionApplications(params);
        console.log('获取未审批晋升申请列表响应:', response);
        
        if (!response.data) {
          ElMessage.warning('API返回了成功状态，但没有数据');
          applicationList.value = [];
          applicationTotal.value = 0;
          applicationCount.value = 0;
          return;
        }
        
        const data = response.data;
        
        if (data.records) {
          applicationList.value = data.records;
          applicationTotal.value = data.total || data.records.length;
          applicationPage.value = data.current || applicationPage.value;
          applicationCount.value = data.total || data.records.length;
        } else if (data.list) {
          applicationList.value = data.list;
          applicationTotal.value = data.total || data.list.length;
          applicationPage.value = data.current || applicationPage.value;
          applicationCount.value = data.total || data.list.length;
        } else if (Array.isArray(data)) {
          applicationList.value = data;
          applicationTotal.value = data.length;
          applicationCount.value = data.length;
        } else {
          ElMessage.warning('无法识别的数据结构，显示空列表');
          applicationList.value = [];
          applicationTotal.value = 0;
          applicationCount.value = 0;
        }
      } catch (error) {
        console.error('获取未审批晋升申请列表失败:', error);
        applicationList.value = [];
        applicationTotal.value = 0;
        applicationCount.value = 0;
      } finally {
        loading.value = false;
      }
    };
    
    // 查询未处理申请数量（不分页）
    const fetchApplicationCount = async () => {
      try {
        const response = await getPendingPromotionApplications({ page: 1, size: 1 });
        if (response.data && typeof response.data.total === 'number') {
          applicationCount.value = response.data.total;
        }
      } catch (error) {
        console.error('获取未审批晋升申请数量失败:', error);
      }
    };
    
    // 显示申请备注
    const showApplicationRemarks = (application) => {
      currentRemarks.value = application.remarks || '无备注';
      remarksVisible.value = true;
    };
    
    // 批准申请
    const handleApprove = (application) => {
      applicationToApprove.value = application;
      approveVisible.value = true;
    };
    
    // 确认批准
    const confirmApprove = async () => {
      if (!applicationToApprove.value) return;
      
      approving.value = true;
      
      try {
        await approvePromotionApplication(applicationToApprove.value.id, 'approve');
        ElMessage.success('晋升申请已批准成功');
        approveVisible.value = false;
        
        // 刷新申请列表
        loadApplicationData();
        // 同时刷新团队列表（因为批准后会创建新团队）
        if (activeTab.value === 'teams') {
          loadTeamData();
        }
        // 更新未处理数量
        fetchApplicationCount();
      } catch (error) {
        console.error('批准晋升申请失败:', error);
      } finally {
        approving.value = false;
      }
    };
    
    // 拒绝申请
    const handleReject = (application) => {
      applicationToReject.value = application;
      rejectVisible.value = true;
    };
    
    // 确认拒绝
    const confirmReject = async () => {
      if (!applicationToReject.value) return;
      
      rejecting.value = true;
      
      try {
        await approvePromotionApplication(applicationToReject.value.id, 'reject');
        ElMessage.success('晋升申请已拒绝');
        rejectVisible.value = false;
        
        // 刷新申请列表
        loadApplicationData();
        // 更新未处理数量
        fetchApplicationCount();
      } catch (error) {
        console.error('拒绝晋升申请失败:', error);
      } finally {
        rejecting.value = false;
      }
    };
    
    // 分页和排序处理
    const handleCurrentChange = (page) => {
      currentPage.value = page;
      loadTeamData();
    };
    
    const handleSizeChange = (size) => {
      pageSize.value = size;
      currentPage.value = 1; // 重置到第一页
      loadTeamData();
    };
    
    const handleSortChange = ({ prop, order }) => {
      sortField.value = prop || 'id';
      sortOrder.value = order === 'ascending' ? 'asc' : 'desc';
      loadTeamData();
    };
    
    // 申请列表分页和排序
    const handleApplicationCurrentChange = (page) => {
      applicationPage.value = page;
      loadApplicationData();
    };
    
    const handleApplicationSizeChange = (size) => {
      applicationPageSize.value = size;
      applicationPage.value = 1;
      loadApplicationData();
    };
    
    const handleApplicationSortChange = ({ prop, order }) => {
      applicationSortField.value = prop || 'created_at';
      applicationSortOrder.value = order === 'ascending' ? 'asc' : 'desc';
      loadApplicationData();
    };
    
    // 搜索处理
    const handleSearch = () => {
      if (activeTab.value === 'teams') {
        currentPage.value = 1;
        loadTeamData();
      } else if (activeTab.value === 'applications') {
        applicationPage.value = 1;
        loadApplicationData();
      }
    };
    
    // 监听搜索框和申请搜索框变化
    watch(searchQuery, () => {
      if (activeTab.value === 'teams') {
        handleSearch();
      }
    });
    
    watch(applicationSearchQuery, () => {
      if (activeTab.value === 'applications') {
        handleSearch();
      }
    });
    
    // 监听标签页变化
    watch(activeTab, (newVal) => {
      if (newVal === 'applications') {
        loadApplicationData();
      } else {
        loadTeamData();
      }
    });
    
    // 组件挂载时加载数据
    onMounted(() => {
      loadTeamData();
      fetchApplicationCount();
    });

    // 组件卸载时清理图表实例
    const onBeforeUnmount = () => {
      // 清理图表实例
      if (conversionChart) {
        conversionChart.dispose();
        conversionChart = null;
      }
      
      if (memberChart) {
        memberChart.dispose();
        memberChart = null;
      }
      
      // 移除事件监听
      window.removeEventListener('resize', function() {
        conversionChart && conversionChart.resize();
      });
      
      window.removeEventListener('resize', function() {
        memberChart && memberChart.resize();
      });
    };
    
    // 打开团队详情页面
    const openTeamDetail = async (team) => {
      currentTeam.value = team;
      activeTab.value = 'teamDetail';
      await loadTeamDetailData(team.id);
    };
    
    // 初始化历史转化数据图表
    const initConversionChart = () => {
      if (!conversionChartRef.value) return;
      
      // 如果图表已经存在，先销毁
      if (conversionChart) {
        conversionChart.dispose();
      }
      
      // 初始化图表
      conversionChart = echarts.init(conversionChartRef.value);
      conversionChart.setOption({
        title: {
          text: '历史转化数据趋势',
          left: 'center',
          top: 5,
          textStyle: {
            fontSize: 14
          }
        },
        tooltip: {
          trigger: 'axis',
          formatter: function(params) {
            const data0 = params[0].data;
            const data1 = params[1].data;
            return `${params[0].name}<br/>
                   转化数: ${data0.conversions} <br/>
                   佣金金额: ${formatCurrency(data1.commission)} 元`;
          }
        },
        legend: {
          data: ['转化数', '佣金金额'],
          top: '30px'
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          top: '60px',
          containLabel: true
        },
        xAxis: {
          type: 'category',
          data: [],
          axisTick: {
            alignWithLabel: true
          }
        },
        yAxis: [
          {
            type: 'value',
            name: '转化数',
            position: 'left',
            minInterval: 1, // 确保最小间隔为1，只显示整数
            axisLine: {
              show: true,
              lineStyle: {
                color: '#5470C6'
              }
            },
            axisLabel: {
              formatter: '{value}'
            },
            splitLine: {
              lineStyle: {
                type: 'dashed'
              }
            }
          },
          {
            type: 'value',
            name: '佣金金额',
            position: 'right',
            axisLine: {
              show: true,
              lineStyle: {
                color: '#91CC75'
              }
            },
            axisLabel: {
              formatter: '{value} 元'
            }
          }
        ],
        series: [
          {
            name: '转化数',
            type: 'line',
            data: [],
            smooth: true,
            lineStyle: {
              width: 3,
              color: '#5470C6'
            },
            itemStyle: {
              color: '#5470C6'
            }
          },
          {
            name: '佣金金额',
            type: 'line',
            yAxisIndex: 1,
            data: [],
            smooth: true,
            lineStyle: {
              width: 3,
              color: '#91CC75'
            },
            itemStyle: {
              color: '#91CC75'
            }
          }
        ]
      });
      
      // 监听窗口大小变化，自动调整图表大小
      window.addEventListener('resize', function() {
        conversionChart && conversionChart.resize();
      });
    };
    
    // 初始化团队成员排名图表
    const initMemberChart = () => {
      if (!memberChartRef.value) return;
      
      // 如果图表已经存在，先销毁
      if (memberChart) {
        memberChart.dispose();
      }
      
      // 初始化图表
      memberChart = echarts.init(memberChartRef.value);
      memberChart.setOption({
        title: {
          text: '团队成员转化排名（单位：转化数）',
          left: 'center',
          top: 5,
          textStyle: {
            fontSize: 14
          }
        },
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'shadow'
          },
          formatter: function(params) {
            const data = params[0].data;
            return `${data.username} ${data.is_leader ? '(领导人)' : ''}<br/>
                   转化数: ${data.conversions} <br/>
                   佣金金额: ${formatCurrency(data.commission)} 元`;
          }
        },
        grid: {
          left: '3%',
          right: '8%', // 右侧边距
          bottom: '8%', // 底部边距
          top: '60px',
          containLabel: true
        },
        xAxis: {
          type: 'value',
          name: '', // 移除名称
          minInterval: 1, // 确保最小间隔为1，只显示整数
          axisLabel: {
            formatter: '{value}',
            margin: 12 // 增加标签与轴线的距离
          },
          axisTick: {
            alignWithLabel: true
          },
          splitLine: {
            lineStyle: {
              type: 'dashed'
            }
          },
          max: function(value) {
            // 确保最大值有更多额外空间显示
            return Math.ceil(value.max) + 2; // 增加2个单位
          }
        },
        yAxis: {
          type: 'category',
          data: [],
          axisTick: {
            alignWithLabel: true
          },
          axisLabel: {
            formatter: function(value) {
              // 如果名称太长，进行截断
              if(value.length > 8) {
                return value.substring(0, 8) + '...';
              }
              return value;
            }
          }
        },
        series: [
          {
            name: '转化数',
            type: 'bar',
            data: [],
            label: {
              show: true,
              position: 'right',
              formatter: '{c}',
              fontSize: 12
            },
            itemStyle: {
              color: function(params) {
                // 根据排名设置不同的颜色
                const colors = ['#ee6666', '#fac858', '#91cc75', '#73c0de', '#5470c6', '#9a60b4'];
                return colors[params.dataIndex % colors.length];
              }
            }
          }
        ]
      });
      
      // 监听窗口大小变化，自动调整图表大小
      window.addEventListener('resize', function() {
        memberChart && memberChart.resize();
      });
    };
    
    // 更新历史转化数据图表
    const updateConversionChart = () => {
      if (!conversionChart || !conversionHistory.value || !conversionHistory.value.history) return;
      
      const history = [...conversionHistory.value.history].reverse(); // 反转数组以按时间顺序显示
      
      const xAxisData = history.map(item => item.period_name);
      const conversionData = history.map(item => ({
        value: parseInt(item.conversions) || 0, // 确保转化数为整数
        conversions: parseInt(item.conversions) || 0, // 确保转化数为整数
        commission: item.commission
      }));
      const commissionData = history.map(item => ({
        value: parseFloat(item.commission) || 0,
        conversions: parseInt(item.conversions) || 0, // 确保转化数为整数
        commission: item.commission
      }));
      
      conversionChart.setOption({
        xAxis: {
          data: xAxisData
        },
        series: [
          {
            data: conversionData
          },
          {
            data: commissionData
          }
        ]
      });
    };
    
    // 更新团队成员排名图表
    const updateMemberChart = () => {
      if (!memberChart || !memberRanking.value || !memberRanking.value.rankings) return;
      
      const rankings = [...memberRanking.value.rankings];
      
      // 排序，确保数据从高到低
      rankings.sort((a, b) => b.conversions - a.conversions);
      
      const yAxisData = rankings.map(item => {
        // 如果是领导人，添加标记
        return item.is_leader ? `${item.username} (领导人)` : item.username;
      });
      
      const seriesData = rankings.map(item => ({
        value: parseInt(item.conversions) || 0, // 确保值为整数
        username: item.username,
        is_leader: item.is_leader,
        conversions: parseInt(item.conversions) || 0, // 确保值为整数
        commission: item.commission
      }));
      
      memberChart.setOption({
        yAxis: {
          data: yAxisData
        },
        series: [
          {
            data: seriesData
          }
        ]
      });
    };

    // 加载团队详情数据
    const loadTeamDetailData = async (teamId) => {
      if (!teamId) {
        ElMessage.warning('团队ID不存在，无法加载详情数据');
        return;
      }
      
      detailLoading.value = true;
      teamDetail.value = null;
      conversionHistory.value = null;
      memberRanking.value = null;
      filteredMembers.value = [];
      
      try {
        // 并行加载三个接口的数据
        const [detailRes, historyRes, rankingRes] = await Promise.all([
          getTeamDetail(teamId),
          getTeamConversionHistory(teamId),
          getTeamMemberRanking(teamId, { limit: 25 }) // 设置limit为25以获取所有成员
        ]);
        
        teamDetail.value = detailRes.data;
        conversionHistory.value = historyRes.data;
        memberRanking.value = rankingRes.data;
        
        // 初始化过滤后的成员列表
        if (memberRanking.value && memberRanking.value.rankings) {
          filteredMembers.value = [...memberRanking.value.rankings];
        }
        
        // 数据加载完成后，等待DOM更新再初始化图表
        nextTick(() => {
          initConversionChart();
          updateConversionChart();
          
          initMemberChart();
          updateMemberChart();
        });
      } catch (error) {
        console.error('获取团队详情数据失败:', error);
        ElMessage.error('获取团队详情数据失败，请稍后重试');
      } finally {
        detailLoading.value = false;
      }
    };
    
    // 查看详情（旧方法，保留兼容）
    const handleViewDetails = (row) => {
      openTeamDetail(row);
    };
    
    // 成员管理
    const handleManageMembers = (row) => {
      ElMessage.info(`即将跳转到团队 ${row.team_name} 的成员管理页面`);
      // 这里可以添加跳转逻辑或打开成员管理对话框
    };
    
    // 删除/解散团队
    const handleDelete = (row) => {
      teamToDelete.value = row;
      deleteVisible.value = true;
    };
    
    // 确认删除/解散团队
    const confirmDelete = async () => {
      if (!teamToDelete.value) return;
      
      deleting.value = true;
      
      try {
        await deleteTeam(teamToDelete.value.id);
        ElMessage.success('解散团队成功');
        deleteVisible.value = false;
        
        // 刷新列表
        loadTeamData();
      } catch (error) {
        console.error('解散团队失败:', error);
      } finally {
        deleting.value = false;
      }
    };
    
    // 提交表单
    const submitForm = async () => {
      if (!formRef.value) return;
      
      formRef.value.validate(async (valid) => {
        if (valid) {
          submitting.value = true;
          
          try {
            const params = {
              team_name: formData.team_name,
              leader_name: formData.leader_name,
              leader_password: formData.leader_password
            };
            
            // 添加可选字段
            if (formData.leader_email) params.leader_email = formData.leader_email;
            if (formData.leader_phone) params.leader_phone = formData.leader_phone;
            
            await addTeamAmbassador(params);
            ElMessage.success('添加团队成功');
            formVisible.value = false;
            
            // 刷新列表
            loadTeamData();
          } catch (error) {
            console.error('添加团队失败:', error);
            // request.js已经处理了错误提示
          } finally {
            submitting.value = false;
          }
        } else {
          ElMessage.warning('请正确填写表单信息');
          return false;
        }
      });
    };
    
    // 重置表单
    const resetForm = () => {
      if (formRef.value) {
        formRef.value.resetFields();
      }
      Object.assign(formData, {
        team_name: '',
        leader_name: '',
        leader_password: '',
        leader_email: '',
        leader_phone: ''
      });
    };
    
    // 打开添加团队对话框
    const handleAddTeam = () => {
      resetForm();
      formVisible.value = true;
    };
    
    // 辅助方法
    const formatDate = (dateStr) => {
      if (!dateStr) return '--';
      
      const date = new Date(dateStr);
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, '0');
      const day = String(date.getDate()).padStart(2, '0');
      const hours = String(date.getHours()).padStart(2, '0');
      const minutes = String(date.getMinutes()).padStart(2, '0');
      
      return `${year}-${month}-${day} ${hours}:${minutes}`;
    };
    
const formatCurrency = (value) => {
      if (value === undefined || value === null) return '0.00';
      return parseFloat(value).toFixed(2);
    };
    
    // 滚动事件处理
    const handleWheel = (event) => {
      // 阻止滚动冒泡到父元素
      event.stopPropagation();
    };

    // 查看成员详情
    const viewMemberDetail = (member) => {
      ElMessageBox.alert(
        `
        <div class="member-detail-dialog">
          <p><strong>用户ID:</strong> ${member.user_id}</p>
          <p><strong>用户名:</strong> ${member.username} ${member.is_leader ? '(领导人)' : ''}</p>
          <p><strong>电子邮箱:</strong> ${member.email || '未设置'}</p>
          <p><strong>手机号码:</strong> ${member.phone || '未设置'}</p>
          <p><strong>本期转化数:</strong> ${member.conversions || 0}</p>
          <p><strong>佣金金额:</strong> ${formatCurrency(member.commission)} 元</p>
        </div>
        `,
        `${member.username} 的详细信息`,
        {
          dangerouslyUseHTMLString: true,
          confirmButtonText: '关闭',
          customClass: 'member-detail-message-box'
        }
      );
    };

    // 过滤成员
    const memberSearchKeyword = ref('');
    const filteredMembers = ref([]);
    const filterMembers = () => {
      if (!memberRanking.value || !memberRanking.value.rankings) {
        filteredMembers.value = [];
        return;
      }
      const keyword = memberSearchKeyword.value.toLowerCase();
      filteredMembers.value = memberRanking.value.rankings.filter(member =>
        member.username.toLowerCase().includes(keyword)
      );
    };

    // 成员排序
    const handleMemberSortChange = ({ prop, order }) => {
      if (!filteredMembers.value || filteredMembers.value.length === 0) return;
      
      // 默认按转化数降序
      if (!prop || !order) {
        filteredMembers.value.sort((a, b) => b.conversions - a.conversions);
        return;
      }
      
      if (prop === 'conversions') {
        if (order === 'ascending') {
          filteredMembers.value.sort((a, b) => (a.conversions || 0) - (b.conversions || 0));
        } else if (order === 'descending') {
          filteredMembers.value.sort((a, b) => (b.conversions || 0) - (a.conversions || 0));
        }
      } else if (prop === 'commission') {
        if (order === 'ascending') {
          filteredMembers.value.sort((a, b) => parseFloat(a.commission || 0) - parseFloat(b.commission || 0));
        } else if (order === 'descending') {
          filteredMembers.value.sort((a, b) => parseFloat(b.commission || 0) - parseFloat(a.commission || 0));
        }
      }
};

// 显示添加成员对话框
const showAddMemberDialog = () => {
      if (!currentTeam.value || !currentTeam.value.id) {
        ElMessage.warning('请先选择团队');
        return;
      }
      
      // 重置表单
      memberFormData.username = '';
      memberFormData.email = '';
      memberFormData.phone = '';
      memberFormData.password = '88888888';
      
      // 显示对话框
      addMemberVisible.value = true;
    };

    // 处理删除成员
    const handleDeleteMember = (member) => {
      if (member.is_leader) {
        ElMessage.warning('团队领导人不能被删除');
        return;
      }
      
      memberToDelete.value = member;
      deleteMemberVisible.value = true;
    };

    // 提交添加成员表单
    const submitMemberForm = async () => {
      if (!memberFormRef.value || !currentTeam.value || !currentTeam.value.id) return;
      
      memberFormRef.value.validate(async (valid) => {
        if (valid) {
          addingMember.value = true;
          
          try {
            const memberData = {
              username: memberFormData.username,
              email: memberFormData.email || undefined,
              phone: memberFormData.phone || undefined,
              password: memberFormData.password || '88888888'
            };
            
            await addTeamMember(currentTeam.value.id, memberData);
            ElMessage.success('成员添加成功');
            addMemberVisible.value = false;
            
            // 刷新团队成员列表
            loadTeamDetailData(currentTeam.value.id);
          } catch (error) {
            console.error('添加成员失败:', error);
            // request.js已经处理了错误提示
          } finally {
            addingMember.value = false;
          }
        } else {
          ElMessage.warning('请正确填写成员信息');
          return false;
        }
      });
    };

    // 确认删除成员
    const confirmDeleteMember = async () => {
      if (!memberToDelete.value || !currentTeam.value || !currentTeam.value.id) return;
      
      deletingMember.value = true;
      
      try {
        await deleteTeamMember(currentTeam.value.id, memberToDelete.value.user_id);
        ElMessage.success('成员删除成功');
        deleteMemberVisible.value = false;
        
        // 刷新团队成员列表
        loadTeamDetailData(currentTeam.value.id);
      } catch (error) {
        console.error('删除成员失败:', error);
      } finally {
        deletingMember.value = false;
      }
    };

    // 添加成员对话框相关
    const addMemberVisible = ref(false);
    const memberFormRef = ref(null);
    const memberFormData = reactive({
      username: '',
      email: '',
      phone: '',
      password: '88888888'
    });
    const memberFormRules = {
      username: [
        { required: true, message: '请输入用户名', trigger: 'blur' },
        { min: 2, max: 20, message: '用户名长度需在2到20个字符之间', trigger: 'blur' }
      ],
      email: [
        { type: 'email', message: '请输入正确的电子邮箱格式', trigger: 'blur' }
      ],
      phone: [
        { pattern: /^1[3456789]\d{9}$/, message: '请输入正确的手机号码', trigger: 'blur' }
      ]
    };
    const addingMember = ref(false);

    // 删除成员对话框相关
    const deleteMemberVisible = ref(false);
    const memberToDelete = ref(null);
    const deletingMember = ref(false);

    // 团队领导人佣金明细对话框相关
    const leaderCommissionsVisible = ref(false);
    const loadingLeaderCommissions = ref(false);
    const leaderCommissionsData = ref({
      campInfo: null,
      commissions: []
    });

    /**
     * 查看团队领导人佣金明细
     * @param {Object} member - 团队成员
     */
    const viewLeaderCommissions = async (member) => {
      if (!member || !member.is_leader) {
        ElMessage.warning('只能查看团队领导人的佣金明细');
        return;
      }

      if (!currentTeam.value || !currentTeam.value.id) {
        ElMessage.warning('团队信息不完整，无法查看');
        return;
      }

      loadingLeaderCommissions.value = true;
      leaderCommissionsVisible.value = true;
      leaderCommissionsData.value = {
        campInfo: null,
        commissions: []
      };

      try {
        const response = await getTeamLeaderCommissions(currentTeam.value.id);
        console.log('团队领导人佣金明细响应:', response);
        
        if (response && response.data) {
          // 打印完整的响应数据，用于调试
          console.log('团队领导人佣金明细数据结构:', JSON.stringify(response.data));
          
          // 适应不同的可能API返回结构
          const campInfo = response.data.camp_info || response.data.campInfo;
          const commissions = response.data.commissions || response.data.details || [];
          
          // 为每个佣金明细项添加type字段（如果存在commission_type但不存在type）
          const processedCommissions = commissions.map(item => {
            const processedItem = { ...item };
            
            // 处理佣金类型字段
            if (item.commission_type && !item.type) {
              processedItem.type = item.commission_type;
            }
            
            // 处理佣金金额字段
            if (item.commission_amount && !item.amount) {
              processedItem.amount = item.commission_amount;
            }
            
            return processedItem;
          });
          
          leaderCommissionsData.value = {
            campInfo: campInfo,
            commissions: processedCommissions
          };
          
          // 如果仍然没有数据，尝试其他可能的格式
          if (!processedCommissions.length && response.data) {
            // 查找数组类型的属性，它可能包含佣金数据
            for (const key in response.data) {
              if (Array.isArray(response.data[key]) && response.data[key].length > 0) {
                console.log('发现可能的佣金数据数组:', key);
                // 同样处理可能的commission_type字段
                const items = response.data[key].map(item => {
                  const processedItem = { ...item };
                  
                  // 处理佣金类型字段
                  if (item.commission_type && !item.type) {
                    processedItem.type = item.commission_type;
                  }
                  
                  // 处理佣金金额字段
                  if (item.commission_amount && !item.amount) {
                    processedItem.amount = item.commission_amount;
                  }
                  
                  return processedItem;
                });
                leaderCommissionsData.value.commissions = items;
                break;
              }
            }
          }
        }
      } catch (error) {
        console.error('获取团队领导人佣金明细失败:', error);
        ElMessage.error('获取团队领导人佣金明细失败');
      } finally {
        loadingLeaderCommissions.value = false;
      }
    };

    /**
     * 获取佣金类型对应的标签类型
     * @param {string} type - 佣金类型
     * @returns {string} - 标签类型
     */
    const getCommissionTypeTag = (type) => {
      if (!type) return 'info';
      
      const typeMap = {
        // 英文类型
        'registration': 'success',
        'payment': 'primary',
        'referral': 'warning',
        'team': 'info',
        'leader': 'danger',
        // 可能的其他类型
        'ambassador_conversion': 'success',
        'leader_team_conversion': 'primary',
        'leader_team_bonus': 'warning',
        'promotion_bonus_fixed': 'danger',
        'promotion_bonus_percentage': 'info',
        'leader_conversion': 'success',
        'leader_team_performance': 'primary',
        // 中文类型
        '注册': 'success',
        '付款': 'primary',
        '推荐': 'warning',
        '团队': 'info',
        '领导': 'danger'
      };
      return typeMap[type] || 'info';
    };

    /**
     * 获取佣金类型对应的中文名称
     * @param {string} type - 佣金类型
     * @returns {string} - 中文名称
     */
    const getCommissionTypeName = (type) => {
      if (!type) return '未知类型';
      
      // 如果类型已经是中文，直接返回
      if (/[\u4e00-\u9fa5]/.test(type)) {
        return type;
      }
      
      const typeMap = {
        // 英文类型
        'registration': '注册佣金',
        'payment': '付款佣金',
        'referral': '推荐佣金',
        'team': '团队佣金',
        'leader': '领导佣金',
        // 可能的其他类型
        'ambassador_conversion': '直接推广佣金',
        'leader_team_conversion': '团队推广佣金',
        'leader_team_bonus': '团队奖金',
        'promotion_bonus_fixed': '晋升固定奖励',
        'promotion_bonus_percentage': '晋升比例奖励',
        'leader_conversion': '领导人推广佣金',
        'leader_team_performance': '团队绩效奖金'
      };
      return typeMap[type] || type;
    };

    // 团队成员佣金明细对话框相关
    const memberCommissionsVisible = ref(false);
    const loadingMemberCommissions = ref(false);
    const currentMember = ref(null);
    const memberCommissionsData = ref({
      campInfo: null,
      stats: null,
      commissions: []
    });

    /**
     * 查看团队成员佣金明细
     * @param {Object} member - 团队成员
     */
    const viewMemberCommissions = async (member) => {
      if (!member) {
        ElMessage.warning('成员信息不完整，无法查看');
        return;
      }

      if (!currentTeam.value || !currentTeam.value.id) {
        ElMessage.warning('团队信息不完整，无法查看');
        return;
      }

      // 如果是团队领导人，使用专门的领导人佣金查看功能
      if (member.is_leader) {
        viewLeaderCommissions(member);
        return;
      }

      currentMember.value = member;
      loadingMemberCommissions.value = true;
      memberCommissionsVisible.value = true;
      memberCommissionsData.value = {
        campInfo: null,
        stats: null,
        commissions: []
      };

      try {
        const response = await getTeamMemberCommissions(currentTeam.value.id, member.user_id);
        console.log('团队成员佣金明细响应:', response);
        
        if (response && response.data) {
          // 打印完整的响应数据，用于调试
          console.log('团队成员佣金明细数据结构:', JSON.stringify(response.data));
          
          // 适配不同的数据格式
          const campInfo = {
            camp_id: response.data.camp_id || response.data.campId,
            camp_name: response.data.camp_name || response.data.campName,
            start_date: response.data.start_date || response.data.startDate,
            end_date: response.data.end_date || response.data.endDate
          };
          
          const stats = {
            total_commission: response.data.total_commission || response.data.totalCommission || 0,
            conversion_count: response.data.conversion_count || response.data.conversionCount || 0
          };
          
          // 处理佣金明细数组
          const details = response.data.details || [];
          const processedDetails = details.map(item => {
            const processedItem = { ...item };
            
            // 处理佣金类型字段
            if (item.commission_type && !item.type) {
              processedItem.type = item.commission_type;
            }
            
            // 处理佣金金额字段
            if (item.commission_amount && !item.amount) {
              processedItem.amount = item.commission_amount;
            }
            
            return processedItem;
          });
          
          memberCommissionsData.value = {
            campInfo: campInfo,
            stats: stats,
            commissions: processedDetails
          };
        }
      } catch (error) {
        console.error('获取团队成员佣金明细失败:', error);
        ElMessage.error('获取团队成员佣金明细失败');
      } finally {
        loadingMemberCommissions.value = false;
      }
    };

    return {
      // 组件生命周期
      onBeforeUnmount,
      
      // 标签页
      activeTab,
      applicationCount,
      handleTabClick,
      refreshCurrentTab,
      
      // 图表相关
      conversionChartRef,
      memberChartRef,
      
      // 搜索和筛选
      searchQuery,
      handleSearch,
      
      // 团队表格数据
      teamList,
      loading,
      total,
      
      // 申请表格数据
      applicationList,
      applicationTotal,
      applicationPage,
      applicationPageSize,
      
      // 团队详情数据
      currentTeam,
      teamDetail,
      conversionHistory,
      memberRanking,
      detailLoading,
      openTeamDetail,
      handleViewDetails,
      
      // 申请备注
      remarksVisible,
      currentRemarks,
      showApplicationRemarks,
      
      // 批准/拒绝申请
      approveVisible,
      applicationToApprove,
      approving,
      handleApprove,
      confirmApprove,
      
      rejectVisible,
      applicationToReject,
      rejecting,
      handleReject,
      confirmReject,
      
      // 分页
      currentPage,
      pageSize,
      handleCurrentChange,
      handleSizeChange,
      handleSortChange,
      
      // 申请分页
      handleApplicationCurrentChange,
      handleApplicationSizeChange,
      handleApplicationSortChange,
      
      // 加载数据
      loadTeamData,
      loadApplicationData,
      
      // 表单相关
      formRef,
      formVisible,
      formData,
      formRules,
      submitting,
      handleAddTeam,
      resetForm,
      submitForm,
      
      // 辅助方法
      formatDate,
      formatCurrency,
      
      // 删除相关
      deleteVisible,
      teamToDelete,
      deleting,
      handleDelete,
      confirmDelete,
      
      // 滚动事件处理
      handleWheel,
      
      // 搜索相关
      applicationSearchQuery,
      
      // 查看成员详情
      viewMemberDetail,
      
      // 过滤成员
      memberSearchKeyword,
      filteredMembers,
      filterMembers,
      
      // 成员排序
      handleMemberSortChange,

      // 添加图标和工具函数
      markRaw,
      InfoFilled,

      // 添加成员对话框
      addMemberVisible,
      memberFormRef,
      memberFormData,
      memberFormRules,
      addingMember,
      submitMemberForm,
      showAddMemberDialog,

      // 删除成员确认对话框
      deleteMemberVisible,
      memberToDelete,
      deletingMember,
      confirmDeleteMember,
      handleDeleteMember,

      // 团队领导人佣金明细对话框
      leaderCommissionsVisible,
      loadingLeaderCommissions,
      leaderCommissionsData,
      viewLeaderCommissions,
      getCommissionTypeTag,
      getCommissionTypeName,
      
      // 团队成员佣金明细对话框
      memberCommissionsVisible,
      loadingMemberCommissions,
      currentMember,
      memberCommissionsData,
      viewMemberCommissions,
      
      // 图标
      Money,
    };
  }
};
</script>

<style scoped>
.team-ambassador-management {
  height: 100%;
  display: flex;
  flex-direction: column;
  gap: 16px;
  padding: 20px;
  background-color: #f6f8fa;
  overflow: auto; /* 使组件成为一个可滚动容器 */
  overscroll-behavior: contain; /* 防止滚动传播 */
  position: relative; /* 提供一个定位上下文 */
  scrollbar-width: thin; /* Firefox */
  scrollbar-color: #c0c4cc #f6f8fa; /* Firefox */
  user-select: none; /* 防止文字被选中，解决光标问题 */
}

/* 自定义滚动条样式 */
.team-ambassador-management::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

.team-ambassador-management::-webkit-scrollbar-track {
  background: #f6f8fa;
  border-radius: 4px;
}

.team-ambassador-management::-webkit-scrollbar-thumb {
  background-color: #c0c4cc;
  border-radius: 4px;
  border: 2px solid #f6f8fa;
}

.team-ambassador-management::-webkit-scrollbar-thumb:hover {
  background-color: #909399;
}

.table-card {
  flex: 1;
  background-color: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
  overflow: auto;
  min-height: 300px; /* 确保表格区域有最小高度 */
}

/* 自定义Element Plus表格样式 */
:deep(.el-table) {
  --el-table-border-color: #ebeef5;
  --el-table-border: 1px solid var(--el-table-border-color);
  border-radius: 6px;
  overflow: hidden;
}

:deep(.el-table--border) {
  border: 1px solid #ebeef5;
  border-right: none;
  border-bottom: none;
}

:deep(.el-table--border .el-table__cell) {
  border-right: 1px solid #ebeef5;
}

:deep(.el-table__row:hover td) {
  background-color: #ecf5ff !important;
}

.action-buttons-group {
  display: flex;
  gap: 12px;
  justify-content: center;
  align-items: center;
}

/* 操作按钮样式 */
.action-buttons-group :deep(.el-button--circle) {
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
}

.action-buttons-group :deep(.el-button--circle:hover) {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.action-buttons-group :deep(.el-button--circle:active) {
  transform: translateY(0);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.action-buttons-group :deep(.el-button--primary) {
  background-color: #409EFF;
}

.action-buttons-group :deep(.el-button--success) {
  background-color: #67C23A;
}

.action-buttons-group :deep(.el-button--danger) {
  background-color: #F56C6C;
}

.pagination-card {
  background-color: white;
  border-radius: 8px;
  padding: 16px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
  display: flex;
  justify-content: flex-end;
  flex-shrink: 0; /* 防止分页卡片收缩 */
}

/* 详情对话框样式 */
.detail-container {
  padding: 10px 0;
}

.detail-section {
  margin-bottom: 20px;
}

.detail-title {
  margin: 0 0 12px 0;
  font-size: 16px;
  font-weight: 600;
  color: #303133;
  position: relative;
  padding-left: 10px;
}

.detail-title:before {
  content: '';
  position: absolute;
  left: 0;
  top: 3px;
  height: 14px;
  width: 3px;
  background: #409EFF;
  border-radius: 2px;
}

/* 删除确认对话框样式 */
.delete-confirm-content,
.approve-confirm-content,
.reject-confirm-content {
  text-align: center;
  padding: 20px 0;
}

.delete-warning {
  margin-top: 16px;
  color: #E6A23C;
  font-size: 14px;
  background-color: #fdf6ec;
  padding: 8px 12px;
  border-radius: 4px;
}

/* 备注内容样式 */
.remarks-content {
  padding: 16px;
  min-height: 60px;
  background-color: #f5f7fa;
  border-radius: 4px;
  white-space: pre-line;
}

/* 表单样式 */
.team-form {
  padding: 10px 0;
}

:deep(.el-form-item__label) {
  font-weight: 500;
}

:deep(.el-input__inner) {
  border-radius: 4px;
}

:deep(.el-dialog__header) {
  padding: 20px;
  margin-right: 0;
  border-bottom: 1px solid #ebeef5;
}

:deep(.el-dialog__footer) {
  padding: 20px;
  border-top: 1px solid #ebeef5;
}

:deep(.el-dialog__body) {
  padding: 30px 20px;
}

/* 防止文本选择样式 */
:deep(.el-button),
:deep(.el-dialog__title),
:deep(.el-descriptions__label),
:deep(.el-descriptions__content),
:deep(.el-pagination *),
:deep(.el-tabs__item) {
  user-select: none;
}

.return-header {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 16px;
  background-color: white;
  border-radius: 8px;
  padding: 15px 20px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
  justify-content: space-between;
}

.return-header .left-section {
  display: flex;
  align-items: center;
}

.section-title {
  margin: 0;
  font-size: 18px;
  font-weight: 600;
  color: #303133;
  position: relative;
  padding-left: 12px;
}

.section-title:before {
  content: '';
  position: absolute;
  left: 0;
  top: 3px;
  height: 16px;
  width: 3px;
  background: #409EFF;
  border-radius: 2px;
}

.application-search {
  width: 300px;
}

.team-header {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 16px;
  background-color: white;
  border-radius: 8px;
  padding: 15px 20px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
  justify-content: space-between;
}

.team-header .left-section {
  display: flex;
  align-items: center;
}

.team-header h2 {
  margin: 0;
  font-size: 18px;
  font-weight: 600;
  color: #303133;
  position: relative;
  padding-left: 12px;
}

.team-header h2:before {
  content: '';
  position: absolute;
  left: 0;
  top: 3px;
  height: 16px;
  width: 3px;
  background: #409EFF;
  border-radius: 2px;
}

.right-section {
  display: flex;
  align-items: center;
  gap: 16px; /* 将原来的10px间距增加到16px，使按钮间距更均匀 */
}

.search-input {
  width: 280px;
  margin-right: 5px;
}

.action-btn {
  min-width: 100px;
  padding: 0 15px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.badge {
  margin-left: 5px;
  transform: scale(0.8);
}

.has-badge {
  background-color: #409EFF;
  color: white;
}

/* 团队详情页样式 */
.team-detail-view {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.detail-container {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.detail-card {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
  overflow: hidden;
}

.card-header {
  padding: 16px 20px;
  border-bottom: 1px solid #ebeef5;
  background-color: #f5f7fa;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-header-actions {
  display: flex;
  gap: 10px;
  align-items: center;
}

.add-member-btn {
  margin: 0;
  flex-shrink: 0;
}

.member-search-input {
  width: 250px;
  margin: 0;
}

.card-header h3 {
  margin: 0;
  font-size: 16px;
  font-weight: 600;
  color: #303133;
  position: relative;
  padding-left: 10px;
}

.card-header h3:before {
  content: '';
  position: absolute;
  left: 0;
  top: 3px;
  height: 14px;
  width: 3px;
  background: #409EFF;
  border-radius: 2px;
}

.card-content {
  padding: 20px;
}

.empty-data {
  padding: 32px;
  display: flex;
  justify-content: center;
}

.highlight-text {
  color: #409EFF;
  font-weight: 500;
}

.rank-badge {
  display: inline-block;
  width: 24px;
  height: 24px;
  border-radius: 50%;
  text-align: center;
  line-height: 24px;
  font-weight: bold;
  color: white;
}

.rank-1 {
  background-color: #f56c6c;
}

.rank-2 {
  background-color: #e6a23c;
}

.rank-3 {
  background-color: #409EFF;
}

.rank-badge:not(.rank-1):not(.rank-2):not(.rank-3) {
  background-color: #909399;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 8px;
}

/* 图表容器样式 */
.chart-container {
  width: 100%;
  height: 320px; /* 减小图表高度 */
  margin: 0 auto;
}

/* 在小屏幕上适应高度和布局 */
@media (max-width: 1200px) {
  .charts-row {
    flex-direction: column;
  }
  
  .chart-card {
    width: 100%;
}

.chart-container {
  height: 300px;
  }
}

@media (max-width: 768px) {
  .chart-container {
    height: 250px;
  }
}

.leader-tag {
  margin-right: 5px;
}

.commission-text {
  font-weight: 500;
  color: #67c23a;
}

.member-detail-dialog p {
  margin: 10px 0;
  line-height: 1.5;
}

.member-detail-message-box .el-message-box__content {
  padding: 20px;
}

.member-detail-message-box .el-message-box__header {
  background-color: #f5f7fa;
  padding: 15px 20px;
}

.member-detail-message-box .el-message-box__title {
  font-size: 16px;
  font-weight: 600;
}

.charts-row {
  display: flex;
  gap: 20px;
  width: 100%;
  margin-bottom: 20px;
}

.chart-card {
  flex: 1;
  min-width: 0; /* 防止内容超出容器 */
}

.camp-info-card {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
  overflow: hidden;
}

.camp-info-header {
  padding: 16px 20px;
  border-bottom: 1px solid #ebeef5;
  background-color: #f5f7fa;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.camp-info-content {
  padding: 16px 20px;
}

.commission-table-card {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
  overflow: hidden;
}

.commission-table-header {
  padding: 16px 20px;
  border-bottom: 1px solid #ebeef5;
  background-color: #f5f7fa;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.commission-table-content {
  padding: 16px 20px;
}

.commission-amount {
  font-weight: 500;
  color: #67c23a;
}

/* 团队领导人佣金明细对话框样式 */
.leader-commissions-dialog {
  .camp-info-section {
    margin-bottom: 20px;
    border: 1px solid #ebeef5;
    border-radius: 4px;
    padding: 15px;
    background-color: #f8f9fa;
  }

  .commissions-section {
  margin-top: 20px;
  }

  h3 {
  font-size: 16px;
    color: #303133;
  margin-bottom: 15px;
  font-weight: 600;
  }
}

/* 响应式调整 */
@media (max-width: 768px) {
  .leader-commissions-dialog {
    width: 95% !important;
  }
}

/* 团队成员佣金明细对话框样式 */
.member-commissions-dialog {
  .camp-info-section {
    margin-bottom: 20px;
    border: 1px solid #ebeef5;
    border-radius: 4px;
    padding: 15px;
    background-color: #f8f9fa;
  }

  .member-stats-section {
    margin-top: 20px;
  }

  h3 {
  font-size: 16px;
    color: #303133;
  margin-bottom: 15px;
  font-weight: 600;
  }
}

/* 响应式调整 */
@media (max-width: 768px) {
  .member-commissions-dialog {
    width: 95% !important;
  }
}

.button-group {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-left: 30px;
}

.button-group :deep(.el-button--circle) {
  width: 48px;
  height: 48px;
  font-size: 18px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s;
  box-shadow: 0 2px 12px rgba(64, 158, 255, 0.3);
}

.button-group :deep(.el-button--circle:hover) {
  transform: translateY(-3px);
  box-shadow: 0 4px 18px rgba(64, 158, 255, 0.5);
}

.button-group :deep(.el-button--circle:active) {
  transform: translateY(0);
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.4);
}

.button-group .has-badge {
  position: relative;
}

.button-group .badge {
  position: absolute;
  top: -5px;
  right: -5px;
  transform: scale(0.8);
}

.application-btn {
  position: relative;
}

.application-badge {
  position: absolute;
  top: -8px;
  right: -8px;
}

.application-badge :deep(.el-badge__content) {
  border: none;
}

/* 对话框中的图标按钮样式 */
.dialog-footer :deep(.el-button--circle) {
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
  margin-left: 12px;
}

.dialog-footer :deep(.el-button--circle:hover) {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.dialog-footer :deep(.el-button--circle:active) {
  transform: translateY(0);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

/* 响应式调整 */
</style> 