function newDropzoneConfig(props) {
  return {
    paramName: props.paramName,
    autoProcessQueue: false,
    uploadMultiple: false,
    addRemoveLinks: true,
    clickable: ".fileinput-button",
    init: function() {
      let submitButton = document.getElementById(props.submitButtonId);
      let self = this;

      submitButton.addEventListener("click", function() {
        self.processQueue(); // Tell Dropzone to process all queued files.
      });

      this.on("addedfile", function() {
        console.log('file added');
      });

      this.on('sending', function(file, xhr, formData) {

      });
    }
  }
}
