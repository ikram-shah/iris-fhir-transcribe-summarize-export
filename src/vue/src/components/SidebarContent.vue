<template>
    <div class="flex h-screen overflow-hidden">
      <!-- Sidebar -->
      <div class="sidebar bg-gray-200 text-gray-800 flex-none">
        <div class="p-4">
          <div class="flex items-center mb-4">
            <img src="../assets/logo.png" alt="Logo" class="w-8 h-8 mr-2" />
            <h1 class="text-xl font-bold">AI Voice to Summary</h1>
          </div>
          <hr class="my-4 border-t border-gray-300" />
          <ul class="space-y-2">
            <li>
              <a @click="changePage('Home')" href="#" :class="{'block p-2 rounded bg-blue-600 text-white': activePage === 'Home', 'block p-2 rounded': activePage !== 'Home'}">
                <font-awesome-icon
                  icon="fa-home"
                  class="mr-2"
                ></font-awesome-icon>
                Dashboard
              </a>
            </li>
            <li>
              <a @click="changePage('Interactions')" href="#" :class="{'block p-2 rounded bg-blue-600 text-white': activePage === 'Interactions', 'block p-2 rounded': activePage !== 'Interactions'}">
                <font-awesome-icon
                  icon="fa-exchange-alt"
                  class="mr-2"
                ></font-awesome-icon>
                Interactions
              </a>
            </li>
            <li>
              <a @click="changePage('Patients')" href="#" :class="{'block p-2 rounded bg-blue-600 text-white': activePage === 'Patients', 'block p-2 rounded': activePage !== 'Patients'}">
                <font-awesome-icon
                  icon="fa-user"
                  class="mr-2"
                ></font-awesome-icon>
                Patients
              </a>
            </li>
            <li>
              <a @click="changePage('Observations')" href="#" :class="{'block p-2 rounded bg-blue-600 text-white': activePage === 'Observations', 'block p-2 rounded': activePage !== 'Observations'}">
                <font-awesome-icon icon="fa-eye" class="mr-2"></font-awesome-icon>
                Observations
              </a>
            </li>
          </ul>
          <hr class="my-4 border-t border-gray-300" />
          <ul class="space-y-2">
            <li>
              <a @click="changePage('Settings')" href="#" :class="{'block p-2 rounded bg-blue-600 text-white': activePage === 'Settings', 'block p-2 rounded': activePage !== 'Settings'}">
                <font-awesome-icon icon="fa-cog" class="mr-2"></font-awesome-icon>
                Settings
              </a>
            </li>
          </ul>
        </div>
      </div>
  
      <!-- Main Content -->
      <div class="flex-1 overflow-auto bg-white">
        <slot :activePage="activePage"></slot>
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
        practitioners: [
          { id: 1, name: "Practitioner 1" },
          { id: 2, name: "Practitioner 2" },
          // Add more servers as needed
        ],
        showSeDropdown: false,
        showPrDropdown: false,
        selectedServer: null,
        selectedPractitioner: null,
      };
    },
    props: {
      activePage: {
        type: String,
        required: true,
      },
    },
    methods: {
      changePage(page) {
        this.$emit("pageChange", page);
      },
      toggleSeDropdown() {
        this.showSeDropdown = !this.showSeDropdown;
      },
      togglePrDropdown() {
        this.showPrDropdown = !this.showPrDropdown;
      },
     
  
   selectServer(server) {
        this.selectedServer = server;
        this.showDropdown = false;
      },
      selectPractitioner(practitioner) {
        this.selectedPractitioner = practitioner;
        this.showDropdown = false;
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