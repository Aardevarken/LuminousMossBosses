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

function getUrlVars() {
    var vars = {};
    var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi,
        function(m, keys, value) {
            vars[keys] = value;
        });
    return vars;
}

function addSelectOption(option, value, selected) {
    return '<option value="'+value+'" '+selected+' >'+option+'</option>'
}

function addSelection(verified) {
    var options = addSelectOption("N/A", "null", verified == null ? "selected" : "");
    options += addSelectOption("Not Silene", "false", verified == false ? "selected" : "");
    options += addSelectOption("Silene", "true", verified == true ? "selected" : "");
    return options;
}
function updateVerification(id) {
    console.log(id);
    var results = $("#id_"+id+" :selected").val()
    console.log(results);
    $.post("/cgi-bin/sponsor_verify.py?issilene="+results+"&obsid="+id);
}
