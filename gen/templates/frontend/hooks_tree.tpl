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

    // 加载树形数据
    const loadTreeData = async () => {
        loading.value = true;
        try {
            const response = await fetchTreeList();
            if (response && response.data && response.data.list) {
                treeDataList.value = response.data.list;
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
        loadTreeData
    };
};