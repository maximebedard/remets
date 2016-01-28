function newDropzone(props) {
  return {
    paramName: () => { return props.paramName }, // use anonymous function to avoid using the automatically added []
    previewsContainer: props.previewsContainer,
    previewTemplate: props.previewTemplate,
    autoProcessQueue: false,
    uploadMultiple: true,
    init: function() {
      const progressBar = Turbolinks.enableProgressBar();
      const submitButton =  this.element.querySelector('input[type=submit]');

      submitButton.addEventListener("click", (e) => {
        e.preventDefault();
        e.stopPropagation();
        this.processQueue();
      });

      this.on("addedfile", () => {
        console.log('file added');
      });

      this.on('sendingmultiple', () => {
        // Gets triggered when the form is actually being sent.
        let deleteButtons = this.element.querySelectorAll('[data-dz-remove]');
        for (let i = 0; i < deleteButtons.length; i++) {
          deleteButtons[i].disabled = true;
        }
        submitButton.disabled = true;
        progressBar.start();
      });

      this.on('successmultiple', (files, response) => {
        // Gets triggered when the files have successfully been sent.
        //TODO - Redirect user
        progressBar.done();
      });

      this.on('errormultiple', (files, response) => {
        // Gets triggered when there was an error sending the files.
        // Maybe show form again, and notify user of error
        //TODO - actually trigger errors. Backend needs to send error json
        progressBar.done();
        progressBar._reset();
        console.log('error!!');
      });

      this.on('totaluploadprogress', (uploadProgress, totalBytes, totalBytesSent) => {
        //Strangely enough, this gets called when we trigger data-dz-removed...
        //Check to see if the bytes are not zero before advancing the progress bar.
        if (totalBytes !== 0 && totalBytesSent !== 0)
          progressBar.advanceTo(uploadProgress);
      });

    }
  }
}
