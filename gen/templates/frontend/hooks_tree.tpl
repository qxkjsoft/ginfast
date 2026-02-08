import { ref, computed } from 'vue';
import type { {{.StructName}}Data, {{.StructName}}Result, {{.StructName}}TreeListResult } from '../api/{{.FileName}}';
import {
    create{{.StructName}},
    update{{.StructName}},
    delete{{.StructName}},
    get{{.StructName}},
    get{{.StructName}}TreeList
} from '../api/{{.FileName}}';

export const use{{.StructName}}PluginHook = () => {
    // State
    const loading = ref<boolean>(false);
    const treeDataList = ref<{{.StructName}}Data[]>([]);

    // Computed
    const isLoading = computed(() => loading.value);
    const getTreeDataList = computed(() => treeDataList.value);

    // Actions
    const createData = async (data: Omit<{{.StructName}}Data, '{{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}}'>) => {
        try {
            const response = await create{{.StructName}}(data);
            return response;
        } catch (error) {
            throw error;
        }
    };

    const updateData = async (data: Partial<{{.StructName}}Data>) => {
        try {
            const response = await update{{.StructName}}(data);
            return response;
        } catch (error) {
            throw error;
        }
    };

    const deleteData = async ({{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}}: {{if .PrimaryKey}}{{.PrimaryKey.FrontendType}}{{else}}number{{end}}) => {
        try {
            await delete{{.StructName}}({{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}});
        } catch (error) {
            throw error;
        }
    };

    // 根据ID获取用户详情
    const getDetail = async ({{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}}: {{if .PrimaryKey}}{{.PrimaryKey.FrontendType}}{{else}}number{{end}}) : Promise<{{.StructName}}Result> => {
        try {
            const response = await get{{.StructName}}({{if .PrimaryKey}}{{.PrimaryKey.JsonTag}}{{else}}id{{end}});
            return response;
        } catch (error) {
            throw error;
        }
    };

    // 获取树形列表（不管理loading状态，供内部使用）
    const fetchTreeList = async (): Promise<{{.StructName}}TreeListResult> => {
        const response: {{.StructName}}TreeListResult = await get{{.StructName}}TreeList();
        return response;
    };

    // 设置树形数据
    const setTreeDataList = (data: {{.StructName}}Data[]) => {
        treeDataList.value = data;
    };

    // 过滤树形数据
    const filterTreeData = (data: {{.StructName}}Data[], keyword: string): {{.StructName}}Data[] => {
        const filtered: {{.StructName}}Data[] = [];
        
        for (const item of data) {
            // 检查当前节点是否匹配
            const matches = item.name.toLowerCase().includes(keyword.toLowerCase());
            
            // 检查子节点是否匹配
            let filteredChildren: {{.StructName}}Data[] = [];
            if (item.children && item.children.length > 0) {
                filteredChildren = filterTreeData(item.children, keyword);
            }
            
            // 如果当前节点匹配或有匹配的子节点，则包含该节点
            if (matches || filteredChildren.length > 0) {
                const newItem = { ...item };
                if (filteredChildren.length > 0) {
                    newItem.children = filteredChildren;
                } else if (item.children && item.children.length > 0) {
                    newItem.children = []; // 有子节点但都不匹配，清空
                }
                filtered.push(newItem);
            }
        }
        
        return filtered;
    };

    // 加载树形数据（包含过滤功能）
    const loadTreeData = async (keyword?: string) => {
        loading.value = true;
        try {
            const response = await fetchTreeList();
            if (response && response.data && response.data.list) {
                // 根据搜索条件过滤数据
                if (keyword) {
                    treeDataList.value = filterTreeData(response.data.list, keyword);
                } else {
                    treeDataList.value = response.data.list;
                }
            }
        } finally {
            loading.value = false;
        }
    };

    return {
        // State
        loading,
        treeDataList,

        // Computed
        isLoading,
        getTreeDataList,

        // Actions
        createData,
        updateData,
        deleteData,
        getDetail,
        fetchTreeList,
        setTreeDataList,
        filterTreeData,
        loadTreeData
    };
};