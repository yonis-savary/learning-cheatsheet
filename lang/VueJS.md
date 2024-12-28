

<p align="center">
<img src="https://cdn.icon-icons.com/icons2/2699/PNG/512/vuejs_logo_icon_169247.png" width="400">
</p>


Resources
- [Using vue with laravel](https://vueschool.io/articles/vuejs-tutorials/the-ultimate-guide-for-using-vue-js-with-laravel/)

SFC (Single File Component)

## Properties

properties declared through `reactive` and `ref` can be used in templates and will trigger a render on change

```html
<script setup>
import { reactive, ref, computed } from 'vue'

const myFirstProp = reactive({
    some: object
});

const mySecondProp = ref("Some string")

const third = ref(["some", "array"]);

const computedValues = computed(_ =>
    third.filter(x => x != "some")
)

</script>
```

```html
<p> {{ mySecondProp }} </p>
<p> {{ third.join(", ") }} </p>
```

## Reference to DOM Element

```html
<script setup>
    const myLabel = ref(null)

    onMounted(_ => {
    pElementRef.value.textContent = "Hey"
    });
</script>

<template>
    <p ref="myLabel"></p>
</template>
```


## Attribute Binding

```js

const sectionClass = ref("base-class")

```

```html
<!-- syntax a v-bind:<attribute-name> -->
<p v-bind:class="sectionClass">

<!-- shorthand syntax a v-bind:<attribute-name> -->
<p :class="sectionClass">
```

## Event listeners

```js
const count = ref(0)

const increment = _ => count.value++
```

```html
<button @mouseenter="increment">Count is: {{ count }}</button>
<!-- or -->
<button v-on:mouseenter="increment">Count is: {{ count }}</button>
```

## Form Binding

Traditionnal way

```html
<input :value="text" @input="onInput">

<script>
    function onInput(e) {
    // a v-on handler receives the native DOM event
    // as the argument.
    text.value = e.target.value
    }
</script>
```

Bind way

```html
<input v-model="text">
```



## Conditionnal Rendering

```html
<script setup>
import { ref } from 'vue'

const awesome = ref(true)

function toggle() {
  awesome.value = !awesome.value
}
</script>

<template>
  <button @click="toggle">Toggle</button>
  <h1 v-if="awesome">Vue is awesome!</h1>
  <h1 v-else>Oh no 😢</h1>
</template>
```


## Loop rendering

```html
<script setup>
import { ref } from 'vue'

// give each todo a unique id
let id = 0

const newTodo = ref('')
const todos = ref([
  { id: id++, text: 'Learn HTML' },
  { id: id++, text: 'Learn JavaScript' },
  { id: id++, text: 'Learn Vue' }
])

function addTodo() {
  todos.value.push({id: id++, text: newTodo.value})
  newTodo.value = ''
}

function removeTodo(todo) {
  todos.value = todos.value.filter(x => x !== todo)
}
</script>

<template>
  <form @submit.prevent="addTodo">
    <input v-model="newTodo" required placeholder="new todo">
    <button>Add Todo</button>
  </form>
  <ul>
    <li v-for="todo in todos" :key="todo.id">
      {{ todo.text }}
      <button @click="removeTodo(todo)">X</button>
    </li>
  </ul>
</template>
```


## Watchers

```js
import { ref, watch } from 'vue'

const count = ref(0)

watch(count, (newCount) => {
  // yes, console.log() is a side effect
  console.log(`new count is: ${newCount}`)
})
```


## Components

ChildComp.vue

```html
<script setup>
    const props = defineProps({
        msg: String
    })
</script>
<template>
    {{ msg || 'No value passed !' }}
    <slot>Default name !</slot>
</template>
```


```html
<script>
    import ChildComp from './ChildComp.vue'
</script>

<template>
    <ChildComp msg="Hello there">
        Custom Name !
    </ChildComp>
</template>
```


## Emitters

ChildComp.vue
```html
<script setup>
const emit = defineEmits(['response'])

emit('response', 'hello from child')
</script>

<template>
  <h2>Child component</h2>
</template>
```

root.vue

```html
<script setup>
import { ref } from 'vue'
import ChildComp from './ChildComp.vue'

const childMsg = ref('No child msg yet')
</script>

<template>
  <ChildComp @response="(msg) => childMsg = msg"/>
  <p>{{ childMsg }}</p>
</template>
```


## Add Vue to Laravel

```bash
npm install vue vue-router @vitejs/plugin-vue
```

`vite.config.js`
```js
// import { defineConfig } from "vite";
// import laravel from "laravel-vite-plugin";
+ import vue from "@vitejs/plugin-vue";

export default defineConfig({
    plugins: [
        + vue(),
        // laravel({
        //     input: ["resources/css/app.css", "resources/js/app.js"],
        //     refresh: true,
        // }),
    ],
    + resolve: {
    +     alias: {
    +         vue: "vue/dist/vue.esm-bundler.js",
    +     },
    + },
});
```

`resources/js/app.js`
```js
import "./bootstrap";
import { createApp } from "vue";

import App from "./App.vue";

createApp(App).mount("#app");
```


`resources/views/welcome.blade.php`
```php
<head>
    @vite(['resources/js/app.js'])
</head>

<body>
    <div id="app"></div>
</body>
```


Run Vite & Laravel

```
npm run dev
php artisan serve
```


Add `vue-router`

`app/router.js`
```js
import { createRouter, createWebHistory } from "vue-router";

const routes = [];

export default createRouter({
    history: createWebHistory(),
    routes: [

      {
          path: "/",
          component: () => import("./Pages/HomeRoute.vue"),
      },
    ]
});
```

Then call the `use` method in `app.js`

```js
// Replace
createApp(App).mount("#app");
// with
createApp(App).use(router).mount("#app");
```

```html
<router-link to="/test"> Take me to Test page </router-link>
```