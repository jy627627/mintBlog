<!--
 * @Author: your name
 * @Date: 2021-05-17 22:05:37
 * @LastEditTime: 2022-02-02 19:03:41
 * @LastEditors: LSC
 * @Description: 主页面
 * @FilePath: \bohe\src\views\Home.vue
-->
<template>
  <div class="home-page">
    <!-- <pre>{{ biggerColumnLen }}</pre> -->
    <section class="py-5 text-center container">
      <div class="row py-lg-5">
        <div class="col-lg-6 col-md-8 mx-auto">
          <img src="../assets/callout.svg" alt="callout" class="w-50" />
          <h2 class="font-weight-light">这里有你想知道的一切</h2>

          <p>
            <a
              href="#"
              class="btn btn-primary my-2"
              style="background-color: #20c997;border:1px solid #20c997;"
              >开始写文章啦</a
            >
          </p>
        </div>
      </div>
    </section>
    <h4 class="font-weight-bold text-center">发现精彩</h4>
    <column-list :list="list"></column-list>
    <div
      class="btn-outline-primary btn mt-2 mb-5  m-auto w-25"
      style="display: block;"
      @click="loadMorePage"
      v-if="!isLastPage"
    >
      加载更多
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed, onMounted } from 'vue'
import { useStore } from 'vuex'

import { GlobalDataProps } from '../store'
import ColumnList from '../components/ColumnList.vue'
import useLoadMore from '../hooks/useLoadMore'

export default defineComponent({
  name: 'Home',
  components: {
    ColumnList
  },
  setup() {
    // GlobalDataProps获得类型补全
    const store = useStore<GlobalDataProps>()
    // !vuex的数据多从计算属性里面读取 在getter中读取
    const list = computed(() => store.getters.getColumns)
    const total = computed(() => store.state.columns.total)
    onMounted(() => {
      // 异步方法
      store.dispatch('fetchColumns', { pageSize: 3 }) // 获取文章
    })
    const { loadMorePage, isLastPage } = useLoadMore('fetchColumns', total, {
      pageSize: 3,
      currentPage: 2
    })
    return {
      list,
      loadMorePage,
      isLastPage
    }
  }
})
</script>
