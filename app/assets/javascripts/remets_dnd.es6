//Droplit v 0.0.1
//The most ghetto of drag and drop plugins.

function dragAndDropify(queryElement) {
  //The global fileList. Contains a mapping between input[type="files"] and the files.
  //Maybe convert this to a prototypical object?
  const fileListObject = (function () {
    var o = {}

    function addNameKey(namekey) {
      o[namekey] = [];
    };

    function pushFilesInto(files, nameKey){
      for(let i = 0; i < files.length ; i++) {
        o[nameKey].push(files[i]);
      }
    };

    function removeFileFrom(index, nameKey) {
      o[nameKey].splice(o[nameKey][index], 1);
    };

    function lenghtFrom(nameKey) {
      return o[nameKey].length;
    };

    function getFileListObject() {
      return o;
    }

    return {
      addNameKey: addNameKey,
      pushFilesInto: pushFilesInto,
      removeFileFrom: removeFileFrom,
      lenghtFrom: lenghtFrom,
      getFileListObject: getFileListObject
    };
  })();

  const fileUlObject = (function(fileListObject) {
    var o = {}

    function addNameKey(namekey) {
      o[namekey] = null;
    };

    function createUlElementInto(nameKey) {
      let ul = document.createElement('ul');
      ul.className = 'remets-dnd__file-list';
      o[nameKey] = ul;
      return ul;
    };

    function appendLiElementInto(li, nameKey) {
      o[nameKey].appendChild(li);
    };

    function createListItem(text) {
      const li = document.createElement('li');
      const content = document.createTextNode(text);
      li.appendChild(content);
      return li;
    };

    function createRemoveElement(nameKey, li, index) {
       const a  = document.createElement('a');
       a.dataset.index = index
       a.innerText = 'X';
       a.addEventListener('click', function(e) {
          const index = Number.parseInt(this.dataset.index);
          fileListObject.removeFileFrom(index, nameKey);
          li.remove();
        });
       return a;
    }

    function createLiFromFiles(files, nameKey) {
      var index = fileListObject.lenghtFrom(nameKey);
      for(let i = 0; i < files.length ; i++){
        const li = createListItem(files[i].name);
        appendLiElementInto(li, nameKey);
        const a = createRemoveElement(nameKey, li, (index + i));
        li.appendChild(a);
      }
    }

    return {
      addNameKey: addNameKey,
      createUlElementInto: createUlElementInto,
      createLiFromFiles: createLiFromFiles,
    };
  })(fileListObject);

  //Contains the mapping between input[type="files"] and <ul> element to list the files
  //Maybe convert this to a prototypical object?

  const form =  document.querySelector(queryElement);
  if (!form || form.nodeName != "FORM") {
    throw new Error('This is not a form! Make sure you entered the right selector!');
  }

  const inputFiles = form.querySelectorAll('input[type="file"]');
  if(inputFiles.length === 0) {
    throw new Error('Woah there cowboy! Can\'t make a drag and drop file upload if there are no file inputs!');
  }

  //Prevent the window from intercepting our drag events.
  window.addEventListener('dragover', preventDefault, false);
  window.addEventListener('drop', preventDefault, false);

  const preventDefault = (e) => {
    e.preventDefault();
  };

  const submitForm = (e) => {
    e.stopPropagation();
    e.preventDefault();

    const formData = new FormData(form);

    //move the files into the form data.
    for (let fileList in fileListObject.getFileListObject()) {
      fileListObject.getFileListObject()[fileList].forEach((file) => {
        formData.append(fileList, file);
      });
    }

    var request = new XMLHttpRequest();
    request.open(form.method, form.action);
    request.onload = function() {
      window.location.href = this.responseURL;
    };
    request.send(formData);
  };

  form.addEventListener('submit', submitForm, false);


  //Start mutating the DOM so we can have our cake
  for (let i = 0; i < inputFiles.length; i++) {
    const input = inputFiles[i];
    const parentNode = input.parentNode;

    const d = document.createElement('div');
    d.className = 'remets-dnd';
    d.innerHTML = 'DRAG YO STUFF HERE'; //might want to remove this?
    parentNode.appendChild(d);

    input.remove();
    d.appendChild(input);

    const ul = fileUlObject.createUlElementInto(input.name);
    parentNode.appendChild(ul);
    fileListObject.addNameKey(input.name);
    dropMagic(d, input);
  }

  //Naming things is hard
  function dropMagic(wrapper, input) {

    function pushFiles(files) {
      fileListObject.pushFilesInto(files, input.name);
      fileUlObject.createLiFromFiles(files, input.name);
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
      const dt = e.dataTransfer;
      const files = dt.files;
      pushFiles(files);
      console.log(`Currently, we have ${fileListObject.lenghtFrom(input.name)} files`);
    };

    //Bind a ton of listeners...
    wrapper.addEventListener('dragenter', dragEnterAndOver, false);
    wrapper.addEventListener('dragover', dragEnterAndOver, false);
    wrapper.addEventListener('drop', drop, false);
    wrapper.addEventListener('dragleave', dragEnd)
    wrapper.addEventListener('dragexit', dragEnd);
    wrapper.addEventListener('dragend', dragEnd);

  };

};
