/**
 * Essential variables
 */
var canvas = document.getElementById("image_viewer");
var ctx;
var image = new Image();
var image_id = getUrlVars()['imageid'];

var scale = .3;
var asp = 1;
var x = -1060;
var y = -810;

/** mousebutton x,y handles drag events on the screen */
var mousebutton = {dragged:false, select:false, addEntry:false, removeEntry:false, markFalse: false, x:0, y:0};
/** mousePos x,y handles clicking on elements on the screen */
var mousePos = {x:0,y:0};
var selectAmount = 0;
var identified = new Array();
var newEntry = initIdentified(true,false,0,0,0);

/**
 * Declare event handlers for mouse input 
 */
canvas.onmousedown 		= 	function(){ mousedown(event) };
canvas.onmousemove 		= 	function(){ mousemove(event) };
canvas.onmouseup 		= 	function(){ mouseup(event) };
canvas.onmousewheel 	= 	function(){ mousescroll(event) };

/**
 * Touch Controls
 */
/*
var hammer = new Hammer(canvas);
hammer.get('pan').set({direction:Hammer.DIRECTION_ALL});
hammer.on("panleft panright panup pandown", function(ev) {
    switch(ev.type) {
        case "panleft":
            shiftRight();
            break;
        case "panright":
            shiftLeft();
            break;
        case "pandown":
            shiftUp();
            break;
        case "panup":
            shiftDown();
            break;
    }
    ev.gesture.preventDefault();
});*/

/**
 * Identification object
 */
function initIdentified(cv, fp, x, y, r) {
	var identified = {
		openCV : cv, 
		falsePosivitive : fp, 
		select : false, 
		x : x, 
		y : y, 
		r : r,
		setAll : function(cv, fp, x, y, r) {this.openCV = cv; this.falsePosivitive = fp; this.select = false; this.x = x; this.y = y; this.r = r;}
	};
	return identified;
}

/**
 * Initialization main code
 */
$(function () {
    console.log("started");
    canvas.width = document.getElementById('canvas_div').offsetWidth;
    canvas.height = canvas.width*3/4 
    $.get("/cgi-bin/flowerdetections.py?imageid="+image_id, get_id, "json");
    $.get("/cgi-bin/observations.py?imageid="+image_id, get_image, "json");
});

function get_id(data) {
    data.forEach(function(id) {
        identified.push(initIdentified(id.IsUserDetected,false,id.XCord,id.YCord,id.Radius));
    });
}

function get_image(data) {
    observation = data[0];
    image.src = "/pics/"+observation.FileName;
    document.getElementById("observation_filename").innerHTML = observation.FileName;
    document.getElementById("observation_date").innerHTML = observation.Date + ", " + observation.Time;
    document.getElementById("observation_latitude").innerHTML = observation.Latitude;  
    document.getElementById("observation_longitude").innerHTML = observation.Longitude;
    var options = addSelection(observation.IsSilene);
    document.getElementById("observation_isPlant").innerHTML =
         '<select id="id_'+observation.ImageID+'" onclick="updateVerification('+observation.ImageID+')">'+options+'</select>'
         //observation.IsSilene == null ? "N/A" : Boolean(observation.IsSilene);
}

/**
 * Initialization main code
  */
image.onload = function() {
    init();
    page_init();
    resetView();
}

function init() {
    
    asp = image.width/image.height;
    ctx = canvas.getContext('2d');
}

/**
 * Previous, Next Page
 */
function page_init(){
    id = parseInt(image_id);
    previouspage = document.getElementById('prepage');
    nextpage = document.getElementById('nextpage');
    if (id == 1)
        prepage.style.visibility = 'hidden';
    prepage.href = "http://flowerid.cheetahjokes.com/webapp/observer.html?imageid="+(id-1)
    nextpage.href = "http://flowerid.cheetahjokes.com/webapp/observer.html?imageid="+(id+1)
}

/**
 * Display scene using canvas methods
 */
function display() {
	/** clear canvas */
	ctx.save();
		ctx.setTransform(1,0,0,1,0,0);
		ctx.clearRect(0,0,canvas.width,canvas.height);
	ctx.restore();
	/** draw all assets to the canvas */
	ctx.save();
		ctx.translate(canvas.width/2,canvas.height/2);
		ctx.scale(scale,scale);
		ctx.translate(-canvas.width/2,-canvas.height/2);
		ctx.translate(x,y);

		ctx.drawImage(image,0,0);

		/** draw all entries */
		for (var i = 0; i < identified.length; i++) {
			ctx.beginPath();
			ctx.arc(identified[i].x,identified[i].y,identified[i].r,0,2*Math.PI);
			ctx.lineWidth = 10;
			if (identified[i].falsePosivitive)
				ctx.strokeStyle = 'yellow';
			else
     			ctx.strokeStyle = 'red';
			if (identified[i].select)
				ctx.strokeStyle = 'white';
			
			ctx.stroke();
		}
		/** visual effect for creating new entry */
		if (mousebutton.addEntry) {
			ctx.beginPath();
			ctx.arc(newEntry.x,newEntry.y,newEntry.r,0,2*Math.PI);
			ctx.lineWidth = 10;
 			ctx.strokeStyle = 'white';
			ctx.stroke();
		}
	ctx.restore();
}

/**
 * Handle keyboard press events
 */
window.onkeydown = function(e) {
	switch (e.which) {
		case 17:
			mousebutton.select = true;
			break;
		case 65:
			// a
			addEntry();
			break;
		case 68:
			// d
			removeEntry();
			break;
		case 69:
			// e
			markTrue();
			break;
		case 70:
			// f
			markFalse();
			break;
		case 72:
			// h
			shiftLeft();
			break;
		case 74:
			// j
			shiftDown();
			break;
		case 75:
			// k
			shiftUp();
			break;
		case 76:
			// l
			shiftRight();
			break;
		case 81:
			// q
			unselectAll();
			break;
		case 82:
			// r
			resetView();
			break;
		case 83:
			// s
			zoomOut();
			break;
		case 87:
			// w
			zoomIn();
			break;

	}
	console.trace(e.which);
}

/**
 * Handle keyboard release events
 */
window.onkeyup = function(e) {
	if (e.which == 17) {
		mousebutton.select = false;
	}
}

/**
 * Get cursor relative position
 * Code originated from stack overflow thread
 * http://stackoverflow.com/questions/55677/how-do-i-get-the-coordinates-of-a-mouse-click-on-a-canvas-element
 */
function getCursorPosition(canvas, event) {
	var mx, my;

	canoffset = $(canvas).offset();
	mx = event.clientX + document.body.scrollLeft + document.documentElement.scrollLeft - Math.floor(canoffset.left);
	my = event.clientY + document.body.scrollTop + document.documentElement.scrollTop - Math.floor(canoffset.top) + 1;

	mx = mx/scale-x-((canvas.width/scale)-canvas.width)/2
	my = my/scale-y-((canvas.height/scale)-canvas.height)/2
	return {x:mx,y:my};
}

/**
 * Check if mouse clicks on entry within canvas
 */
function mouseCollision(obj, mp) {
	var xRange = Math.abs(obj.x - mp.x);
	var yRange = Math.abs(obj.y - mp.y);
	return Boolean(xRange <= obj.r && yRange <= obj.r);
}

/**
 * Handle mouse events
 */
mousescroll = function(e) {
    e.preventDefault();
	var evt = window.event || e
	var delta = evt.detail? evt.detail*(-1) : evt.wheelDelta
	if(delta > 0)
		zoomIn();
	else if (delta <= 0)
		zoomOut();
	display();
}
mousedown = function(e) {
	mousebutton.dragged = true;
	mousePos = getCursorPosition(canvas,e);
	mousebutton.x = e.clientX;
	mousebutton.y = e.clientY;
	if(mousebutton.addEntry)
		newEntry.setAll(false, false, mousePos.x,mousePos.y, 0);
}
mousemove = function(e) {
	mousePos = getCursorPosition(canvas,e);
	if (mousebutton.dragged) {
		/** adjusting radius of new entry */
		if (mousebutton.addEntry) {
			
			var mx = Math.abs(newEntry.x - (mousePos.x));
			var my = Math.abs(newEntry.y - (mousePos.y));
			var radius = (mx >= my)? mx: my;
			newEntry.r = Math.abs(radius);
		}
		/** shifting view using mouse movement */
		if (!mousebutton.addEntry) {
				x -= (mousebutton.x - e.clientX)/scale*1.1;
				y -= (mousebutton.y - e.clientY)/scale*1.1;
		}
		mousebutton.x = e.clientX;
		mousebutton.y = e.clientY;
		display();
	}
}
mouseup = function(e) {
	mousebutton.dragged = false;
	/** add entry */
	if (mousebutton.addEntry) {
		identified.push(initIdentified(newEntry.openCV,newEntry.falsePosivitive,newEntry.x,newEntry.y,newEntry.r));
		addEntry();
		display();
	}
	/** remove entry */
	if (mousebutton.removeEntry) {
		mousePos = getCursorPosition(canvas,e);
		for (var i = 0; i < identified.length; i++) {
			if (mouseCollision(identified[i], mousePos) && !identified[i].openCV){
				identified.remove(i--);
			}
		}
		removeEntry();
		display();
	}
	/** mark false positive */
	if (mousebutton.markFalse) {
		mousePos = getCursorPosition(canvas,e);
		for (var i = 0; i < identified.length; i++) {
			if (mouseCollision(identified[i], mousePos)){
				identified[i].falsePosivitive = true;
			}
		}
		markFalse();
		display();
	}
	/** mark as positive */
	if (mousebutton.markTrue) {
		mousePos = getCursorPosition(canvas,e);
		for (var i = 0; i < identified.length; i++) {
			if (mouseCollision(identified[i], mousePos)){
				identified[i].falsePosivitive = false;
			}
		}
		markTrue();
		display();
	}
	/** select entry */
	if (mousebutton.select) {
		mousePos = getCursorPosition(canvas,e);
		for (var i = 0; i < identified.length; i++) {
			if (mouseCollision(identified[i], mousePos)){
				identified[i].select = !identified[i].select;
				if (identified[i].select) selectAmount++;
				else selectAmount--;
			}
		}
		display();
	}
}

/**
 * Handle Zooming In
 */
function zoomIn() {
	scale += .05*scale;
	if ( scale > 10 ) scale = 10;
	display();
}

/**
 * Handle Zooming Out
 */
function zoomOut() {
	scale -= .05*scale;
	if ( scale < .2 ) scale = .2;
	display();
}

/**
 * Reset orientation and scale
 */
function resetView() {
    scale = Math.min(canvas.width/image.width, canvas.height/image.height);
    x = -image.width/2+canvas.width/2
    y = (-image.height+canvas.height)/2 
	display();
}

/**
 * Toggle mode to add new entry
 * All new entries set openCV to false, due to being user created
 */
function addEntry() {
	mousebutton.addEntry = !mousebutton.addEntry;
	if (mousebutton.addEntry)
		document.getElementById("add").innerHTML="Cancel"
	else
		document.getElementById("add").innerHTML="Add"
}

/**
 * Toggle mode to remove entry
 * Only works on user added entries
 */
function removeEntry() {
	if (selectAmount < 1) {
		mousebutton.removeEntry = !mousebutton.removeEntry;
		if(mousebutton.removeEntry)
			document.getElementById("remove").innerHTML="Cancel"
		else
			document.getElementById("remove").innerHTML="Remove"
	}
	else {
		for (var i = 0; i < identified.length; i++) {
			if (identified[i].select && !identified[i].openCV) 
				identified.remove(i--);
			if (identified[i].select && identified[i].openCV)
				identified[i].select = false;
		}
		selectAmount = 0;
		display();
	}
}

/**
 * Toggle mode to mark false positive
 */
function markFalse() {
	if (mousebutton.markTrue)
		markTrue();
	if (selectAmount < 1) {
		mousebutton.markFalse = !mousebutton.markFalse;
		if(mousebutton.markFalse)
			document.getElementById("mfalse").innerHTML="Cancel"
		else
			document.getElementById("mfalse").innerHTML="Mark False"
	}
	else {
		for(var i = 0; i < identified.length; i++) {
			if (identified[i].select) {
				identified[i].select = false;
				identified[i].falsePosivitive = true;
			}
		}
		selectAmount = 0;
		display();
	}
}

/**
 * Toggle mode to mark positive
 */
function markTrue() {
	if (mousebutton.markFalse)
		markFalse();
	if (selectAmount < 1) {
		mousebutton.markTrue = !mousebutton.markTrue;
		if(mousebutton.markTrue)
			document.getElementById("mtrue").innerHTML="Cancel"
		else
			document.getElementById("mtrue").innerHTML="Mark true"
	}
	else {
		for(var i = 0; i < identified.length; i++) {
			if (identified[i].select) {
				identified[i].select = false;
				identified[i].falsePosivitive = false;
			}
		}
		selectAmount = 0;
		display();
	}
}

/**
 * Unselect all entries
 */
function unselectAll() {
	for(var i = 0; i < identified.length; i++)
		identified[i].select = false;
	selectAmount = 0;
	display();
}
/**
 * Handle shifting the views orientation
 */
function shiftRight() {
	x-=20/scale;
	display();
}
function shiftLeft() {
	x+=20/scale;
	display();
}
function shiftUp() {
	y+=20/scale;
	display();
}
function shiftDown() {
	y-=20/scale;
	display();
}

/*window.onresize = function() {
    canvas.width = window.innerWidth*7/8;
    canvas.height = canvas.width
};*/
