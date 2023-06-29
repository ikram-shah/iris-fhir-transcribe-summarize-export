<template>
  <div>
    <div class="flex h-screen overflow-hidden">
      <!-- Sidebar -->
      <div class="sidebar bg-gray-200 text-gray-800 flex-none">
        <hr class="border-t border-gray-300" />
        <div class="p-4">
          <div class="max-w-sm mx-auto">
            <div class="ml-4">
              <p class="text-lg font-semibold">
                {{ activePatient.firstName }} {{ activePatient.lastName }}
              </p>
              <p class="text-sm text-gray-600">ID: {{ activePatient.id }}</p>
            </div>
          </div>
          <hr class="my-4 border-t border-gray-300" />
          <ul class="space-y-2">
            <li>
              <a
                @click="changePage('Interactions')"
                href="#"
                :class="{
                  'block p-2 rounded bg-blue-600 text-white':
                    activePage === 'Interactions',
                  'block p-2 rounded': activePage !== 'Interactions',
                }"
              >
                <font-awesome-icon
                  icon="fa-exchange-alt"
                  class="mr-2"
                ></font-awesome-icon>
                Interactions
              </a>
            </li>
            <li>
              <a
                @click="changePage('Observations')"
                href="#"
                :class="{
                  'block p-2 rounded bg-blue-600 text-white':
                    activePage === 'Observations',
                  'block p-2 rounded': activePage !== 'Observations',
                }"
              >
                <font-awesome-icon
                  icon="fa-eye"
                  class="mr-2"
                ></font-awesome-icon>
                Observations
              </a>
            </li>
            <li>
              <a
                @click="changePage('Encounters')"
                href="#"
                :class="{
                  'block p-2 rounded bg-blue-600 text-white':
                    activePage === 'Encounters',
                  'block p-2 rounded': activePage !== 'Encounters',
                }"
              >
                <font-awesome-icon
                  icon="fa-calendar"
                  class="mr-2"
                ></font-awesome-icon>
                Visits
              </a>
            </li>
          </ul>
          <hr class="my-4 border-t border-gray-300" />
          <p class="font-bold mb-4"> Documents</p>
          <ul class="space-y-2">
            <li>
              <a
                @click="changePage('DocumentsSearch')"
                href="#"
                :class="{
                  'block p-2 rounded bg-blue-600 text-white':
                    activePage === 'DocumentsSearch',
                  'block p-2 rounded': activePage !== 'DocumentsSearch',
                }"
              >
                <font-awesome-icon
                  icon="fa-search"
                  class="mr-2"
                ></font-awesome-icon>
                Search
              </a>
            </li>
          </ul>
          <ul class="space-y-2">
            <li class="mt-2">
              <a
                @click="changePage('DocumentsPage')"
                href="#"
                :class="{
                  'block p-2 rounded bg-blue-600 text-white':
                    activePage === 'DocumentsPage',
                  'block p-2 rounded': activePage !== 'DocumentsPage',
                }"
              >
                <font-awesome-icon
                  icon="fa-history"
                  class="mr-2"
                ></font-awesome-icon>
                History
              </a>
            </li>
          </ul>
        </div>
      </div>

      <!-- Main Content -->
      <div class="flex-1 overflow-auto bg-white">
        <slot :activeTopPage="activePage"></slot>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    activePage: {
      type: String,
      required: true,
    },
    activePatient: {
      type: Object,
      required: true,
    },
  },
  methods: {
    changePage(page) {
      this.$emit("pageChange", page);
    },
  },
};
</script>

<style>
.sidebar {
  width: 300px;
  box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
}
</style>
