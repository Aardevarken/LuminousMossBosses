/**
 * Extension to Array that allows for elements to be removed
 * Developed by John Resig
 */
Array.prototype.remove = function(from, to) {
	// Uses an || statement to check if 'to' is being passed, this allows for 1 or 2 parameters
	// The second || is used if a negative number is given
	var rest = this.slice((to || from) + 1 || this.length);
	this.length = from < 0 ? this.length + from : from;
	return this.push.apply(this, rest);
};

/**
 * Essential variables
 */
var canvas = document.getElementById("image_viewer");
var ctx;
var image = new Image();

/** IMAGE SOURCE FILE */
image.src = "example_flower.jpg";
//reference.src = "reference.png";
//1IMG_1997.jpg";

var scale = .3;
var asp = 1;
var x = -1060;
var y = -810;
var rot = 0;
var selected = -1;

rot_data = {
	k : 0,
	value : [],
	key : [],
	append : function(value) {
		this.value[this.value.length] = value;
		this.key[this.key.length] = this.k++;
	},
	pop : function(index) {
		this.value.splice(index,1);
		this.key.splice(index,1);
		this.k = (this.value.length === 0)? 0 : this.k
	},
	length : function() {
		return this.value.length;
	},
	getRow : function(key) {
		return this.key.indexOf(key);
	}
};

/**
 * Declare event handlers for mouse input
 */
canvas.onmousewheel 	= 	function(){ mousescroll(event) };

/**
 * Initialization main code
 */
image.onload = function() {
	ctx = canvas.getContext('2d');
	resetView();
}

window.onresize = function(event) {
	resetView();
};

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
		ctx.rotate(rot*Math.PI/180);
		ctx.scale(scale,scale);
		ctx.translate(-canvas.width/2,-canvas.height/2);
		ctx.translate(x,y);

		ctx.drawImage(image,0,0);

	ctx.restore();

	ctx.beginPath();
	ctx.moveTo(canvas.width/2,0);
	ctx.lineTo(canvas.width/2,canvas.height/2);
	ctx.closePath();
	ctx.lineWidth = 5;
	ctx.strokeStyle = "#f43"
	ctx.stroke();



	for (var i = 0; i < rot_data.length(); i++) {
		ctx.beginPath();
		var ri = -rot_data.value[i] + rot - 90;
		var xlen = canvas.width/2 + canvas.width*Math.cos(ri*Math.PI/180);
		var ylen = canvas.height/2 + canvas.height*Math.sin(ri*Math.PI/180);

		ctx.moveTo(canvas.width/2,canvas.height/2);
		ctx.lineTo(xlen,ylen);
		ctx.closePath();
		ctx.strokeStyle = (i == selected)? "#fff" : "#911";
		ctx.lineWidth = 5;
		ctx.stroke();
	}
}

/**
 * Handle mouse events
 */
mousescroll = function(e) {
	 e.preventDefault();
	var evt = window.event || e
	var delta = evt.detail? evt.detail*(-1) : evt.wheelDelta
	if(delta > 0)
		rotate(1);
	else if (delta <= 0)
		rotate(-1);
 }

/**
 * Reset orientation and scale
 */
function resetView() {
	canvas.width = document.getElementById('canvas_div').offsetWidth;
	canvas.height = canvas.width;
	length = pythagorean(canvas.width,canvas.height);
	amount = length/canvas.width;
	scale = Math.min(canvas.width/image.width, canvas.height/image.height)*amount;
	x = -image.width/2+canvas.width/2;
	y = (-image.height+canvas.height)/2
	display();
}

/**
 * Does pythagorean theorm
 */
function pythagorean(x,y) {
	return Math.sqrt(x*x + y*y);
}

/**
 * Rotate View
 */
function rotate(x) {
	var slider = document.getElementById("rot_value");
	value = parseInt(slider.value);
	value += x;
	value = (value > 0)? (value%360): 360+value
	slider.value = value
	setRotation();
}

/**
 * Rotate To Value
 */
function setRotation() {
	var slider = document.getElementById("rot_value");
	rot = parseInt(slider.value)
	display()
}

function addOrientation() {
	var table = document.getElementById("orientation_sheet");
	var rowCount = table.rows.length;
	var row = table.insertRow(rowCount);
	rot_data.append(rot);
	row.innerHTML ="<td><button class='btn btn-danger btn-circle' onmouseout='unselectRow()' onmouseover='selectRow("+rot_data.key[rowCount]+")' onclick='removeOrientation("+rot_data.key[rowCount]+")'>\
	<span class='glyphicon glyphicon-remove'></span></button></td>\
	<td>"+rot+"</td>"
	display();
}

function selectRow(i) {
	selected = rot_data.getRow(i)
	display();
}
function unselectRow() {
	selected = -1
	display();
}

function removeOrientation(i) {
	var table = document.getElementById("orientation_sheet");
	index = rot_data.getRow(i);
	table.deleteRow(index)
	rot_data.pop(index)
	display();
}
