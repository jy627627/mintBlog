<!--
 * @Author: your name
 * @Date: 2021-05-21 14:01:58
 * @LastEditTime: 2021-05-21 15:02:25
 * @LastEditors: Please set LastEditors
 * @Description: 登录页面开始
 //TODO: 需要实现重复密码的校验过程
 * @FilePath: \bohe\src\views\Signup.vue
-->
<template>
  <div class="signup-page mx-auto p-3 w-330">
    <h5 class="my-4 text-center">注册薄荷账户</h5>
    <validate-form @form-submit="onFormSubmit">
      <div class="mb-3">
        <label class="form-label">邮箱地址</label>
        <validate-input
          :rules="emailRules"
          v-model="formData.email"
          placeholder="请输入邮箱地址"
          type="text"
        />
      </div>
      <div class="mb-3">
        <label class="form-label">昵称</label>
        <validate-input
          :rules="nameRules"
          v-model="formData.nickName"
          placeholder="请输入昵称"
          type="text"
        />
      </div>
      <div class="mb-3">
        <label class="form-label">密码</label>
        <validate-input
          type="password"
          placeholder="请输入密码"
          :rules="passwordRules"
          v-model="formData.password"
        />
      </div>
      <div class="mb-3">
        <label class="form-label">重复密码</label>
        <validate-input
          type="password"
          placeholder="请再次密码"
          :rules="repeatPasswordRules"
          v-model="formData.repeatPassword"
        />
      </div>
      <template #submit>
        <button type="submit" class="btn btn-primary btn-block btn-large text-center">
          注册新用户
        </button>
      </template>
    </validate-form>
  </div>
</template>

<script lang="ts">
import { defineComponent, reactive, toRefs } from 'vue'
import { useRouter } from 'vue-router'
import axios from 'axios'
import ValidateInput, { RulesProp } from '../components/ValidateInput.vue'
import ValidateForm from '../components/ValidateForm.vue'
import createMessage from '../components/CreateMessage'

export default defineComponent({
  name: 'Signup',
  components: {
    ValidateInput,
    ValidateForm
  },
  setup() {
    // !四个字段采用reactive
    const formData = reactive({
      email: '',
      nickName: '',
      password: '',
      repeatPassword: ''
    })
    const router = useRouter()
    const emailRules: RulesProp = [
      { type: 'required', message: '电子邮箱地址不能为空' },
      { type: 'email', message: '请输入正确的电子邮箱格式' }
    ]
    const nameRules: RulesProp = [{ type: 'required', message: '昵称不能为空' }]
    const passwordRules: RulesProp = [{ type: 'required', message: '密码不能为空' }]
    const repeatPasswordRules: RulesProp = [
      { type: 'required', message: '重复密码不能为空' },
      // !自定义校验规则函数
      {
        type: 'custom',
        validator: () => {
          // 返回一个boolean值，代表密码是否相等
          return formData.password === formData.repeatPassword
        },
        message: '两次输入密码不相同'
      }
    ]
    // 转换

    // 提交注册信息
    const onFormSubmit = (result: boolean) => {
      if (result) {
        const payload = {
          email: formData.email,
          password: formData.password,
          nickName: formData.nickName
        }
        // *由于就这个页面用到了注册接口,直接映入axios发送请求就行
        axios
          .post('/users/', payload)
          .then((data) => {
            createMessage('注册成功 2s后跳转登录页面', 'success')
            setTimeout(() => {
              router.push('/login')
            }, 2000)
          })
          .catch((e) => {
            console.log(e)
          })
      }
    }
    // const { email, nickName, password, repeatPassword } = toRefs(formData)
    return {
      emailRules,
      nameRules,
      passwordRules,
      repeatPasswordRules,
      onFormSubmit,
      formData
    }
  }
})
</script>

<style>
.w-330 {
  max-width: 330px;
}
</style>
