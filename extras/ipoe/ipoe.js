function getEditor() {
    return document.getElementById("editor");
}

function setHaiku() {
    var ed = getEditor();

    ed.rows = 3;
    ed.cols = 80;
}

function setVillanelle() {
    var ed = getEditor();

    ed.rows = 24;
    ed.cols = 80;
}

function compile() {
    var ed = getEditor();

    console.log("hi");
    ed.textContent = "YOLO";
}

// text-decoration: underline;
// text-decoration-color: #f8981d;
// text-decoration-style: wavy;
