<template>
  <div>
    <div class="flex m-6">
      <button
        class="flex items-center justify-center bg-blue-500 text-white text-l font-semibold py-2 px-4 rounded-md"
        @click="handleButtonClick"
      >
        <font-awesome-icon class="text-white mr-2" icon="microphone" />
        Take Notes
      </button>
      <div v-if="isRecording" class="flex items-center justify-center ml-4">
        <div class="rounded-full h-4 w-4 bg-red-500 mr-2"></div>
        <p class="text-gray-600">Recording...</p>
      </div>
    </div>

    <div v-if="transcription" class="flex m-6">
      <div class="w-1/2 pr-4">
        <h2 class="text-xl font-semibold mb-4">Summary</h2>
        <textarea
          class="w-full h-48 p-4 bg-gray-100 rounded-lg mb-4"
          v-model="summary"
        ></textarea>
        <div class="flex">
          <button
            class="px-4 py-2 bg-blue-500 text-white rounded-lg"
            @click="saveDocument(this.summary)"
          >
            Save as Document
          </button>
        </div>
      </div>
      <div class="w-1/2 pl-4">
        <h2 class="text-xl font-semibold mb-4">Transcript</h2>
        <div class="bg-gray-100 p-4 rounded-lg h-48 overflow-auto">
          <p>{{ transcription }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      isRecording: false,
      mediaRecorder: null,
      chunks: [],
      transcription: "",
      summary: "",
    };
  },
  methods: {
    handleButtonClick() {
      if (this.isRecording === false) {
        this.isRecording = true;
        this.startRecording();
      } else {
        this.isRecording = false;
        this.stopRecording();
      }
    },
    async startRecording() {
      try {
        const stream = await navigator.mediaDevices.getUserMedia({
          audio: true,
        });
        this.mediaRecorder = new MediaRecorder(stream);
        this.mediaRecorder.start();

        this.mediaRecorder.ondataavailable = (event) => {
          this.chunks.push(event.data);
        };
        this.isRecording = true;
      } catch (error) {
        console.error("Error starting recording:", error);
      }
    },
    async sendAudioToWhisper(blob) {
      const apiKey = process.env.OPENAI_API_KEY;
      const formData = new FormData();
      formData.append("file", blob);
      formData.append("model", "whisper-1");
      formData.append("response_format", "json");
      formData.append("temperature", "0");
      formData.append("language", "en");

      try {
        const response = await fetch(
          "https://api.openai.com/v1/audio/transcriptions",
          {
            method: "POST",
            headers: {
              Accept: "application/json",
              Authorization: `Bearer ${apiKey}`,
            },
            body: formData,
            redirect: "follow",
          }
        );

        const data = await response.json();
        if (data.text) {
          this.transcription = data.text;
        }
      } catch (error) {
        console.error("Error sending audio to Whisper API:", error);
      }

      return this.transcription;
    },
    getSummary(transcription) {
      var myHeaders = new Headers();
      myHeaders.append("Authorization", "Basic U3VwZXJVc2VyOlNZUw==");

      var raw = JSON.stringify({ text: transcription });

      var requestOptions = {
        method: "POST",
        headers: myHeaders,
        body: raw,
        redirect: "follow",
      };

      fetch(`/fhir/api/summarize`, requestOptions)
        .then((response) => response.json())
        .then((result) => {
          console.log(result);
          this.summary = result.summary;
        })
        .catch((error) => {
          console.log("error", error);
        });
    },
    formatDate(dateTime) {
      const date = new Date(dateTime);
      return date.toLocaleDateString();
    },
    stopRecording() {
      if (this.mediaRecorder) {
        this.mediaRecorder.stop();
        this.mediaRecorder.onstop = async () => {
          const blob = new Blob(this.chunks, {
            type: "audio/webm;codecs=opus",
          });
          await this.sendAudioToWhisper(
            new File([blob], `file${Date.now()}.m4a`)
          );

          this.getSummary(this.transcription);
        };
      }
    },
    saveDocument(summary) {
      var myHeaders = new Headers();
      myHeaders.append("Authorization", "Basic U3VwZXJVc2VyOlNZUw==");

      var raw = JSON.stringify({
        //todo: patient ID and practitioner ID
        patientId: 1,
        practitionerId: 3,
        base64payload: summary,
        mimeType: "application/pdf",
      });

      var requestOptions = {
        method: "POST",
        headers: myHeaders,
        body: raw,
        redirect: "follow",
      };

      fetch(`/fhir/api/documentreference`, requestOptions)
        .then((response) => response.json())
        .then((result) => {
          if (result.id) {
            alert("Document added successfully!")
          } else {
            alert("Document addition failed")
          }
        })
        .catch((error) => {
          console.log("error", error);
        });
    },
  },
};
</script>
