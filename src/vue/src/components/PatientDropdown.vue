<template>
  <form>
    <label
      for="default-search"
      class="mb-2 text-sm font-medium text-gray-900 sr-only dark:text-white"
      >Search</label
    >
    <div class="relative">
      <div
        class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none"
      >
        <svg
          aria-hidden="true"
          class="w-5 h-5 text-gray-500 dark:text-gray-400"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
          xmlns="http://www.w3.org/2000/svg"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
          ></path>
        </svg>
      </div>
      <input
        v-model="searchTerm"
        type="search"
        id="default-search"
        class="block w-1/2 pl-10 pr-4 py-2 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
        placeholder="Search Mockups, Logos..."
        required
      />
    </div>
  </form>
  <ul
    v-if="searchResults.length > 0"
    class="mt-2 bg-white border border-gray-300 rounded-lg shadow-md dark:bg-gray-800"
  >
    <li
      v-for="patient in searchResults"
      :key="patient[0]"
      @click="selectPatient(patient)"
      class="py-2 px-4 cursor-pointer hover:bg-gray-100 dark:hover:bg-gray-700"
    >
      {{ patient[1] }} {{ patient[2] }} (ID: {{ patient[0] }})
    </li>
  </ul>
  <div v-else-if="isLoading" class="mt-2 text-gray-600 dark:text-gray-400">
    Loading patients...
  </div>
  <div v-else class="mt-2 text-gray-600 dark:text-gray-400">
    No patients found.
  </div>
  <div v-if="selectedPatient" class="mt-2">
    <h2 class="text-lg font-medium text-gray-900 dark:text-white">
      Selected Patient:
    </h2>
    <p class="text-gray-700 dark:text-gray-300">
      Name: {{ selectedPatient[1] }} {{ selectedPatient[2] }}
    </p>
    <p class="text-gray-700 dark:text-gray-300">ID: {{ selectedPatient[0] }}</p>
  </div>
</template>

<script>
export default {
  data() {
    return {
      searchTerm: "",
      searchResults: [],
      allPatients: [
        ["1", "O'Hara248", "Carroll471", "1954-06-13", "male"],
        ["172", "Jast432", "Frankie174", "1975-08-12", "male"],
        ["459", "Rohan584", "Gabriele201", "2009-05-04", "female"],
        ["705", "Frami345", "Kallie862", "1945-12-19", "female"],
        ["1002", "Davis923", "Lean294", "1945-12-19", "female"],
        ["1510", "Hettinger594", "Margie619", "1995-03-26", "female"],
      ],
      selectedPatient: null,
      isLoading: false,
    };
  },
  methods: {
    search() {
      if (this.searchTerm === "") {
        this.searchResults = [];
      } else {
        const searchTermLC = this.searchTerm.toLowerCase();
        this.searchResults = this.allPatients.filter((patient) => {
          const name = `${patient[1]} ${patient[2]}`.toLowerCase();
          const id = patient[0].toLowerCase();
          return name.includes(searchTermLC) || id.includes(searchTermLC);
        });
      }
    },
    selectPatient(patient) {
      this.selectedPatient = patient;
      this.searchTerm = "";
      this.searchResults = [];
    },
  },
  watch: {
    searchTerm: function (newTerm) {
      if (newTerm === "") {
        this.searchResults = [];
      } else {
        const searchTermLC = newTerm.toLowerCase();
        this.searchResults = this.allPatients.filter((patient) => {
          const name = `${patient[1]} ${patient[2]}`.toLowerCase();
          const id = patient[0].toLowerCase();
          return name.includes(searchTermLC) || id.includes(searchTermLC);
        });
      }
    },
  },
};
</script>
