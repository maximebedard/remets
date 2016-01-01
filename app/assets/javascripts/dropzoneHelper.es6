function newDropzoneConfig(props) {
  return {
    paramName: props.paramName,
    autoProcessQueue: false,
    uploadMultiple: false,
    clickable: ".fileinput-button",
    previewTemplate: props.previewTemplate,
    init: function() {
      let submitButton = document.getElementById(props.submitButtonId);

      submitButton.addEventListener("click", () => {
        this.processQueue(); // Tell Dropzone to process all queued files.
      });

      this.on("addedfile", function() {
        console.log('file added');
      });

      this.on('sending', function(file, xhr, formData) {
      });

      this.on('success', (file)=> {
        //give enough time for the animation to finish.
        setTimeout(() => {
          file.previewElement.getElementsByClassName('progress-complete')[0].style['display'] = 'block';
          file.previewElement.getElementsByClassName('progress-in-progress')[0].style['display'] = 'none';
          file.previewElement.getElementsByClassName('delete')[0].remove();
        }, 1000);
      });

      this.on('queuecomplete', () => {
        console.log('redirect!'); //TODO : redirect to the project page? I guess?
      });
    }
  }
}
