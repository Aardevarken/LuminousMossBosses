Array.prototype.remove = function(from, to) {
  var rest = this.slice((to || from) + 1 || this.length);
  this.length = from < 0 ? this.length + from : from;
  return this.push.apply(this, rest);
};

var canvas = document.getElementById("image_viewer");
canvas.onmousedown 	= 	function(){ mousedown(event) };
canvas.onmousemove 	= 	function(){ mousemove(event) };
canvas.onmouseup 	= 	function(){ mouseup(event) };

var ctx;
var image = new Image();
image.src = "IMG_1997.jpg";
var scale = .3;
var asp = 1;
var x = -1060;
var y = -810;
var mousebutton = {dragged:false, select:false, add_entry:false, remove_entry:false, mark_false: false, x:0, y:0};
var mousePos = {x:0,y:0};


/*	Identified Objects */
function init_identified(cv, fp, x, y, r){
	var identified = {
		openCV : cv, 
		falsePosivitive : fp, 
		select : false, 
		x : x, 
		y : y, 
		r : r,
		setAll : function(cv, fp, x, y, r){this.openCV = cv; this.falsePosivitive = fp; this.select = false; this.x = x; this.y = y; this.r = r;}
	};
	return identified;
}
var selectAmount = 0;

var identified = new Array();
identified.push(init_identified(false,false,1673,1442,46));
identified.push(init_identified(false,false,1644,1621,43));
identified.push(init_identified(false,false,1303,1547,52));
identified.push(init_identified(false,false,1677,1343,44));
identified.push(init_identified(false,false,1734,1113,42));
identified.push(init_identified(false,false,1861,1280,51));
identified.push(init_identified(false,false,1709,1534,48));
identified.push(init_identified(false,false,1751,1281,42));
identified.push(init_identified(false,false,1899,1372,38));
identified.push(init_identified(false,false,1400,1557,52));
identified.push(init_identified(false,false,1254,2014,30));
identified.push(init_identified(false,false,1267,1358,53));
identified.push(init_identified(false,false,1584,1546,39));
identified.push(init_identified(false,false,2189,1240,48));
identified.push(init_identified(false,false,662,1491,25));
var new_entry = init_identified(false,false,0,0,0);

image.onload = function() {
	init();
}

function init() {
	ctx = canvas.getContext('2d');
	asp = image.width/image.height;
	display();
}

// This function is unused
function loop() {
	window.requestAnimationFrame(loop);
	display();
}

function display() {
	ctx.save();
		ctx.setTransform(1,0,0,1,0,0);
		ctx.clearRect(0,0,canvas.width,canvas.height);
	ctx.restore();

	ctx.save();
		ctx.translate(canvas.width/2,canvas.height/2);
		ctx.scale(scale,scale);
		ctx.translate(-canvas.width/2,-canvas.height/2);
		ctx.translate(x,y);

		ctx.drawImage(image,0,0);

		for(var i = 0; i < identified.length; i++) {
			ctx.beginPath();
			ctx.arc(identified[i].x,identified[i].y,identified[i].r,0,2*Math.PI);
			ctx.lineWidth = 10;
			if(identified[i].falsePosivitive)
				ctx.strokeStyle = 'yellow';
			else
     			ctx.strokeStyle = 'red';
			if(identified[i].select)
				ctx.strokeStyle = 'white';
			
			ctx.stroke();
		}
		if(mousebutton.add_entry) {
			ctx.beginPath();
			ctx.arc(new_entry.x,new_entry.y,new_entry.r,0,2*Math.PI);
			ctx.lineWidth = 10;
 			ctx.strokeStyle = 'white';
			ctx.stroke();
		}
	ctx.restore();
}

window.onkeydown = function(e) {
	switch(e.which) {
		case 17:
			mousebutton.select = true;
			break;
		case 65:
			//a
			add_entry();
			break;
		case 68:
			//d
			remove_entry();
			break;
		case 69:
			//e
			mark_true();
			break;
		case 70:
			//f
			mark_false();
			break;
		case 72:
			shift_left();
			break;
		case 74:
			shift_up();
			break;
		case 75:
			shift_down();
			break;
		case 76:
			shift_right();
			break;
		case 82:
			//r
			reset_view();
			break;
		case 87:
			//w
			zoomin();
			break;
		case 83:
			//s
			zoomout();
	}
	console.trace(e.which);
}

window.onkeyup = function(e) {
	if(e.which == 17) {
		mousebutton.select = false;
	}
}

function getCursorPosition(canvas, event) {
	var mx, my;

	canoffset = $(canvas).offset();
	mx = event.clientX + document.body.scrollLeft + document.documentElement.scrollLeft - Math.floor(canoffset.left);
	my = event.clientY + document.body.scrollTop + document.documentElement.scrollTop - Math.floor(canoffset.top) + 1;

	mx = mx/scale-x-((canvas.width/scale)-canvas.width)/2
	my = my/scale-y-((canvas.height/scale)-canvas.height)/2
	return {x:mx,y:my};
}

mousedown = function(e) {
	mousebutton.dragged = true;
	mousePos = getCursorPosition(canvas,e);
	mousebutton.x = e.clientX;
	mousebutton.y = e.clientY;
	if(mousebutton.add_entry)
		new_entry.setAll(false, false, mousePos.x,mousePos.y, 0);
}
mousemove = function(e) {
	mousePos = getCursorPosition(canvas,e);
	if (mousebutton.dragged) {
		if (mousebutton.add_entry) {
			
			var mx = Math.abs(new_entry.x - (mousePos.x));
			var my = Math.abs(new_entry.y - (mousePos.y));
			var radius = (mx >= my)? mx: my;
			new_entry.r = Math.abs(radius);
		}
		if (!mousebutton.add_entry) {
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
	if(mousebutton.add_entry) {
		identified.push(init_identified(new_entry.openCV,new_entry.falsePosivitive,new_entry.x,new_entry.y,new_entry.r));
		add_entry();
		display();
	}
	if(mousebutton.remove_entry){
		mousePos = getCursorPosition(canvas,e);
		for(var i = 0; i < identified.length; i++) {
			if(Math.abs(identified[i].x - mousePos.x) <= identified[i].r && Math.abs(identified[i].y-mousePos.y) <= identified[i].r && !identified[i].openCV){
				identified.remove(i);
				break;
			}
		}
		remove_entry();
		display();
	}
	if(mousebutton.mark_false){
		mousePos = getCursorPosition(canvas,e);
		for(var i = 0; i < identified.length; i++) {
			if(Math.abs(identified[i].x - mousePos.x) <= identified[i].r && Math.abs(identified[i].y-mousePos.y) <= identified[i].r){
				identified[i].falsePosivitive = true;
				break;
			}
		}
		mark_false();
		display();
	}
	if(mousebutton.mark_true){
		mousePos = getCursorPosition(canvas,e);
		for(var i = 0; i < identified.length; i++) {
			if(Math.abs(identified[i].x - mousePos.x) <= identified[i].r && Math.abs(identified[i].y-mousePos.y) <= identified[i].r){
				identified[i].falsePosivitive = false;
				break;
			}
		}
		mark_true();
		display();
	}
	if(mousebutton.select){
		mousePos = getCursorPosition(canvas,e);
		for(var i = 0; i < identified.length; i++) {
			if(Math.abs(identified[i].x - mousePos.x) <= identified[i].r && Math.abs(identified[i].y-mousePos.y) <= identified[i].r){
				identified[i].select = !identified[i].select;
				if (identified[i].select) selectAmount++;
				else selectAmount--;
				break;
			}
		}
		display();
	}
}

function zoomin() {
	scale += .05;
	if ( scale > 2 ) scale = 2;
	display();
}

function zoomout() {
	scale -= .05;
	if ( scale < .2 ) scale = .2;
	display();
}

function reset_view() {
	scale = .3;
	x = -1060;
	y = -810;
	display();
}

function add_entry() {
	mousebutton.add_entry = !mousebutton.add_entry;
	if(mousebutton.add_entry)
		document.getElementById("add").innerHTML="Cancel"
	else
		document.getElementById("add").innerHTML="Add"
}

function remove_entry() {
	if(selectAmount < 1) {
		mousebutton.remove_entry = !mousebutton.remove_entry;
		if(mousebutton.remove_entry)
			document.getElementById("remove").innerHTML="Cancel"
		else
			document.getElementById("remove").innerHTML="Remove"
	}
	else {
		for(var i = 0; i < identified.length; i++) {
			if (identified[i].select && !identified[i].openCV) 
				identified.remove(i);
		}
		selectAmount = 0;
		display();
	}
}

function mark_false() {
	if(selectAmount < 1) {
		mousebutton.mark_false = !mousebutton.mark_false;
		if(mousebutton.mark_false)
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

function mark_true() {
	if(selectAmount < 1) {
		mousebutton.mark_true = !mousebutton.mark_true;
		if(mousebutton.mark_true)
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

function shift_right() {
	x-=20/scale;
	display();
}
function shift_left() {
	x+=20/scale;
	display();
}
function shift_up() {
	y+=20/scale;
	display();
}
function shift_down() {
	y-=20/scale;
	display();
}