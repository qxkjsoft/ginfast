<template>
  <div class="snow-page">
     <div class="snow-inner">
         <s-fold-page :width="280">
             <template #sider>
                 <div class="left-box">
                     <a-input v-model="categorySearchKeyword" placeholder="请输入{{.RelationFieldComment}}名称" @input="onCategorySearch" @clear="onCategorySearch"
                         allow-clear>
                         <template #prefix>
                             <icon-search />
                         </template>
                     </a-input>
                     <div class="tree-box">
                         <a-tree ref="categoryTreeRef" :field-names="categoryFieldNames" :data="filteredCategoryTreeData" show-line
                             @select="onSelectCategoryTree">
                             <template #extra="nodeData">
                                 <a-space size="small">
                                     <icon-plus style="cursor: pointer; color: #165dff;" @click.stop="handleCreateCategory(nodeData)" />
                                     <icon-edit style="cursor: pointer; color: #165dff;" @click.stop="handleEditCategory(nodeData)" />
                                     <a-popconfirm content="确定要删除该{{.RelationFieldComment}}吗？" @ok="handleDeleteCategory(nodeData)">
                                         <icon-delete style="cursor: pointer; color: #f53f3f;" />
                                     </a-popconfirm>
                                 </a-space>
                             </template>
                         </a-tree>
                     </div>
                 </div>
             </template>

             <template #content>
                 <div class="right-box">
                     <a-card :loading="loading" :bordered="false">
                         <a-space wrap>
                             <!-- 查询表单-->
{{- range .Columns}}
{{- if .QueryShow}}
                             {{- if and (eq .QueryType "BETWEEN") (eq .GoType "time.Time")}}
                             <!-- {{.Comment}}范围查询（日期类型专用） -->
                             <a-range-picker v-model="searchForm.{{.JsonTag}}Range" style="width: 240px;" @change="handleSearch" />
                             {{- else if or (eq .FormType "radio") (eq .FormType "select") (eq .FormType "checkbox")}}
                             <!-- {{.Comment}}选择框查询（radio/select/checkbox统一使用select） -->
                             <a-select v-model="searchForm.{{.JsonTag}}" placeholder="请选择{{.Comment}}" style="width: 240px;" allow-clear>
                                 {{- if ne .DictType ""}}
                                 <a-option v-for="item in {{.JsonTag}}Option" :key="item.value" :value="{{if eq .FrontendType "number"}}Number(item.value){{else}}item.value{{end}}">{{`{{ item.name }}`}}</a-option>
                                 {{- end}}
                             </a-select>
                             {{- else if and (eq .QueryType "LIKE") (ne .FrontendType "number")}}
                             <!-- {{.Comment}}模糊查询（仅非数值类型支持） -->
                             <a-input-search v-model="searchForm.{{.JsonTag}}" placeholder="请输入{{.Comment}}搜索" style="width: 240px;" @search="handleSearch" allow-clear />
                             {{- else if and (eq .QueryType "LIKE") (eq .FrontendType "number")}}
                             <!-- {{.Comment}}数值类型不支持模糊查询，使用精确查询 -->
                             <a-input-number v-model="searchForm.{{.JsonTag}}" placeholder="请输入{{.Comment}}" style="width: 240px;" @change="handleSearch" />
                             {{- else}}
                             <!-- {{.Comment}}精确查询 -->
                             {{- if eq .FrontendType "number"}}
                             <a-input-number v-model="searchForm.{{.JsonTag}}" placeholder="请输入{{.Comment}}" style="width: 240px;" />
                             {{- else if eq .GoType "time.Time"}}
                             <a-date-picker v-model="searchForm.{{.JsonTag}}" placeholder="请选择{{.Comment}}" style="width: 240px;" />
                             {{- else}}
                             <a-input v-model="searchForm.{{.JsonTag}}" placeholder="请输入{{.Comment}}" style="width: 240px;" />
                             {{- end}}
                             {{- end}}
{{- end}}
{{- end}}
                             <a-button type="primary" @click="handleSearch">查询</a-button>
                             <a-button @click="handleReset">重置</a-button>
                             <a-button type="primary" @click="handleCreate" v-hasPerm="['plugins:{{.DirName}}{{.FileName}}:add']">
                                 <template #icon>
                                     <icon-plus />
                                 </template>
                                 <span>新增数据</span>
                             </a-button>
                         </a-space>

                         <a-table :data="dataList" :loading="loading" :pagination="paginationConfig"
                             :bordered="{ wrapper: true, cell: true }" @page-change="handlePageChange"
                             @page-size-change="handlePageSizeChange">
                             <template #columns>
{{- range .Columns}}
{{- if .ListShow}}
                                 {{- if eq .GoType "time.Time"}}
                                 <a-table-column title="{{.Comment}}" data-index="{{.JsonTag}}"  :width="150"  ellipsis tooltip>
                                     <template #cell="{ record }">
                                         {{`{{ record['`}}{{.JsonTag}}{{`'] ? formatTime(record['`}}{{.JsonTag}}{{`']) : "" }}`}}
                                     </template>
                                 </a-table-column>
                                 {{- else}}
                                 <a-table-column title="{{.Comment}}" data-index="{{.JsonTag}}"  :width="150"  ellipsis tooltip/>
                                 {{- end}}
{{- end}}
{{- end}}
                                 <a-table-column title="操作" :width="200">
                                     <template #cell="{ record }">
                                         <a-space>
                                             <a-button size="small" @click="handleEdit(record)" v-hasPerm="['plugins:{{.DirName}}{{.FileName}}:edit']">
                                                 编辑
                                             </a-button>
                                             <a-popconfirm content="确定要删除这条数据吗？" @ok="handleDelete(record.{{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}})">
                                                 <a-button size="small" status="danger" v-hasPerm="['plugins:{{.DirName}}{{.FileName}}:delete']">
                                                     删除
                                                 </a-button>
                                             </a-popconfirm>
                                         </a-space>
                                     </template>
                                 </a-table-column>
                             </template>
                         </a-table>

                     </a-card>

                     <!-- 编辑/创建弹窗 -->
                     <a-modal v-model:visible="modalVisible" :title="editingData.{{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}} ? '编辑数据' : '新增数据'" :on-before-ok="handleSave"
                         @cancel="handleCancel">
                         <a-form :model="editingData" :rules="rules" ref="formRef">
                             <a-form-item field="{{.RelationFieldJsonTag}}" label="{{.RelationFieldComment}}">
                                 <a-tree-select
                                     v-model="editingData.{{.RelationFieldJsonTag}}"
                                     :data="categoryTreeData"
                                     :field-names="categoryFieldNames"
                                     placeholder="请选择{{.RelationFieldComment}}"
                                     allow-clear
                                 />
                             </a-form-item>
{{- range .Columns}}
{{- if and (not .IsPrimary) (not .Exclude) .FormShow}}
                             <a-form-item field="{{.JsonTag}}" label="{{.Comment}}">
                                 {{- if eq .FrontendType "number"}}
                                 {{- if or (eq .FormType "") (eq .FormType "number")}}
                                 <a-input-number v-model="editingData.{{.JsonTag}}" placeholder="请输入{{.Comment}}" />
                                 {{- else if eq .FormType "select"}}
                                 <a-select v-model="editingData.{{.JsonTag}}" placeholder="请选择{{.Comment}}">
                                 {{- if ne .DictType ""}}
                                     <a-option v-for="item in {{.JsonTag}}Option" :key="item.value" :value="{{if eq .FrontendType "number"}}Number(item.value){{else}}item.value{{end}}">{{`{{ item.name }}`}}</a-option>
                                 {{- end}}
                                 </a-select>
                                 {{- else if eq .FormType "radio"}}
                                 <a-radio-group v-model="editingData.{{.JsonTag}}">
                                 {{- if ne .DictType ""}}
                                     <a-radio v-for="item in {{.JsonTag}}Option" :key="item.value" :value="{{if eq .FrontendType "number"}}Number(item.value){{else}}item.value{{end}}">{{`{{ item.name }}`}}</a-radio>
                                 {{- end}}
                                 </a-radio-group>
                                 {{- else}}
                                 <a-input-number v-model="editingData.{{.JsonTag}}" placeholder="请输入{{.Comment}}" />{{- end}}
                                 {{- else if eq .GoType "time.Time"}}
                                 {{- if eq .FormType "input"}}
                                 <a-input v-model="editingData.{{.JsonTag}}" placeholder="请输入{{.Comment}}" />
                                 {{- else if eq .FormType "select"}}
                                 <a-select v-model="editingData.{{.JsonTag}}" placeholder="请选择{{.Comment}}">
                                 {{- if ne .DictType ""}}
                                     <a-option v-for="item in {{.JsonTag}}Option" :key="item.value" :value="{{if eq .FrontendType "number"}}Number(item.value){{else}}item.value{{end}}">{{`{{ item.name }}`}}</a-option>
                                 {{- end}}
                                 </a-select>
                                 {{- else if eq .FormType "radio"}}
                                 <a-radio-group v-model="editingData.{{.JsonTag}}">
                                     {{- if ne .DictType ""}}
                                     <a-radio v-for="item in {{.JsonTag}}Option" :key="item.value" :value="{{if eq .FrontendType "number"}}Number(item.value){{else}}item.value{{end}}">{{`{{ item.name }}`}}</a-radio>
                                     {{- end}}
                                 </a-radio-group>
                                 {{- else}}
                                 <a-date-picker value-format="YYYY-MM-DDTHH:mm:ss[Z]" v-model="editingData.{{.JsonTag}}" placeholder="请选择{{.Comment}}" />{{- end}}
                                 {{- else}}
                                 {{- if eq .FormType "textarea"}}
                                 <a-textarea v-model="editingData.{{.JsonTag}}" placeholder="请输入{{.Comment}}" />
                                 {{- else if eq .FormType "number"}}
                                 <a-input-number v-model="editingData.{{.JsonTag}}" placeholder="请输入{{.Comment}}" />
                                 {{- else if eq .FormType "select"}}
                                 <a-select v-model="editingData.{{.JsonTag}}" placeholder="请选择{{.Comment}}">
                                 {{- if ne .DictType ""}}
                                     <a-option v-for="item in {{.JsonTag}}Option" :key="item.value" :value="{{if eq .FrontendType "number"}}Number(item.value){{else}}item.value{{end}}">{{`{{ item.name }}`}}</a-option>
                                 {{- end}}
                                 </a-select>
                                 {{- else if eq .FormType "radio"}}<a-radio-group v-model="editingData.{{.JsonTag}}">
                                 {{- if ne .DictType ""}}
                                     <a-radio v-for="item in {{.JsonTag}}Option" :key="item.value" :value="{{if eq .FrontendType "number"}}Number(item.value){{else}}item.value{{end}}">{{`{{ item.name }}`}}</a-radio>
                                 {{- end}}
                                 </a-radio-group>
                                 {{- else if eq .FormType "checkbox"}}
                                 <a-checkbox-group
                                     :modelValue="editingData.{{.JsonTag}} ? JSON.parse(editingData.{{.JsonTag}}) : []"
                                     @update:modelValue="(val: any) => editingData.{{.JsonTag}} = val.length > 0 ? JSON.stringify(val) : undefined">
                                 {{- if ne .DictType ""}}
                                     <a-checkbox v-for="item in {{.JsonTag}}Option" :key="item.value" :value="{{if eq .FrontendType "number"}}Number(item.value){{else}}item.value{{end}}">{{`{{ item.name }}`}}</a-checkbox>
                                 {{- end}}
                                 </a-checkbox-group>
                                 {{- else if eq .FormType "datetime"}}<a-date-picker value-format="YYYY-MM-DDTHH:mm:ss[Z]" v-model="editingData.{{.JsonTag}}" placeholder="请选择{{.Comment}}" />
                                 {{- else if eq .FormType "file"}}
                                 <FileUpload v-model="editingData.{{.JsonTag}}" title="{{.Comment}}" />
                                 {{- else if eq .FormType "image"}}
                                 <ImageUpload v-model="editingData.{{.JsonTag}}" title="{{.Comment}}" />
                                 {{- else if eq .FormType "images"}}
                                 <MultiImageUpload v-model="{{.JsonTag}}List" title="{{.Comment}}" />
                                 {{- else if eq .FormType "richtext"}}
                                 <WangEditor v-model="editingData.{{.JsonTag}}" />
                                 {{- else}}<a-input v-model="editingData.{{.JsonTag}}" placeholder="请输入{{.Comment}}" />{{- end}}
                                 {{- end}}
                             </a-form-item>
{{- end}}
{{- end}}
                         </a-form>
                     </a-modal>
                 </div>

                 <!-- {{.RelationFieldComment}}编辑弹窗 -->
                 <a-modal v-model:visible="categoryModalVisible" :title="editingCategoryData.id ? '编辑{{.RelationFieldComment}}' : '新增{{.RelationFieldComment}}'" :on-before-ok="handleSaveCategory"
                     @cancel="handleCancelCategory">
                     <a-form :model="editingCategoryData" :rules="categoryRules" ref="categoryFormRef">
                         <a-form-item field="parentId" label="父级">
                             <a-tree-select
                                 v-model="editingCategoryData.parentId"
                                 :data="categoryTreeData"
                                 :field-names="categoryFieldNames"
                                 placeholder="请选择父级"
                                 allow-clear
                             />
                         </a-form-item>
                         <a-form-item field="name" label="名称">
                             <a-input v-model="editingCategoryData.name" placeholder="请输入名称" />
                         </a-form-item>
                     </a-form>
                 </a-modal>
             </template>
         </s-fold-page>
     </div>
</div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue';
import { use{{.StructName}}PluginHook } from '../../hooks/{{.FileName}}';
import type { {{.StructName}}Data } from '../../api/{{.FileName}}';
import { get{{.RelationTreeStructName}}TreeList, type {{.RelationTreeStructName}}Data, create{{.RelationTreeStructName}}, update{{.RelationTreeStructName}}, delete{{.RelationTreeStructName}} } from '../../api/{{.RelationTreeFileName}}';
import { formatTime } from '@/globals';
{{- $hasImageUpload := false}}
{{- $hasMultiImageUpload := false}}
{{- $hasWangEditor := false}}
{{- $hasFileUpload := false}}
{{- range .Columns}}
{{- if and (eq .GoType "string") (eq .FormType "image")}}
{{- if not $hasImageUpload}}
{{- $hasImageUpload = true}}
import ImageUpload from '@/components/upload/image-upload.vue';
{{- end}}
{{- else if and (eq .GoType "string") (eq .FormType "images")}}
{{- if not $hasMultiImageUpload}}
{{- $hasMultiImageUpload = true}}
import MultiImageUpload from '@/components/upload/multi-image-upload.vue';
{{- end}}
{{- else if and (eq .GoType "string") (eq .FormType "richtext")}}
{{- if not $hasWangEditor}}
{{- $hasWangEditor = true}}
import WangEditor from '@/components/wang-editor/index.vue';
{{- end}}
{{- else if and (eq .GoType "string") (eq .FormType "file")}}
{{- if not $hasFileUpload}}
{{- $hasFileUpload = true}}
import FileUpload from '@/components/upload/file-upload.vue';
{{- end}}
{{- end}}
{{- end}}
{{- range .Columns}}
{{- if and (not .IsPrimary) (not .Exclude) (ne .DictType "")}}
    {{- if .FormShow}}
const {{.JsonTag}}Option = ref(dictFilter("{{.DictType}}"));
    {{- end}}
{{- end}}
{{- end}}
const {
    dataList,
    loading,
    total,
    currentPage,
    pageSize,
    fetchDataList,
    createData,
    updateData,
    deleteData,
    getDetail,
    resetSearchParams
} = use{{.StructName}}PluginHook();

const modalVisible = ref(false);
const formRef = ref();

// {{.RelationFieldComment}}编辑相关
const categoryModalVisible = ref(false);
const categoryFormRef = ref();
const editingCategoryData = reactive<Partial<{{.RelationTreeStructName}}Data>>({
    id: undefined,
    parentId: undefined,
    name: undefined,
});

const categoryRules = {
    name: [{ required: true, message: '名称不能为空' }],
};

// 搜索表单
const searchForm = reactive({
{{- range .Columns}}
{{- if .QueryShow}}
    {{.JsonTag}}: undefined,
{{- end}}
{{- end}}
});

const editingData = reactive<Partial<{{.StructName}}Data>>({
    id: undefined,
{{- range .Columns}}
{{- if and (not .IsPrimary) (not .Exclude) .FormShow}}
    {{.JsonTag}}: undefined,
{{- end}}
{{- end}}
});

const rules = {
{{- range .Columns}}
{{- if and (not .IsPrimary) (not .Exclude) .FormShow .Required}}
    {{.JsonTag}}: [{ required: true, message: '{{.Comment}}不能为空' }],
{{- end}}
{{- end}}
};

// 分页配置
const paginationConfig = computed(() => ({
    total: total.value,
    current: currentPage.value,
    pageSize: pageSize.value,
    showTotal: true,
    showJumper: true,
    showPageSize: true,
    pageSizeOptions: [10, 20, 30, 50],
}));

// 获取数据列表
const loadData = async (pageNum: number = currentPage.value, pageSizeVal: number = pageSize.value) => {
    const params: any = {
        pageNum,
        pageSize: pageSizeVal,
    };
{{- range .Columns}}
{{- if .QueryShow}}
    if (searchForm.{{.JsonTag}}) {
        params.{{.JsonTag}} = searchForm.{{.JsonTag}};
    }
{{- end}}
{{- end}}
    // 如果有选中的{{.RelationFieldComment}}，则添加{{.RelationFieldComment}}ID参数用于过滤
    if (selectedCategoryIds.value.length > 0) {
        params.{{.RelationFieldJsonTag}}Ids = selectedCategoryIds.value;
    }
    await fetchDataList(params);
};

// 处理分页变化
const handlePageChange = (page: number) => {
    loadData(page, pageSize.value);
};

// 处理页面大小变化
const handlePageSizeChange = (size: number) => {
    loadData(1, size); // 页码重置为1
};

// 搜索处理
const handleSearch = () => {
    loadData(1); // 搜索时重置到第一页
};

// 重置搜索
const handleReset = () => {
{{- range .Columns}}
{{- if .QueryShow}}
    searchForm.{{.JsonTag}} = undefined;
{{- end}}
{{- end}}
    resetSearchParams();
    // 重置{{.RelationFieldComment}}搜索关键字
    categorySearchKeyword.value = "";
    // 重置{{.RelationFieldComment}}选择
    selectedCategoryIds.value = [];
    // 清空树的选中状态
    if (categoryTreeRef.value) {
        categoryTreeRef.value.selectAll(false);
    }
    // 重新加载完整的{{.RelationFieldComment}}树
    filteredCategoryTreeData.value = categoryTreeData.value;
    loadData(1);
};

// 新增数据
const handleCreate = () => {
    // 重置表单数据
    Object.assign(editingData, {
        id: undefined,
{{- range .Columns}}
{{- if and (not .IsPrimary) (not .Exclude) .FormShow}}
        {{.JsonTag}}: undefined,
{{- end}}
{{- end}}
    });
    modalVisible.value = true;
};

// 编辑数据
const handleEdit = async (record: {{.StructName}}Data) => {
    // 获取详情
    const detail = await getDetail(record.{{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}});
    // 赋值给编辑数据
    Object.assign(editingData, detail.data);
    modalVisible.value = true;
};

// 删除数据
const handleDelete = async (id: {{if .PrimaryKey}}{{.PrimaryKey.FrontendType}}{{else}}number{{end}}) => {
    try {
        await deleteData(id);
        // 重新加载当前页数据
        await loadData();
        // 显示删除成功消息
        // 这里可以使用项目的消息提示机制
    } catch (error) {
        // 显示删除失败消息
        console.error('删除失败:', error);
    }
};

// 保存数据
const handleSave = async () => {
    const isValid = await formRef.value?.validate();
    if (isValid) return false;
    try {
        const dataToSave = JSON.parse(JSON.stringify(editingData));
        if (editingData.id) {
            // 更新数据
            await updateData(dataToSave);
        } else {
            // 创建数据
            await createData(dataToSave);
        }
        // 重新加载数据
        await loadData();
    } catch (error) {
        console.error('保存失败:', error);
        return false;
    }
    return true;
};

// 取消操作
const handleCancel = () => {
    modalVisible.value = false;
};

// 新增{{.RelationFieldComment}}
const handleCreateCategory = (nodeData: any) => {
    // 重置表单数据
    Object.assign(editingCategoryData, {
        id: undefined,
        parentId: undefined,
        name: undefined,
    });
    // 设置父级ID
    if (nodeData?.id) {
        editingCategoryData.parentId = nodeData.id;
    }
    categoryModalVisible.value = true;
};

// 编辑{{.RelationFieldComment}}
const handleEditCategory = (nodeData: any) => {
    Object.assign(editingCategoryData, {
        id: nodeData.id,
        parentId: nodeData.parentId,
        name: nodeData.name,
    });
    categoryModalVisible.value = true;
};

// 删除{{.RelationFieldComment}}
const handleDeleteCategory = async (nodeData: any) => {
    try {
        await delete{{.RelationTreeStructName}}(nodeData.id);
        // 重新加载{{.RelationFieldComment}}树
        await getCategoryTree();
    } catch (error) {
        console.error('删除{{.RelationFieldComment}}失败:', error);
    }
};

// 保存{{.RelationFieldComment}}
const handleSaveCategory = async () => {
    const isValid = await categoryFormRef.value?.validate();
    if (isValid) return false;
    try {
        const dataToSave = JSON.parse(JSON.stringify(editingCategoryData));
        if (editingCategoryData.id) {
            // 更新{{.RelationFieldComment}}
            await update{{.RelationTreeStructName}}(dataToSave);
        } else {
            // 创建{{.RelationFieldComment}}
            await create{{.RelationTreeStructName}}(dataToSave);
        }
        // 重新加载{{.RelationFieldComment}}树
        await getCategoryTree();
    } catch (error) {
        console.error('保存{{.RelationFieldComment}}失败:', error);
        return false;
    }
    return true;
};

// 取消{{.RelationFieldComment}}编辑
const handleCancelCategory = () => {
    categoryModalVisible.value = false;
};

// {{.RelationFieldComment}}树相关
const categorySearchKeyword = ref("");
const selectedCategoryIds = ref<number[]>([]);
const categoryFieldNames = ref({
    key: "id",
    title: "name",
    children: "children"
});
const categoryTreeData = ref();
const filteredCategoryTreeData = ref();
const categoryTreeRef = ref();

// {{.RelationFieldComment}}搜索处理函数
const onCategorySearch = () => {
    if (!categorySearchKeyword.value) {
        // 如果搜索关键字为空，显示完整的{{.RelationFieldComment}}树
        filteredCategoryTreeData.value = categoryTreeData.value;
        return;
    }

    // 过滤{{.RelationFieldComment}}树数据
    const filterTree = (nodes: any[]) => {
        if (!nodes || nodes.length === 0) return [];

        const result = [];
        for (const node of nodes) {
            // 检查当前节点是否匹配搜索关键字
            const isMatch = node.name.includes(categorySearchKeyword.value);

            // 递归过滤子节点
            const filteredChildren = filterTree(node.children);

            // 如果当前节点匹配或者有匹配的子节点，则保留该节点
            if (isMatch || filteredChildren.length > 0) {
                const newNode = { ...node };
                // 如果当前节点匹配，显示所有子节点
                // 如果当前节点不匹配，但子节点匹配，则只显示匹配的子节点
                newNode.children = isMatch ? node.children : filteredChildren;
                result.push(newNode);
            }
        }
        return result;
    };

    filteredCategoryTreeData.value = filterTree(categoryTreeData.value);
};

// 通过ID在树中查找节点
const findCategoryNodeById = (nodes: any[], id: number): any => {
    for (const node of nodes) {
        if (node.id === id) {
            return node;
        }
        if (node.children && node.children.length > 0) {
            const found = findCategoryNodeById(node.children, id);
            if (found) {
                return found;
            }
        }
    }
    return null;
};

// 递归获取节点及其所有子节点的ID
const getAllCategoryChildrenIds = (node: any): number[] => {
    let ids: number[] = [node.id];

    if (node.children && node.children.length > 0) {
        node.children.forEach((child: any) => {
            ids = ids.concat(getAllCategoryChildrenIds(child));
        });
    }

    return ids;
};

// 获取{{.RelationFieldComment}}列表
const getCategoryTree = async () => {
    let { data } = await get{{.RelationTreeStructName}}TreeList();
    categoryTreeData.value = data.list;
    filteredCategoryTreeData.value = data.list;
    setTimeout(() => {
        categoryTreeRef.value.expandAll();
    }, 0);
};

// {{.RelationFieldComment}}树选择事件处理
const onSelectCategoryTree = (selectedKeys: any[]) => {
    // 获取选中{{.RelationFieldComment}}及其子{{.RelationFieldComment}}的ID集合
    if (selectedKeys.length > 0 && categoryTreeData.value) {
        // 获取选中的节点
        const selectedNodeId = selectedKeys[0];
        const selectedNode = findCategoryNodeById(categoryTreeData.value, selectedNodeId);

        if (selectedNode) {
            // 获取该节点及其所有子节点的ID
            selectedCategoryIds.value = getAllCategoryChildrenIds(selectedNode);
        } else {
            selectedCategoryIds.value = [];
        }
    } else {
        selectedCategoryIds.value = [];
    }

    // 重新加载数据
    currentPage.value = 1;
    loadData();
};

onMounted(async () => {
    // 初始化加载数据
    await getCategoryTree();
    await loadData();
})

</script>

<style scoped lang="scss">
.container {
    display: flex;
    column-gap: $padding;

    .left-box {
        display: flex;
        flex-direction: column;
        width: 250px;
        height: 100%;
        flex-shrink: 0; // 防止被压缩

        .tree-box {
            flex: 1;
            overflow: auto;
        }
    }

    .right-box {
        flex: 1;
        min-width: 0; // 防止 flex 子元素溢出
    }
}
</style>
