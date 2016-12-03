<?php

namespace GPS Observations;

use Illuminate\Database\Eloquent\Model;

class Acc extends Model {

	protected $table = 'Account';
	public $timestamps = false;

	public function acc_obs()
	{
		return $this->hasMany('Obs', 'user_name');
	}

}