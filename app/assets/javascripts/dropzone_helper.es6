function newDropzone(props) {
  return {
    paramName: () => { return props.paramName }, // use anonymous function to avoid using the automatically added []
    previewsContainer: props.previewsContainer,
    previewTemplate: props.previewTemplate,
    autoProcessQueue: false,
    uploadMultiple: true,
    init: function() {
      this.element.querySelector("input[type=submit]").addEventListener("click", (e) => {
        e.preventDefault();
        e.stopPropagation();
        this.processQueue();
      });

      this.on("addedfile", function() {
        console.log('file added');
      });

      this.on('sendingmultiple', function() {
        // Gets triggered when the form is actually being sent.
        // Hide the success button or the complete form.
      });

      this.on('successmultiple', (files, response) => {
        // Gets triggered when the files have successfully been sent.
        // Redirect user or notify of success.
      });

      this.on('errormultiple', (files, response) => {
        // Gets triggered when there was an error sending the files.
        // Maybe show form again, and notify user of error
      });
    }
  }
}
