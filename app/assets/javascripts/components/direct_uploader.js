$(document).on('ready page:load', function(){
  $("[data-direct-upload]").each(function(i, elem) {
    let fileInput    = $(elem);
    let form         = $(fileInput.parents("form:first"));
    let submitButton = form.find("input[type=\"submit\"]");
    let progressBar  = $("<div class=\"bar\"></div>");
    let barContainer = $("<div class=\"progress\"></div>").append(progressBar);
    fileInput.after(barContainer);
    fileInput.fileupload({
      fileInput:       fileInput,
      url:             fileInput.data("url"),
      type:            "POST",
      autoUpload:       true,
      formData:         fileInput.data("fields"),
      paramName:        "file", // S3 does not like nested name fields i.e. name="user[avatar_url]"
      dataType:         "XML",  // S3 returns XML if success_action_status is set to 201
      replaceFileInput: false,
      progressall: function (e, data) {
        let progress = parseInt(data.loaded / data.total * 100, 10);
        progressBar.css('width', progress + '%')
      },
      start: function (e) {
        submitButton.prop('disabled', true);

        progressBar.
          css('background', 'green').
          css('display', 'block').
          css('width', '0%').
          text("Loading...");
      },
      done: function(e, data) {
        submitButton.prop('disabled', false);
        progressBar.text("Uploading done");

        // extract key and generate URL from response
        let key   = $(data.jqXHR.responseXML).find("Key").text();
        let url   = '//' + form.data('host') + '/' + key;

        // create hidden field
        let input = $("<input />", { type:'hidden', name: fileInput.attr('name'), value: url })
        form.append(input);
      },
      fail: function(e, data) {
        submitButton.prop('disabled', false);

        progressBar.
          css("background", "red").
          text("Failed");
      }
    });
  });
});
