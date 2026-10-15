import * as wasm from "l8";


let Frac = wasm.Fractal.new();
let height = Frac.height();
let width = Frac.width();


const pre = document.getElementById("l8-canvas");

let canvas = document.getElementById('myCanvas');
canvas.height = height;
canvas.width = width;

let ctx = canvas.getContext('2d');
let img = document.getElementById("img");
ctx.drawImage(img, 0, 0);
let imgData = ctx.getImageData(0, 0, width, height);

let xmin = -2.2;
let xmax = 1;
let ymin = -1.2;
let ymax = 1.2;
let arr = Frac.render(xmin, xmax, ymin, ymax);
draw();

function draw(){
    arr = Frac.render(xmin, xmax, ymin, ymax);
    imgData.data.set(arr);
    ctx.putImageData(imgData, 0, 0);
}

function drawWithoutRender(){
    imgData.data.set(arr);
    ctx.putImageData(imgData, 0, 0);
}

let canvas2 = document.getElementById('can2');
canvas2.height = height;
canvas2.width = width;
let ctx2 = canvas.getContext('2d');

let startX = 0;
let startY = 0;
let isClick = false
canvas.addEventListener('mousedown', e => {
    startX = e.offsetX;
    startY = e.offsetY;
    // alert((xmax - xmin)/1024.0 * startX + xmin)
    isClick = true;
  });
  
  
  canvas.addEventListener('mousemove', e =>{
    
    if (isClick){
    ctx2.clearRect(0,0,canvas2.width,canvas2.height);
    drawWithoutRender()
    ctx2.beginPath();
    ctx2.strokeStyle = "yellow";
    ctx2.rect(startX, startY, e.offsetX - startX, e.offsetY - startY); 
    ctx2.stroke();
    }
});


canvas.addEventListener('mouseup', e => {
    let endX = e.offsetX;
    let endY = e.offsetY;
    if (startX > endX){
        [startX, endX] = [endX, startX];
    }
   [xmin, xmax] = [(xmax - xmin)/1024.0 * startX + xmin, (xmax - xmin)/1024.0 * endX + xmin]

  if (startY > endY){
      [startY, endY] = [endY, startY];
  }
 [ymin, ymax] = [(ymax - ymin)/1024.0 * startY + ymin, (ymax - ymin)/1024.0 * endY + ymin]

  //  alert(xmax)
  draw()
  isClick = false
});

document.getElementById('reset').onclick = reset;
function reset(){
    xmin = -2.2
    xmax = 1;
    ymin = -1.2
    ymax = 1.2
    draw()
}



