<template>
    <div class="container mx-auto p-8">
      <div class="flex justify-left items-center mb-8">
        <div class="bg-blue-600 text-white px-4 py-2 rounded-lg">
          Welcome, Dr. John Doe
        </div>
      </div>
      <div class="grid grid-cols-2 gap-8">
        <div class="bg-white p-8 rounded-lg shadow-custom hover:shadow-l">
          <h2 class="text-xl font-bold mb-4">Patients</h2>
          <div class="flex items-center justify-between mb-4">
            <div class="text-4xl font-bold">50</div>
            <div class="text-gray-500">Total Patients</div>
          </div>
          <button class="text-blue-600 hover:text-blue-800">View Patients</button>
        </div>
        <div class="bg-white p-8 rounded-lg shadow-custom hover:shadow-l">
          <h2 class="text-xl font-bold mb-4">Observations</h2>
          <div class="flex items-center justify-between mb-4">
            <div class="text-4xl font-bold">120</div>
            <div class="text-gray-500">Total Observations</div>
          </div>
          <button class="text-blue-600 hover:text-blue-800">View Observations</button>
        </div>
      </div>
      <!-- Add more relevant details for the doctor's home page -->
    </div>
  </template>
  
  <script>
  export default {
    // Component logic goes here
  };
  </script>
  
  <style>
  .shadow-custom {
    box-shadow: 0 0 8px rgba(0, 0, 0, 0.1);
  }
  
  .shadow-custom-hover:hover {
    box-shadow: 0 0 12px rgba(26, 65, 193, 0.2);
  }
  </style>
  