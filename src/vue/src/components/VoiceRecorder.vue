<template>
  <div>
    <div class="recorder_wrapper">
      <div class="recorder">
        <button
          class="record_btn"
          id="button"
          @click="handleButtonClick"
        ></button>
        <span v-if="isRecording" class="ml-2 text-red-500">Recording...</span>
      </div>
    </div>

    <!-- <button
      @click="startRecording"
      :disabled="isRecording"
      class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
    >
      Start Recording
    </button>
    <button
      @click="stopRecording"
      :disabled="!isRecording"
      class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
    >
      Stop Recording
    </button> -->
    <div v-if="transcription" class="mt-4 bg-gray-100 p-4 rounded">
      <p>{{ transcription }}</p>
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
      const apiKey = "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";
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
        };
      }
    },
  },
};
</script>

<style>
@import "https://fonts.googleapis.com/icon?family=Material+Icons|Roboto";

.recorder_wrapper {
  width: 100%;
  display: -webkit-flex;
  display: -moz-flex;
  display: -ms-flex;
  display: -o-flex;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
}

.recorder {
  display: inline-block;
  text-align: center;
  width: 500px;
  max-width: 100%;
}

.record_btn {
  width: 50px;
  height: 50px;
  font-family: "Material Icons";
  font-size: 24px;
  color: #e74c3c;
  background: none;
  border: 2px solid #e74c3c;
  border-radius: 50%;
  cursor: pointer;
  transition: 0.15s linear;
}

.record_btn:hover {
  transition: 0.15s linear;
  transform: scale(1.05);
}

.record_btn:active {
  background: #f5f5f5;
}

.record_btn:after {
  content: "\E029";
}

.record_btn[disabled] {
  border: 2px solid #ccc;
}

.record_btn[disabled]:after {
  content: "\E02B";
  color: #ccc;
}

.record_btn[disabled]:hover {
  transition: 0.15s linear;
  transform: none;
}

.record_btn[disabled]:active {
  background: none;
}

.recording {
  animation: recording 2s infinite ease-in-out;
  position: relative;
}

.recording:before {
  content: "";
  display: inline-block;
  position: absolute;
  top: 50%;
  left: 50%;
  width: 0px;
  height: 0px;
  margin: 0px;
  border-radius: 50%;
  background: rgba(0, 0, 0, 0.05);
  animation: recording_before 2s infinite ease-in-out;
}

@keyframes recording {
  from {
    transform: scale(1.1);
  }

  50% {
    transform: none;
  }

  to {
    transform: scale(1.1);
  }
}

@keyframes recording_before {
  80% {
    width: 200px;
    height: 200px;
    margin: -100px;
    opacity: 0;
  }

  to {
    opacity: 0;
  }
}

.record_canvas {
  width: 60px;
  height: 100px;
  display: inline-block;
}

.txt_btn {
  color: #000;
  text-decoration: none;
  transition: 0.15s linear;
  animation: text_btn 0.3s ease-in-out;
}
</style>
