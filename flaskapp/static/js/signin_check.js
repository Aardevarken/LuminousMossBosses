/*
 * Utils for Signin
 * These are used for the sake of the user to put in correct form posts
 * Prevent errors to be returned to them
 */

passwd = password("signup_password",1,2,1,2,1,2,1,2,8,12);

$("#signup_password, #signup_confirm_password").change(function(){checkSamePassword()});
$("#signup_password").keyup(function() {
    passwd.update()
});
function checkSamePassword() {
    password = document.getElementById("signup_password");
    confirm = document.getElementById("signup_confirm_password");
    if (password.value == confirm.value) {
        enableSubmit();
        password.style.backgroundColor = "white";
        confirm.style.backgroundColor = "white";
    }
    else {
        disableSubmit();
        password.style.backgroundColor = "#faa";
        confirm.style.backgroundColor = "#faa";
    }
}

/*
 * Password Strength
 * Min is the minimum required for a password
 * Max is how to suffice strong password
 */
function password(id, upper_min, upper_max, lower_min, lower_max, digit_min, digit_max, special_min,
                 ,special_max, length_min, length_max) {
    // Count
    this.lower_count = 0;
    this.upper_count = 0;
    this.digit_count = 0;
    this.special_count = 0;
    // Requirements to be meet
    this.lower_min = lower_min;
    this.upper_min = upper_min;
    this.digit_min = digit_min;
    this.special_min = special_min;
    this.length_min = length_min;
    this.lower_max = lower_max;
    this.upper_max = upper_max;
    this.digit_max = digit_max;
    this.special_max = special_max;
    this.length_max = length_max;
    // HTML 
    this.text = document.getElementById(id).value;
    this.bgcolor = document.getElementById.style.backgroundColor;
    // Methods
    this.updateStrength = function(index) {
        value = text.charCodeAt(index);
        if (value >= 65 && value <= 90)
            upper_count++
        else if (value >= 97 && value <= 122)
            lower_count++
        else if (value >= 48 && value <= 57)
            digit_count++
        else
            special_count++
    }

    this.getStrength = function() {
       if (this.upper_count < this.upper_min && this.lower_count < this.lower_min 
            && this.digit_count < this.digit_min && this.special_count < this.special_min 
            && this.text.length < this.length_min) {
            return "weak"
        }
        else if (this.upper_count >= this.upper_max && this.lower_count >= this.lower_max 
            && this.digit_count >= digit_max && this.special_count >= this.special_max 
            && this.text.length >= this.length_max) {
            return "strong"
        }
        return "good"
    }

    this.update = function() {
        total = this.upper_count + this.lower_count + this.digit_count + this.special_count;
        len = this.text.length
        if (total < len-2 || total >= len-1) {
            this.reset()
            for(var i = 0; i < len; i++)
                this.updateStrength(i);
        } else if (total == len-2) {
            this.updateStrength(len-1)
        }
    }

    this.reset = function() {
        this.lower_count = 0;
        this.upper_count = 0;
        this.digit_count = 0;
        this.special_count = 0;
    }
} 

function enableSubmit() {
    document.getElementById("signup_submit").disabled = false
}

function disableSubmit() {
    document.getElementById("signup_submit").disabled = true 
}
