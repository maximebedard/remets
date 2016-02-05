//Droplit v 0.0.1
//The most ghetto of drag and drop plugins.

function dragAndDropify(queryElement) {
  //The global fileList. Contains a mapping between input[type="files"] and the files.
  //Maybe convert this to a prototypical object?
  var fileListObject = {};

  //Contains the mapping between input[type="files"] and <ul> element to list the files
  //Maybe convert this to a prototypical object?
  var fileUlObject = {};

  var form =  document.querySelector(queryElement);
  if (!form || form.nodeName != "FORM") {
    throw new Error('This is not a form! Make sure you entered the right selector!');
  }

  const inputFiles = form.querySelectorAll('input[type="file"]');
  if(inputFiles.length === 0) {
    throw new Error('Woah there cowboy! Can\'t make a drag and drop file upload if there are no file inputs!');
  }

  const preventDefault = (e) => {
    e.preventDefault();
  };

  const submitForm = (e) => {
    e.stopPropagation();
    e.preventDefault();
    const formData = new FormData(form);

    //move the files into the form data.
    for (let fileList in fileListObject) {
      fileListObject[fileList].forEach((file) => {
        formData.append(fileList, file);
      });
    }

    var request = new XMLHttpRequest();
    request.open(form.method, form.action);
    request.onload = function (msg) {
      console.log("SERVER IS DONE DOING OUR SHIT");
      window.location.href = this.responseURL;
    };
    request.send(formData);
  };

  form.addEventListener('submit', submitForm, false);

  //Prevent the window from intercepting our drag events.
  window.addEventListener('dragover', preventDefault, false);
  window.addEventListener('drop', preventDefault, false);

  //Start mutating the DOM so we can have our cake
  for (let i = 0; i < inputFiles.length; i++) {
    let input = inputFiles[i];
    let parentNode = input.parentNode;

    let d = document.createElement('div');
    d.className = 'remets-dnd';
    d.innerHTML = 'DRAG YO STUFF HERE'; //might want to remove this?
    parentNode.appendChild(d);

    input.remove();
    d.appendChild(input);

    let ul = document.createElement('ul');
    ul.className = 'remets-dnd__file-list';
    parentNode.appendChild(ul);

    fileUlObject[input.name] = ul;
    fileListObject[input.name] = [];
    dropMagic(d, input);
  }

  //Naming things is hard
  function dropMagic(wrapper, input) {

    function pushFiles(files) {
      for(let i = 0; i < files.length ; i++){
        let li = document.createElement('li');
        let content = document.createTextNode(files[i].name);
        li.appendChild(content);
        fileListObject[input.name].push(files[i]);
        fileUlObject[input.name].appendChild(li);

        let a  = document.createElement('a');
        a.href = '#';
        a.innerText = 'X';
        a.addEventListener('click', (e) => {
          let index = fileListObject[input.name].length;
          fileListObject[input.name].splice(fileListObject[input.name][index], 1);
          li.remove();
        });
        li.appendChild(a);
      }
    };

    function dragEnterAndOver(e) {
      e.stopPropagation();
      e.preventDefault();
      this.classList.add('remets-dnd-wrapper__enter');
    };

    function dragEnd(e) {
      this.classList.remove('remets-dnd-wrapper__enter');
    }

    function drop(e) {
      e.stopPropagation();
      e.preventDefault();
      this.classList.remove('remets-dnd-wrapper__enter');
      let dt = e.dataTransfer;
      let files = dt.files;
      pushFiles(files);
      console.log(`Currently, we have ${fileListObject[input.name].length} files`);
    };

    //Bind a ton of listeners...
    wrapper.addEventListener('dragenter', dragEnterAndOver, false);
    wrapper.addEventListener('dragover', dragEnterAndOver, false);
    wrapper.addEventListener('drop', drop, false);
    wrapper.addEventListener('dragleave', dragEnd)
    wrapper.addEventListener('dragexit', dragEnd);
    wrapper.addEventListener('dragend', dragEnd);

  };

}
