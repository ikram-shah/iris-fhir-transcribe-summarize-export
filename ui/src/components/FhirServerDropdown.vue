<template>
    <div class="relative inline-block text-left">
      <button id="dropdownDefaultButton" @click="toggleDropdown" class="text-white bg-blue-600 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-4 py-2.5 text-center inline-flex items-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800" type="button">
        FHIR Server
        <svg class="w-4 h-4 ml-2" aria-hidden="true" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
        </svg>
      </button>
      <!-- Dropdown menu -->
      <div v-if="showDropdown" id="dropdown" class="z-10 bg-white divide-y divide-gray-100 rounded-lg shadow w-44 dark:bg-gray-700">
        <ul class="py-2 text-sm text-gray-700 dark:text-gray-200" aria-labelledby="dropdownDefaultButton">
          <li v-for="server in servers" :key="server.id">
            <a href="#" class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white" @click="selectServer(server)">{{ server.name }}</a>
          </li>
        </ul>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        servers: [
          { id: 1, name: "FHIR Server 1" },
          { id: 2, name: "FHIR Server 2" },
          // Add more servers as needed
        ],
        showDropdown: false,
        selectedServer: null,
      };
    },
    methods: {
      toggleDropdown() {
        this.showDropdown = !this.showDropdown;
      },
      selectServer(server) {
        this.selectedServer = server;
        this.showDropdown = false;
      },
    },
  };
  </script>